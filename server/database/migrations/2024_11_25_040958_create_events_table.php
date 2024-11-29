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
        Schema::create('events', function (Blueprint $table) {
            $table->id();
            $table->string('event_name')->unique();
            $table->text('event_description')->nullable();
            $table->dateTime('event_date');
            // $table->boolean('is_active')->default(true)->nullable();
            // $table->string('team_no')->unique();
            // $table->string('user');
            $table->string('images')->nullable();
            $table->timestamps();

            // $table->foreign('team_no')->references('team_no')->on('teams')->onDelete('cascade');
            // $table->foreign('user')->references('email')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('events');
    }
};