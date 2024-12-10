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

    public function comment()
{
    return $this->belongsTo(Comment::class, 'team_no', 'team_no');
}
// public function event()
// {
//     return $this->belongsTo(Event::class, 'team_no', 'team_no');
// }
public function eventsManage()
{
    return $this->hasMany(Eventsmange::class, 'team_no', 'team_no');
}

    use HasFactory;
}