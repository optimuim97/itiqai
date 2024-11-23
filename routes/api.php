<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/me', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/me', function (Request $request) {
    return response()->json(["message" =>"User is not logged in"]);
});
