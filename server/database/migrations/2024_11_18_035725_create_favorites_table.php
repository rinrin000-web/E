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
        Schema::create('favorites', function (Blueprint $table) {
            $table->id();
            $table->String('user_email');
            $table->string('team_no');
            $table->boolean('is_favorite')->default(false);

            $table->foreign('user_email')->references('email')->on('users')->onDelete('cascade');
            $table->foreign('team_no')->references('team_no')->on('teams')->onDelete('cascade');
            $table->timestamp('favorited_at')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('favorites');
    }
};
