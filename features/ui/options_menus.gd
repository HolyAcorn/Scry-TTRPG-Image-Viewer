class_name OptionsMenu
extends GridContainer

const  EASE_TYPES : PackedStringArray = [
	"EASE IN",
	"EASE OUT",
	"EASE IN OUT",
	"EASE OUT IN",
]

const TRANS_TYPES : PackedStringArray = [
	"TRANS LINEAR",
	"TRANS SINE",
	"TRANS QUINT",
	"TRANS QUART",
	"TRANS QUAD",
	"TRANS EXPO",
	"TRANS ELASTIC",
	"TRANS CUBIC",
	"TRANS CIRC",
	"TRANS BOUNCE",
	"TRANS BACK",
	"TRANS SPRING",
]

@export var ease_type_btn : OptionButton
@export var trans_type_btn : OptionButton
@export var duration_line_edit : LineEdit
@export var fade_duration_line_edit : LineEdit

var number_line_edit_regex : RegEx
var old_duration_text = ""
var old_fade_duration_text = ""

signal update_setup(property_name : String, value : Variant)

func build_services(setup_controller : SetupController, tab_index : int):
	for ease_type in  EASE_TYPES:
		ease_type_btn.add_item(ease_type)
	for trans_type in TRANS_TYPES:
		trans_type_btn.add_item(trans_type)
	number_line_edit_regex = RegEx.new()
	number_line_edit_regex.compile("^[0-9.]*$")
	
	duration_line_edit.text = str(setup_controller.setup.tabs[tab_index].duration)
	fade_duration_line_edit.text = str(setup_controller.setup.tabs[tab_index].fade_duration)
	old_duration_text = duration_line_edit.text
	old_fade_duration_text = fade_duration_line_edit.text
	trans_type_btn.select(setup_controller.setup.tabs[tab_index].trans_type)
	ease_type_btn.select(setup_controller.setup.tabs[tab_index].ease_type)
	
func bind_services(tab_container : ImageTabContainer):
	update_setup.connect(tab_container.on_update_setup)
	tab_container.setup_loaded.connect(on_load_setup)
	
	ease_type_btn.item_selected.connect(_on_ease_type_btn_item_selected)
	fade_duration_line_edit.text_submitted.connect(_on_fade_duration_line_edit_text_changed)
	duration_line_edit.text_submitted.connect(_on_duration_line_edit_text_changed)
	trans_type_btn.item_selected.connect(_on_trans_type_btn_item_selected)


func on_load_setup(setup : Setup, tab_index : int):
	duration_line_edit.text = str(setup.tabs[tab_index].duration)
	fade_duration_line_edit.text = str(setup.tabs[tab_index].fade_duration)
	old_duration_text = duration_line_edit.text
	old_fade_duration_text = fade_duration_line_edit.text
	trans_type_btn.select(setup.tabs[tab_index].trans_type)
	ease_type_btn.select(setup.tabs[tab_index].ease_type)

func _on_duration_line_edit_text_changed(new_text: String) -> void:
	if number_line_edit_regex.search(new_text):
		old_duration_text = new_text
	else:
		duration_line_edit.text = old_duration_text
		duration_line_edit.caret_column = duration_line_edit.text.length()
	update_setup.emit("duration", float(duration_line_edit.text))


func _on_fade_duration_line_edit_text_changed(new_text: String) -> void:
	if number_line_edit_regex.search(new_text):
		old_fade_duration_text = new_text
	else:
		fade_duration_line_edit.text = old_fade_duration_text
		fade_duration_line_edit.caret_column = fade_duration_line_edit.text.length()
	update_setup.emit("fade_duration", float(fade_duration_line_edit.text))


func _on_trans_type_btn_item_selected(index: int) -> void:
	update_setup.emit("trans_type", index)


func _on_ease_type_btn_item_selected(index: int) -> void:
	update_setup.emit("ease_type", index)
