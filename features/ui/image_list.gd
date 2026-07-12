class_name ImageList
extends VBoxContainer

const data_path := "res://data/"
const item_path := preload("res://features/ui/item.tscn")

signal image_selected(image : Item)
signal on_item_add_slideshow(item: Item, value : bool)

signal image_loaded(title : String, path : String)

func build_services(image_paths : Array[String] = []):
	if image_paths.size() > 0:
		load_items(image_paths)

func bind_services(slideshow : SlideShow, tab_container : ImageTabContainer):
	image_selected.connect(slideshow.transition)
	image_selected.connect(tab_container.on_image_selected)
	on_item_add_slideshow.connect(slideshow.on_item_list_on_item_add_slideshow)
	image_loaded.connect(tab_container.on_update_setup)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().get_window().files_dropped.connect(load_items)

func load_items(paths : PackedStringArray,  prefix_path : String = ""):
	image_loaded.emit("image_paths", paths)
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
		item.add_item(file_name, image)
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

func erase_item(item : Item):
	on_item_add_slideshow.emit(item, false)
	item.queue_free()

func toggle_all_not_current():
	for item in get_children():
		item.toggle_current(false)
