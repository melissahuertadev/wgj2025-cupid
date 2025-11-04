# GlobalPopup.gd
extends PopupPanel

@onready var content_container: VBoxContainer = $ColorRect/VBoxContainer/ContentContainer
@onready var close_button: TextureButton = $ColorRect/VBoxContainer/CloseTextureButton

func _ready() -> void:
	close_button.pressed.connect(_on_close_pressed)
	
func _on_close_pressed():
	hide()
	queue_free()
	
# Cargar un modal dentro del contenedor
func open_modal(scene_path: String):
	for child in content_container.get_children():
		child.queue_free()
	
	var modal_instance = load(scene_path).instantiate()
	content_container.add_child(modal_instance)
	
	popup_centered()
