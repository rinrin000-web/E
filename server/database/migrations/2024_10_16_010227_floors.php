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
            $table->bigIncrements('id'); // Tạo cột id làm khóa chính tự động tăng
            $table->bigInteger('floor_no')->unsigned()->unique(); // floor_no được đảm bảo là duy nhất nhưng không làm khóa chính
            $table->string('contents')->nullable(); // contents có thể NULL
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