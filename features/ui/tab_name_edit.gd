class_name RenameTabContainer
extends PanelContainer

@export var line_edit : LineEdit

signal on_new_text_submitted(text : String)

var new_name : String
var current_tab : Tab

func _ready() -> void:
	#tab_container.tab_button_clicked.connect(on_tab_clicked)
	visible = false
	
func bind_services(tab_container : ImageTabContainer):
	tab_container.on_open_rename_tab.connect(on_tab_clicked)
	line_edit.text_changed.connect(_on_tab_name_edit_text_changed)

func on_tab_clicked(tab : Tab):
	current_tab = tab
	visible = true
	on_new_text_submitted.connect(tab.set_new_name)
	line_edit.text = tab.name
	new_name = line_edit.text

func _on_tab_name_edit_text_changed(new_text: String) -> void:
	new_name = new_text



func _on_button_pressed() -> void:
	on_new_text_submitted.emit(new_name)
	on_new_text_submitted.disconnect(current_tab.set_new_name)
	visible = false
	

func _on_button_2_pressed() -> void:
	on_new_text_submitted.disconnect(current_tab.set_new_name)
	visible = false
