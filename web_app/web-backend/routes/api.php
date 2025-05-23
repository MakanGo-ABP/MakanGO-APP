<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login', [AuthController::class, 'login']);
    Route::post('google-login', [AuthController::class, 'googleLogin']);
    Route::post('otp/verify', [AuthController::class, 'verifyOtp']);

 
});

Route::middleware('firebase')->get('user', function (Request $request) {
    return response()->json(['user_id' => $request->attributes->get('firebase_user')]);
});