extends Window
class_name ImageWindow

@export var texture : TextureRect

func build_services():
	pass

func bind_services(main : Main, input_controller : InputController):
	main.toggle_hide_image.connect(toggle_visibility)
	input_controller.on_hide_button_pressed.connect(toggle_visibility)

func set_texture(image : Image):
	var img_text := ImageTexture.create_from_image(image)
	texture.texture = img_text

func toggle_visibility():
	visible = !visible
