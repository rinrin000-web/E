<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Memberimages extends Model
{
    protected $table = 'memberimages';
    protected $primaryKey = 'id';
    protected $fillable = [
        'id',
        'team_no',
        'memberfileimages',
    ];
    use HasFactory;
}