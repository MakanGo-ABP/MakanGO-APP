<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Kreait\Firebase\Contract\Auth as FirebaseAuth;
use Kreait\Firebase\Contract\Firestore;
use Kreait\Firebase\Exception\AuthException;

class AuthController extends Controller
{
    protected $auth;
    protected $firestore;

    public function __construct(FirebaseAuth $auth, Firestore $firestore)
    {
        $this->auth = $auth;
        $this->firestore = $firestore;
    }

    public function register(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|min:6',
        'name' => 'required|string',
    ]);

    try {
        $userProperties = [
            'email' => $request->email,
            'password' => $request->password,
            'displayName' => $request->name,
        ];
        $user = $this->auth->createUser($userProperties);

        $otp = random_int(100000, 999999);
        $expiresAt = now()->addMinutes(5);

        $this->firestore->database()->collection('OTPs')->document($user->uid)->set([
            'otp' => $otp,
            'expires_at' => $expiresAt->toDateTimeString(),
            'email' => $request->email,
        ]);

        Mail::to($request->email)->send(new OtpMail($otp));

        return response()->json([
            'message' => 'User created, OTP sent to email',
            'uid' => $user->uid,
        ], 201);
    } catch (AuthException $e) {
        return response()->json(['error' => $e->getMessage()], 400);
    }
}

public function verifyOtp(Request $request)
{
    $request->validate([
        'uid' => 'required|string',
        'otp' => 'required|string',
    ]);

    try {
        $otpDoc = $this->firestore->database()->collection('OTPs')->document($request->uid)->snapshot();
        if (!$otpDoc->exists()) {
            return response()->json(['error' => 'OTP not found'], 400);
        }

        $otpData = $otpDoc->data();
        $expiresAt = \Carbon\Carbon::parse($otpData['expires_at']);

        if (now()->greaterThan($expiresAt)) {
            return response()->json(['error' => 'OTP expired'], 400);
        }

        if ($otpData['otp'] != $request->otp) {
            return response()->json(['error' => 'Invalid OTP'], 400);
        }

        $this->firestore->database()->collection('OTPs')->document($request->uid)->delete();

        $this->firestore->database()->collection('User')->document($request->uid)->set([
            'created_at' => now()->toDateTimeString(),
            'email' => $otpData['email'],
            'jumlah_review' => 0,
            'level' => 1,
            'name' => $request->name ?? 'Unknown',
            'uid' => $request->uid,
            'username' => null,
        ]);

        return response()->json(['message' => 'OTP verified, registration complete'], 200);
    } catch (\Exception $e) {
        return response()->json(['error' => $e->getMessage()], 500);
    }
}

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        try {
            $signInResult = $this->auth->signInWithEmailAndPassword($request->email, $request->password);
            $user = $signInResult->data();

            $userDoc = $this->firestore->database()->collection('User')->document($user['localId'])->snapshot();
            $userData = $userDoc->exists() ? $userDoc->data() : [];

            return response()->json([
                'message' => 'Login successful',
                'user' => [
                    'uid' => $user['localId'],
                    'email' => $user['email'],
                    'name' => $user['displayName'] ?? $userData['name'] ?? null,
                ],
            ]);
        } catch (AuthException $e) {
            return response()->json(['error' => $e->getMessage()], 401);
        }
    }

    public function googleLogin(Request $request)
    {
        $request->validate([
            'idToken' => 'required|string',
            'name' => 'required|string',
        ]);

        try {
            $verifiedIdToken = $this->auth->verifyIdToken($request->idToken);
            $uid = $verifiedIdToken->claims()->get('sub');

            $userDoc = $this->firestore->database()->collection('User')->document($uid)->snapshot();
            if (!$userDoc->exists()) {
                $this->firestore->database()->collection('User')->document($uid)->set([
                    'created_at' => now()->toDateTimeString(),
                    'email' => $verifiedIdToken->claims()->get('email'),
                    'jumlah_review' => 0,
                    'level' => 1,
                    'name' => $request->name,
                    'uid' => $uid,
                    'username' => null,
                ]);
            }

            return response()->json([
                'message' => 'Google login successful',
                'user' => [
                    'uid' => $uid,
                    'email' => $verifiedIdToken->claims()->get('email'),
                    'name' => $request->name,
                ],
            ]);
        } catch (AuthException $e) {
            return response()->json(['error' => $e->getMessage()], 401);
        }
    }
}