#!/bin/bash

# composer packages
composer require inertiajs/inertia-laravel

# Middleware
php artisan inertia:middleware

echo "<?php

namespace App\Http;

use Illuminate\Foundation\Http\Kernel as HttpKernel;

class Kernel extends HttpKernel
{
    /**
     * The application's global HTTP middleware stack.
     *
     * These middleware are run during every request to your application.
     *
     * @var array<int, class-string|string>
     */
    protected \$middleware = [
        // \App\Http\Middleware\TrustHosts::class,
        \App\Http\Middleware\TrustProxies::class,
        \Illuminate\Http\Middleware\HandleCors::class,
        \App\Http\Middleware\PreventRequestsDuringMaintenance::class,
        \Illuminate\Foundation\Http\Middleware\ValidatePostSize::class,
        \App\Http\Middleware\TrimStrings::class,
        \Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull::class,
    ];

    /**
     * The application's route middleware groups.
     *
     * @var array<string, array<int, class-string|string>>
     */
    protected \$middlewareGroups = [
        'web' => [
            \App\Http\Middleware\EncryptCookies::class,
            \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse::class,
            \Illuminate\Session\Middleware\StartSession::class,
            \Illuminate\View\Middleware\ShareErrorsFromSession::class,
            \App\Http\Middleware\VerifyCsrfToken::class,
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
            \App\Http\Middleware\HandleInertiaRequests::class,
        ],

        'api' => [
            // \Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful::class,
            \Illuminate\Routing\Middleware\ThrottleRequests::class . ':api',
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
        ],
    ];

    /**
     * The application's middleware aliases.
     *
     * Aliases may be used instead of class names to conveniently assign middleware to routes and groups.
     *
     * @var array<string, class-string|string>
     */
    protected \$middlewareAliases = [
        'auth' => \App\Http\Middleware\Authenticate::class,
        'auth.basic' => \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth::class,
        'auth.session' => \Illuminate\Session\Middleware\AuthenticateSession::class,
        'cache.headers' => \Illuminate\Http\Middleware\SetCacheHeaders::class,
        'can' => \Illuminate\Auth\Middleware\Authorize::class,
        'guest' => \App\Http\Middleware\RedirectIfAuthenticated::class,
        'password.confirm' => \Illuminate\Auth\Middleware\RequirePassword::class,
        'signed' => \App\Http\Middleware\ValidateSignature::class,
        'throttle' => \Illuminate\Routing\Middleware\ThrottleRequests::class,
        'verified' => \Illuminate\Auth\Middleware\EnsureEmailIsVerified::class,
    ];
}

" > ./app/Http/kernel.php

# npm packages
npm install --save-dev sass
npm install --save-dev bootstrap
npm install --save-dev @popperjs/core
npm install --save-dev @inertiajs/react
npm install --save-dev @vitejs/plugin-react
npm install --save-dev react-dom

# setup vite.config.js file
echo "import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [
        laravel({
            input: [
                'resources/sass/app.scss',
                'resources/js/app.jsx'
            ],
            refresh: true,
        }),
        react()
    ],
});
" > vite.config.js

# setup app layout app.blade.php
echo "<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Inertia</title>
    @viteReactRefresh
    @vite(['resources/sass/app.scss', 'resources/js/app.jsx'])
    @inertiaHead
</head>

<body>
    @inertia
</body>

</html>
" > ./resources/views/app.blade.php

# move app.js file to app.jsx
mv ./resources/js/app.js ./resources/js/app.jsx

# setup app.jsx file
echo 'import '\''./bootstrap'\'';
import { createRoot } from '\''react-dom/client'\'';
import { createInertiaApp } from '\''@inertiajs/react'\'';
import { resolvePageComponent } from '\''laravel-vite-plugin/inertia-helpers'\'';

createInertiaApp({
    resolve: (name) => resolvePageComponent(`./Pages/${name}.jsx`, import.meta.glob('\''./Pages/**/*.jsx'\'')),
    setup({ el, App, props }) {
        const root = createRoot(el);
        root.render(<App {...props} />);
    },
    progress: {
        delay: 250,
        color: '\''#28a745'\'',
        includeCSS: true,
        showSpinner: true,
    },
})
' > ./resources/js/app.jsx

# setup bootstrap.js
sed -i "1i import 'bootstrap';" ./resources/js/bootstrap.js

mkdir ./resources/js/Pages

# setup App.jsx component
echo 'import Layout from "./Layouts/Layout";

function App() {
    return (
        <Layout>
            <h1 className="text-center mt-5">Inertia ✅</h1>
        </Layout>
    )
}

export default App;
' > ./resources/js/Pages/App.jsx


# sass files
mkdir ./resources/sass

# setup _variables.scss
echo '$font-family-sans-serif: "Nunito", sans-serif;
$font-size-base: 0.9rem;
$line-height-base: 1.6;
' > ./resources/sass/_variables.scss

# setup app.scss
echo "// Fonts
@import url('https://fonts.bunny.net/css?family=Nunito');

// Variables
@import 'variables';

// Bootstrap
@import 'bootstrap/scss/bootstrap';
" > ./resources/sass/app.scss

# setup test pages
mkdir ./resources/js/Pages/Layouts
echo 'import Navbar from "./Navbar";

const Layout = ({ children }) => {
    return (
        <>
            <Navbar />
            <main>
                {children}
            </main>
        </>
    )
}

export default Layout;
' > ./resources/js/Pages/Layouts/Layout.jsx

echo 'import { Link } from "@inertiajs/react";

function Navbar() {
    return (
        <div>
            <nav className="navbar navbar-expand-lg bg-body-tertiary">
                <div className="container-fluid">
                    <Link className="navbar-brand" href="/">Home</Link>
                    <button className="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                        <span className="navbar-toggler-icon" />
                    </button>
                    <div className="collapse navbar-collapse" id="navbarNav">
                        <ul className="navbar-nav">
                            <li className="nav-item">
                                <Link href="/test" className="nav-link btn border-0 active" as="button">Test</Link>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
        </div>
    )
}

export default Navbar;

' > ./resources/js/Pages/Layouts/Navbar.jsx

echo 'import Layout from "./Layouts/Layout";

function Test() {
    return (
        <Layout>
            <h1 className="text-center mt-5">Test✅</h1>
        </Layout>
    )
}

export default Test;
' > ./resources/js/Pages/Test.jsx

echo "<?php

use Inertia\Inertia;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return Inertia::render('App');
});

Route::get('/test', function () {
    return Inertia::render('Test');
});
" > ./routes/web.php

# compile scripts
npm run dev
