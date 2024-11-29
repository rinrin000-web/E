<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Eventsmange extends Model
{
    protected $table = 'eventsmanage';
    protected $primaryKey = 'id';
    protected $fillable = ['event_id','team_no'];
    use HasFactory;
    public function event()
    {
        return $this->belongsTo(Event::class, 'id','event_id');
    }
}