extends PanelContainer

@export var tab_container : ImageTabContainer

@export var line_edit : LineEdit

signal on_new_text_submitted(text : String)

var new_name : String

func _ready() -> void:
	#tab_container.tab_button_clicked.connect(on_tab_clicked)
	visible = false

func on_tab_clicked(node : ImageList):
	visible = true
	on_new_text_submitted.connect(node.set_new_name)
	line_edit.text = node.name
	new_name = line_edit.text

func _on_tab_name_edit_text_submitted(new_text: String) -> void:
	new_name = new_text



func _on_button_pressed() -> void:
	on_new_text_submitted.emit(new_name)
	visible = false
	

func _on_button_2_pressed() -> void:
	visible = false
