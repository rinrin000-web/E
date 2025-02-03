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
        Schema::create('teams', function (Blueprint $table) {
            $table->string('team_no')->primary(); // team_no là khóa chính
            $table->string('teamfileimages')->nullable(); // teamfileimages có thể để trống
            $table->unsignedBigInteger('floor_no'); // floor_no là khóa ngoại
            $table->double('rank')->nullable();  // rank có thể để trống
            $table->timestamps(); // created_at và updated_at

            // Định nghĩa khóa ngoại
            $table->foreign('floor_no')->references('floor_no')->on('floors')->onDelete('cascade');
            // $table->foreign('team_no')->references('team_no')->on('events')->onDelete('cascade');
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('teams');
    }
};