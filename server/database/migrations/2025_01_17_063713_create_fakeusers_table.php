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
        Schema::create('fakeusers', function (Blueprint $table) {
            $table->id(); // Khóa chính tự động tăng
            $table->integer('fakeUserCount'); // Số lượng người dùng giả
            $table->bigInteger('floor_no')->unsigned()->nullable(); // Khóa ngoại liên kết với floors
            $table->unsignedBigInteger('event_id')->nullable(); // Cột mới 'event' liên kết với eventsmanage
            $table->timestamps();

            // Khóa ngoại liên kết với bảng 'floors'
            $table->foreign('floor_no')
                  ->references('floor_no')
                  ->on('floors')
                  ->onDelete('set null'); // Nếu xóa floor, giá trị sẽ đặt thành null

            // Khóa ngoại liên kết với bảng 'eventsmanage'
            $table->foreign('event_id')
                  ->references('event_id') // Khóa chính của bảng `eventsmanage`
                  ->on('eventsmanage')
                  ->onDelete('set null'); // Nếu xóa sự kiện, giá trị sẽ đặt thành null
        });
    }


    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('fakeusers');
    }
};
