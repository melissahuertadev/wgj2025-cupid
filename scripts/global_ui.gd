extends CanvasLayer

@onready var control_container: HBoxContainer = $MarginContainer/Control

var UIButtonScene := preload("res://scenes/ui/GlobalUIButtonBase.tscn")

var music_volume := 1.0
var sfx_volume := 1.0

func _ready():
	add_to_group("ui_layer") # permite acceder desde otras escenas
	build_controls()
	
	get_tree().connect("scene_changed", Callable(self, "_on_scene_changed"))
	
func build_controls():
	# Lista de los elementos a agregar
	var items_data = [
		{ "name": "QuitButton",  "icon": "res://assets/ui/globals/logout.svg", "callback": func(): _on_quit_button_pressed(), "side": "left" },
		{ "type": "spacer" }, # separador flexible
		{ "name": "HeartButton", "icon": "res://assets/ui/globals/heart.svg", "callback": func(): _on_heart_button_pressed(), "side": "right" },
		{ "type": "gap", "width": 12 }, # espacio fijo
		{ "name": "SettingsButton", "icon": "res://assets/ui/globals/settings.svg", "callback": func(): _on_settings_button_pressed(), "side": "right" },
		# { "type": "gap", "width": 12 }, # espacio fijo
		#{ "name": "SoundButton", "icon": "res://assets/ui/globals/sound.svg", "callback": func(): _on_sound_button_pressed(), "side": "right" }
	]
	
	for item in items_data:
		if item.has("type"):
			match item.type:
				"spacer":
					add_spacer()
				"gap":
					add_gap(item.width)
		else:
			var btn = add_button(item.name, item.icon, item.callback)
			if item.name == "HeartButton":
				btn.visible = false
			#add_button(item.name, item.icon, item.callback)

func add_spacer():
	# Espaciador
	var spacer = Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND
	spacer.size_flags_vertical = Control.SIZE_FILL
	control_container.add_child(spacer)
	
func add_gap(width: int):
	# Margen entre heart y sound
	var gap = Control.new()
	gap.custom_minimum_size = Vector2(width, 0)
	control_container.add_child(gap)
	
func add_button(button_name: String, icon_path: String, callback: Callable) -> TextureButton:
	var btn = create_button(button_name, icon_path, callback)
	control_container.add_child(btn)
	#print("%s was added to scene" % button_name)
	return btn

func create_button(button_name: String, icon_path: String, callback: Callable) -> TextureButton:
	var btn: TextureButton = UIButtonScene.instantiate()
	btn.name = button_name
	btn.texture_normal = load(icon_path) # SVG o textura
	btn.ignore_texture_size = true  # Permite escalar manualmente
	btn.custom_minimum_size = Vector2(42, 42)
	btn.pressed.connect(callback)
	return btn
	
func show_heart_button():
	var heart = control_container.get_node_or_null("HeartButton")
	if heart:
		heart.visible = true

func _on_heart_button_pressed() -> void:
	var credits_modal_instance = preload("res://scenes/modals/CreditsModal.tscn").instantiate()
	add_child(credits_modal_instance)
	credits_modal_instance.popup_centered()
	
func _on_settings_button_pressed() ->  void:
	var popup = preload("res://scenes/ui/GlobalPopup.tscn").instantiate()
	add_child(popup)
	
	popup.open_modal("res://scenes/modals/SettingsModal.tscn")

# Mostrar modal de opciones de sonido
func _on_sound_button_pressed() -> void:
	get_tree().paused = true
	print("TO DO sound was pressed")
	#$ModalMusica.show()

func _on_quit_button_pressed() -> void:
	if OS.has_feature("web"):
		GlobalManager.reset_player_data()
		
		# El juego sigue corriendo
		get_tree().paused = false
		queue_free()
		
		# Carga pantalla inicial
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	else:	
		get_tree().quit()

func _on_scene_changed(scene):
	var current_scene = scene.name
	var heart = control_container.get_node_or_null("HeartButton")

	if heart:
		if current_scene == "MainMenu":
			heart.visible = false
		else:
			heart.visible = true
