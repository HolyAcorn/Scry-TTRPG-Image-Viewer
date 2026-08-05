class_name ImageList
extends VBoxContainer

const data_path := "res://data/"
const item_path := preload("res://features/ui/item.tscn")

var tab_index : int

signal image_selected(image : Item)
signal on_item_add_slideshow(item: Item, value : bool)
signal on_update_image_slideshow(item : Item, tab_index : int, is_slideshow : bool)

signal image_loaded(paths : PackedStringArray, tab_index : int)
signal on_remove_item(tab_index : int, image_path : String)

func build_services(tab : int, images : Array[Setup.ImageItem] = []):
	if images.size() > 0:
		load_items_from_setup(images)
	tab_index = tab

func bind_services(slideshow : SlideShow, tab_container : ImageTabContainer, setup_controller : SetupController):
	image_selected.connect(slideshow.transition)
	image_selected.connect(tab_container.on_image_selected)
	on_item_add_slideshow.connect(slideshow.on_item_list_on_item_add_slideshow)
	image_loaded.connect(setup_controller.update_image_paths)
	on_update_image_slideshow.connect(setup_controller.update_image_slideshow)
	on_remove_item.connect(setup_controller.remove_image)
	#image_loaded.connect(tab_container.on_update_setup)

func load_items(paths : PackedStringArray,  prefix_path : String = ""):
	image_loaded.emit(paths, tab_index)
	for file in paths:
		var image = Image.load_from_file(prefix_path + file)
		var regex = RegEx.create_from_string("\\/.*\\/(\\w+.\\w+)")
		var result = regex.search(file)
		var file_name = file
		if result:
			file_name = result.strings[1]
		if file.contains(".import"):
			continue
		var item = item_path.instantiate() as Item
		item.add_item(file_name, image, false, file)
		item.build_services()
		item.bind_services(self)
		add_child(item)

func load_items_from_setup(images : Array[Setup.ImageItem]):
	var paths : Array[String]
	for image in images:
		paths.append(image.path)
	image_loaded.emit(paths, tab_index)
	for item_image in images:
		var file = item_image.path
		var image = Image.load_from_file(file)
		var regex = RegEx.create_from_string("\\/.*\\/(\\w+.\\w+)")
		var result = regex.search(file)
		var file_name = file
		if result:
			file_name = result.strings[1]
		if file.contains(".import"):
			continue
		var item = item_path.instantiate() as Item
		item.add_item(file_name, image, item_image.is_slideshow, file)
		item.build_services()
		item.bind_services(self)
		add_child(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_image_selected(item : Item, image : Image):
	for _item in get_children():
		if _item is not Item:
			continue
		if _item == item:
			continue
		_item.toggle_current(false)
	image_selected.emit(item)
	#ItemHandler.current_item = item

func on_toggle_add_slideshow(item : Item, value : bool):
	on_item_add_slideshow.emit(item, value)
	on_update_image_slideshow.emit(item, tab_index, value)

func erase_item(item : Item):
	on_item_add_slideshow.emit(item, false)
	on_remove_item.emit(tab_index, item.path)
	item.queue_free()

func toggle_all_not_current():
	for item in get_children():
		item.toggle_current(false)

func disconnect_load_signal():
	get_viewport().get_window().files_dropped.disconnect(load_items)
	
func connect_load_signal():
	get_viewport().get_window().files_dropped.connect(load_items)
