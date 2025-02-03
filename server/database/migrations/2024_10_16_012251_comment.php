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
        Schema::create('comment', function (Blueprint $table) {
            $table->id(); // Tạo trường id
            $table->string('team_no'); // Trường team_no
            $table->string('comment_user'); // Trường comment_user

            // Các trường điểm số
            $table->integer('rank')->nullable();
            $table->integer('present')->nullable();
            $table->integer('plan')->nullable();
            $table->integer('design')->nullable();
            $table->integer('tech')->nullable();

            $table->text('comment')->nullable();
            $table->boolean('ispublic')->default(1)->after('comment');

            // Định nghĩa khoá ngoại
            $table->foreign('team_no')->references('team_no')->on('teams')->onDelete('cascade');
            $table->foreign('comment_user')->references('email')->on('users')->onDelete('cascade');

            $table->timestamps(); // Timestamps cho created_at và updated_at
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('comment');
    }
};