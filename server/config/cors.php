<?php

return [

    // 'paths' => ['api/*', 'sanctum/csrf-cookie','storage/teams*'],
    'paths' => ['*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['*'],
     // 許可するリクエストオリジンの設定
    //'allowed_origins' => ['http://localhost:8000'],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];