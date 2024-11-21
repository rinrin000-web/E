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
        Schema::create('floors', function (Blueprint $table) {
            $table->bigIncrements('floor_no'); // Tạo team_id là khóa chính tự động tăng
            $table->string('contents')->nullable(); // team_no là duy nhất
            $table->timestamps(0); // created_at và updated_at
        });

    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('floors');
    }
};