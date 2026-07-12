extends Window
class_name ImageWindow

@export var texture : TextureRect

func build_services():
	pass

func bind_services(main : Main):
	main.toggle_hide_image.connect(toggle_visibility)

func set_texture(image : Image):
	var img_text := ImageTexture.create_from_image(image)
	texture.texture = img_text

func toggle_visibility():
	visible = !visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		toggle_visibility()
