class_name RunEvent
extends RefCounted

var triggered := false
var introEvent := false
var id := ""

func can_trigger() -> bool:
	return false

func trigger():
	triggered = true
