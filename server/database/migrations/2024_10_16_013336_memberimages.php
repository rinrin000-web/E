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
        Schema::create('memberimages', function (Blueprint $table) {
            $table->id(); // Tạo trường id (khoá chính, tự động tăng)
            $table->string('team_no'); // Trường team_no
            $table->string('memberfileimages')->nullable(true);
            $table->timestamps();
            $table->foreign('team_no')->references('team_no')->on('teams')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('memberimages');
    }
};