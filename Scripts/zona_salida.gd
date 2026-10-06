extends Area2D

@onready var boton: Button = $BotonSalir

func _ready() -> void:
	boton.hide()
	body_entered.connect(al_entrar)
	body_exited.connect(al_salir)
	boton.pressed.connect(salir)

func al_entrar(body: Node2D) -> void:
	if body.name == "Player":
		boton.show()

func al_salir(body: Node2D) -> void:
	if body.name == "Player":
		boton.hide()

func salir() -> void:
	var resultado := get_tree().change_scene_to_file(
		"res://Ecenas/Mundo_1_Refugio_de_Ceniza.tscn"
	)
	if resultado != OK:
		push_error("Godot no pudo abrir la escena exterior.")
