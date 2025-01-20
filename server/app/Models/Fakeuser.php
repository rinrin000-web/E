<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Fakeuser extends Model
{
    use HasFactory;
    protected $fillable = [
        'fakeUserCount',
        'floor_no',
    ];
}