<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Team extends Model
{
    protected $table = 'teams';
    protected $primaryKey = 'team_no';
    protected $keyType = 'string';
    protected $fillable = ['team_no', 'teamfileimages', 'floor_no', 'rank'];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function favorites() {
        return $this->hasMany(Favorite::class);
    }
    use HasFactory;
}