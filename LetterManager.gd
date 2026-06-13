class_name LetterManager
extends Panel

@export var finish_text: String
@export var continue_button: Button
@export var pages: Array[Control]
@export var loop_pages: bool
var current_page = 0

signal finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_all_pages()
	current_page = 0
	show_page(current_page)
	continue_button.pressed.connect(next_page)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func next_page():
	hide_page(current_page)
	
	if current_page + 1 >= len(pages):
		if loop_pages:
			current_page = 0
		else:
			finished.emit()
			GameManager.start_day()
	else:
		current_page += 1
		
	show_page(current_page)
	
	if current_page + 1 >= len(pages):
		continue_button.text = finish_text

func show_page(index: int):
	pages[index].show()

func hide_page(index: int):
	pages[index].hide()

func hide_all_pages():
	if len(pages) <= 0: return
	
	for page in pages:
		page.hide()
