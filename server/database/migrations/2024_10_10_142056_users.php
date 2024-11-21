<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        //
        Schema::create('users', function (Blueprint $table) {
            $table->bigIncrements('user_id');
            $table->string('email')->unique()->nullable(false);
            $table->string('password')->nullable(false);
            $table->string('floor_no')->nullable();
            $table->string('api_token', 80)->unique()->nullable()->default(null)->comment('guardが参照するapi_token');
            $table->boolean('is_admin')->default(false)->comment('trueだとadmin権限を持つ');
            $table->rememberToken();
            $table->timestamps();

            $table->foreign('floor_no')->references('floor_no')->on('floors')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('users');
    }
};