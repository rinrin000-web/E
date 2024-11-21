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
        Schema::create('overview', function (Blueprint $table) {
            $table->id(); // Trường id tự động tăng
            $table->string('team_no'); // Trường team_no
            $table->string('slogan'); // Trường slogan, không null
            $table->text('overallplanning'); // Trường overallplanning, không null
            $table->text('techused'); // Trường techused, không null
            $table->text('tools'); // Trường tools, không null
            $table->timestamps(); // Thêm created_at và updated_at

            // Thiết lập khóa ngoại với bảng teams
            $table->foreign('team_no')->references('team_no')->on('teams')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('overview');
    }
};