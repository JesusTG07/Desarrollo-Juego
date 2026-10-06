extends Area2D

const ESCENA_INTERIOR: PackedScene = preload("res://Ecenas/caseta_interior.tscn")
@onready var boton: Button = $BotonEntrar

func _ready() -> void:
	boton.hide()
	body_entered.connect(al_entrar)
	body_exited.connect(al_salir)
	boton.pressed.connect(entrar_caseta)

func al_entrar(body: Node2D) -> void:
	if body.name == "Player":
		boton.show()

func al_salir(body: Node2D) -> void:
	if body.name == "Player":
		boton.hide()

func entrar_caseta() -> void:
	get_tree().change_scene_to_packed(ESCENA_INTERIOR)
