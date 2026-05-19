extends Node

var money := 0
var current_week := 1
var current_day := 1

var day_late_packages := 0
var day_broken_packages := 0

var player_health := 5

var stats: RunStats = RunStats.new()

func get_days_passed() -> int: return current_day + (current_week-1)*5
