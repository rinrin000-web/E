<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Floor extends Model
{
    protected $table = 'floors';
    protected $primaryKey = 'id';
    protected $fillable = ['floor_no','contents'];
    use HasFactory;
    public function teams()
    {
        return $this->hasMany(Team::class, 'floor_no', 'floor_no');
    }
    public function users()
    {
        return $this->hasMany(User::class, 'floor_no', 'floor_no');
    }
}