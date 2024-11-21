<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminAuth
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        //auth()->check() 認証済かどうか
        //auth()->user()->is_admin == true adminかどうか
        if(auth()->check() && auth()->user()->is_admin == true) {
            return $next($request);
        }

        abort(403, 'This action is unauthorized.');
    }
}
