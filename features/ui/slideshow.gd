extends Node
class_name SlideShow


@export var duration : float
@export var transition_type : Tween.TransitionType
@export var ease_type : Tween.EaseType
@export var fade_duration : float


signal update_image(new_image :Image)
signal toggle_slideshow_btn_disabled(disabled : bool)
signal set_slideshow_btn_text(text : String)

var items : Array[Item]
var image : TextureRect
var current_item : Item
var is_slideshowing := false

func build_services(image_window : ImageWindow):
	image = image_window.texture
	
func bind_services(image_window : ImageWindow):
	update_image.connect(image_window.set_texture)

func _ready() -> void:
	if items.size() == 0:
		toggle_slideshow_btn_disabled.emit(true)

func on_slideshow():
	if items.size() == 0:
		return
	is_slideshowing = !is_slideshowing
	if is_slideshowing:
		current_item.toggle_current(false)
		slideshow()
		set_slideshow_btn_text.emit("Stop Slideshow")
	else:
		set_slideshow_btn_text.emit("Start Slideshow")
	
func slideshow():
	while is_slideshowing:
		for item in items:
			item.toggle_current(true)
			await transition(item)
			await get_tree().create_timer(duration).timeout
			if !is_slideshowing:
				break
			item.toggle_current(false)

func transition(new_item : Item):
	var tween = get_tree().create_tween().set_ease(ease_type).set_trans(transition_type)
	tween.tween_property(image, "modulate", Color(1,1,1,0), fade_duration/2)
	await tween.finished
	update_image.emit(new_item._image)
	current_item = new_item
	tween = get_tree().create_tween().set_ease(ease_type).set_trans(transition_type)
	tween.tween_property(image, "modulate", Color(1,1,1,1), fade_duration/2)

func on_item_list_on_item_add_slideshow(item: Item, value: bool) -> void:
	if value and !items.has(item):
		items.append(item)
		toggle_slideshow_btn_disabled.emit(false)
	elif !value:
		items.erase(item)
		if items.size() == 0:
			toggle_slideshow_btn_disabled.emit(true)
	
func update_settings(setup: Setup, tab_index : int):
	duration = setup.tabs[tab_index].duration
	fade_duration = setup.tabs[tab_index].fade_duration
	ease_type = setup.tabs[tab_index].ease_type
	transition_type = setup.tabs[tab_index].trans_type
