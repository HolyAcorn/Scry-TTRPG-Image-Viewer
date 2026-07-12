extends PanelContainer
class_name Item

@export var default_style_box : StyleBoxFlat
@export var current_style_box : StyleBoxFlat

@export var make_current_btn : Button
@export var remove_btn : Button
@export var label : Label

var _image : Image

signal on_make_current(item : Item, image : Image)
signal on_remove(item :Item)
signal toggle_add_slideshow(item : Item, value : bool)

func build_services():
	pass
	
func bind_services(image_list : ImageList):
	on_make_current.connect(image_list.on_image_selected)
	toggle_add_slideshow.connect(image_list.on_toggle_add_slideshow)
	on_remove.connect(image_list.erase_item)

func _ready() -> void:
	add_theme_stylebox_override("panel", default_style_box)

func add_item(file_name : String, image : Image):
	label.text = file_name
	_image = image

func _on_make_current_btn_pressed() -> void:
	toggle_current(true)
	on_make_current.emit(self, _image)

func _on_remove_btn_pressed() -> void:
	on_remove.emit(self)


func _on_check_box_toggled(toggled_on: bool) -> void:
	toggle_add_slideshow.emit(self, toggled_on)

func toggle_current(value : bool):
	make_current_btn.disabled = value
	remove_btn.disabled = value
	if value:
		add_theme_stylebox_override("panel", current_style_box)
	else:
		add_theme_stylebox_override("panel", default_style_box)
