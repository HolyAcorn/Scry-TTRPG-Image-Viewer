extends Window
class_name ImageWindow

@export var texture : TextureRect
@export var video : VideoStreamPlayer

func build_services():
	pass

func bind_services(main : Main):
	main.toggle_hide_image.connect(toggle_visibility)

func set_texture(image : Image):
	var img_text := ImageTexture.create_from_image(image)
	texture.texture = img_text
	video.stop()
	video.visible = false
	texture.visible = true
	
func set_video(video_stream : VideoStream):
	video.stream = video_stream
	video.play()
	video.visible = true
	texture.visible = false

func toggle_visibility():
	visible = !visible

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		toggle_visibility()
