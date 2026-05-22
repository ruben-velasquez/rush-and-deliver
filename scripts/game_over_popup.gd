extends Control
class_name GameOverPopUp

@export var info: RichTextLabel

func setup():
	var output = ""
	
	# Here could be the stats
	output += "Your car exploded and you died"
	
	info.text = output
