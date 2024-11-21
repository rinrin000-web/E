<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    protected $table = 'comment';
    protected $primaryKey = 'id';
    protected $fillable = [
        'team_no',
        'comment_user',
        'rank',
        'present',
        'plan',
        'design',
        'tech',
        'comment'
    ];
    use HasFactory;
}