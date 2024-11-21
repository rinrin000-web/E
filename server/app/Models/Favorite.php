<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Favorite extends Model
{
    protected $table = 'favorites';
    protected $primaryKey = 'id';
    protected $fillable = [
        'team_no',
        'user_email',
        'is_favorite',
        'favorited_at'
    ];
    public function user() {
        return $this->belongsTo(User::class);
    }
    public function teams() {
        return $this->belongsTo(Team::class);
    }
    use HasFactory;
}