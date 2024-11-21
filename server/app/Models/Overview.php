<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Overview extends Model
{
    protected $table = 'overview';
    protected $primaryKey = 'id';
    protected $fillable = [
        'team_no',
        'slogan',
        'overallplanning',
        'techused',
        'tools'
    ];
    use HasFactory;
}