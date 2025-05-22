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

            $this->firestore->database()->collection('User')->document($user->uid)->set([
                'created_at' => now()->toDateTimeString(),
                'email' => $request->email,
                'jumlah_review' => 0,
                'level' => 1,
                'name' => $request->name,
                'uid' => $user->uid,
                'username' => null, 
            ]);

            return response()->json([
                'message' => 'User registered successfully',
                'user' => [
                    'uid' => $user->uid,
                    'email' => $user->email,
                    'name' => $user->displayName,
                ],
            ], 201);
        } catch (AuthException $e) {
            return response()->json(['error' => $e->getMessage()], 400);
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