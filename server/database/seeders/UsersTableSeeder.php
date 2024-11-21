<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        //userのダミーデータを2つ作成
        DB::table('users')->insert([
            [
                //admin権限を持つユーザー
                'email' => 'admin@gmail.com',
                'is_admin' => true,
                'password' => bcrypt('123456'),
                'api_token' => Str::random(60),
            ],
            [
                //admin権限を持たないユーザー
                'email' => 'user@gmail.com',
                'is_admin' => false,
                'password' => bcrypt('123456'),
                'api_token' => Str::random(60),
            ],
        ]);
    }
    }
