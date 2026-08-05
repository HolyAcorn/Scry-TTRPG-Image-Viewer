class_name SetupController
extends Node

@export var save_setup_file_dialog : FileDialog
@export var load_setup_file_dialog : FileDialog

var setup : Setup

signal on_setup_changed(setup : Setup)

func build_services():
	setup = Setup.new()
	setup = setup.new_default_setup(Tween.EaseType.EASE_IN_OUT, Tween.TransitionType.TRANS_CUBIC, 5.0, 0.5)
	save_setup_file_dialog.visible = false
	load_setup_file_dialog.visible = false
	save_setup_file_dialog.file_selected.connect(on_save_setup_file_selected)
	load_setup_file_dialog.file_selected.connect(on_load_setup_file_selected)
	
func bind_serivces():
	pass

func show_save_setup():
	save_setup_file_dialog.visible = true

func show_load_setup():
	load_setup_file_dialog.visible = true

func on_save_setup_file_selected(path : String):
	var json = JsonConverter.setup_to_json(setup)
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	save_file.store_string(json)
	
func on_load_setup_file_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		setup = JsonConverter.json_to_setup(json.data)
		on_setup_changed.emit(setup)
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", file.get_as_text(), " at line ", json.get_error_line())

func update_setup(property_name : String, value : Variant, tab_index : int = 0):
	match property_name:
		"title":
			setup.tabs[tab_index].title = value
		"duration":
			setup.tabs[tab_index].duration = value
		"fade_duration":
			setup.tabs[tab_index].fade_duration = value
		"ease_type":
			setup.tabs[tab_index].ease_type = value
		"trans_type":
			setup.tabs[tab_index].trans_type = value
		"image_paths":
			for path in value:
				setup.tabs[tab_index].image_paths.append(path)
		"current_tab":
			setup.current_tab = value
		"current_item_index":
			setup.current_item_index = value
	on_setup_changed.emit(setup)

func update_image_paths(paths : Array[String], tab_index : int, is_slideshow : bool = false):
	for path in paths:
		var item_image : Setup.ImageItem = Setup.ImageItem.new()
		item_image.path = path
		item_image.is_slideshow = is_slideshow
		setup.tabs[tab_index].image_paths.append(item_image)

func update_image_slideshow(item: Item, tab_index : int, is_slideshow : bool):
	for i in range(setup.tabs[tab_index].image_paths.size()):
		if setup.tabs[tab_index].image_paths[i].path == item.path:
			setup.tabs[tab_index].image_paths[i].is_slideshow = is_slideshow
			
func add_tab(title : String):
	var tab_resource := Setup.TabResource.new()
	tab_resource.title = title
	tab_resource.ease_type = Tween.EaseType.EASE_IN_OUT
	tab_resource.trans_type = Tween.TransitionType.TRANS_CUBIC
	tab_resource.duration = 5.0
	tab_resource.fade_duration = 0.5
	setup.tabs.append(tab_resource)

func remove_image(tab_index : int, image_path : String):
	for image in setup.tabs[tab_index].image_paths:
		if image.path == image_path:
			setup.tabs[tab_index].image_paths.erase(image)
			break
