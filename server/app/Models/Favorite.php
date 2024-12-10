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
    public function team()
    {
        return $this->belongsTo(Team::class, 'team_no', 'team_no');
    }
    public function events()
    {
        return $this->hasManyThrough(Event::class, Eventsmange::class, 'team_no', 'id', 'team_no', 'event_id');
    }
    use HasFactory;
}