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
        Schema::create('floors', function (Blueprint $table) {
            $table->id(); // Tạo cột id làm khóa chính tự động tăng
            $table->bigInteger('floor_no')->unsigned(); // Cột floor_no kiểu bigInteger không dấu
            $table->string('contents')->nullable(); // Cột contents có thể null
            $table->timestamps(0); // Tạo created_at và updated_at
            $table->bigInteger('event_id')->nullable()->unsigned(); // Cột event_id kiểu bigInteger không dấu và có thể null
            $table->integer('fakeusercount')->default(0); // Cột fakeusercount kiểu integer với giá trị mặc định là 0

            // Đảm bảo tính duy nhất của cặp (event_id, floor_no)
            $table->unique(['event_id', 'floor_no']);

            // Thêm khóa ngoại với bảng eventsmanage
            $table->foreign('event_id')
                  ->references('event_id')
                  ->on('eventsmanage')
                  ->onDelete('cascade') // Xóa dòng khi sự kiện bị xóa
                  ->onUpdate('cascade'); // Cập nhật khi sự kiện bị thay đổi
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('floors');
    }
};