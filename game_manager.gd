extends Node


@export var intermission_music: AudioStreamPlayer
var transition_img
var transition_tex

var p1_lives = 4
var p2_lives = 4

var p1_just_failed = false
var p2_just_failed = false

var round_count = 0

var speed_up_now = false
var level_up_now = false

var game_speed = 1
var game_level = 1
