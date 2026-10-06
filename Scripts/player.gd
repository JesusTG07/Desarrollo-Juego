extends CharacterBody2D

const SPEED = 250
const RUN_SPEED = 325
const JUMP_VELOCITY = -400

const DASH_SPEED = 700
const DASH_TIME = 0.50

@onready var anim = $Sprite2D

var is_attacking = false
var is_crouching = false
var is_dashing = false
var is_damaged = false
var is_dead = false

var dash_timer = 0.50
var dash_direction = 1


func _physics_process(delta: float) -> void:

	# =========================
	# MUERTO
	# =========================
	if is_dead:
		velocity.x = 0
		move_and_slide()
		return


	# =========================
	# GRAVEDAD
	# =========================
	if not is_on_floor():
		velocity += get_gravity() * delta


	# =========================
	# ATTACK
	# =========================
	if Input.is_action_just_pressed("attack") \
	and not is_attacking \
	and not is_dashing \
	and not is_damaged \
	and not is_crouching:

		attack()


	# =========================
	# CROUCH
	# =========================
	if Input.is_action_pressed("crouch") \
	and is_on_floor() \
	and not is_attacking \
	and not is_dashing \
	and not is_damaged:

		is_crouching = true

	else:
		is_crouching = false


	# =========================
	# DASH
	# =========================
	if Input.is_action_just_pressed("dash") \
	and not is_dashing \
	and not is_attacking \
	and not is_damaged \
	and not is_crouching:

		is_dashing = true
		dash_timer = DASH_TIME

		if anim.flip_h:
			dash_direction = -1
		else:
			dash_direction = 1

		anim.play("Dash")


	if is_dashing:

		velocity.x = dash_direction * DASH_SPEED

		dash_timer -= delta

		if dash_timer <= 0:
			is_dashing = false

		move_and_slide()
		return


	# =========================
	# DAMAGE
	# =========================
	if is_damaged:
		velocity.x = 0
		move_and_slide()
		return


	# =========================
	# SALTO CON W
	# =========================
	if Input.is_action_just_pressed("jump") \
	and is_on_floor() \
	and not is_crouching:

		velocity.y = JUMP_VELOCITY


	# =========================
	# DIRECCIÓN A / D
	# =========================
	var direction := Input.get_axis("move_left", "move_right")


	# =========================
	# MOVIMIENTO
	# =========================
	if is_crouching:

		velocity.x = move_toward(
			velocity.x,
			0,
			SPEED
		)

	elif direction:

		var current_speed = SPEED

		if Input.is_action_pressed("run"):
			current_speed = RUN_SPEED

		velocity.x = direction * current_speed

		anim.flip_h = direction < 0

	else:

		velocity.x = move_toward(
			velocity.x,
			0,
			SPEED
		)


	move_and_slide()


	# =========================
	# ANIMACIONES
	# =========================

	# Mientras ataca puede moverse,
	# pero no se corta la animación Attack.
	if is_attacking:
		return


	# =========================
	# CROUCH
	# =========================
	if is_crouching:

		if anim.animation != "Crouch":
			anim.play("Crouch")

		elif anim.frame >= 3:
			anim.frame = 3
			anim.pause()

		return


	# =========================
	# JUMP
	# =========================
	if not is_on_floor() and velocity.y < 0:

		anim.play("Jump")


	# =========================
	# RUN
	# =========================
	elif direction != 0 and Input.is_action_pressed("run"):

		anim.play("Run")


	# =========================
	# WALK
	# =========================
	elif direction != 0:

		anim.play("Walk")


	# =========================
	# IDLE
	# =========================
	else:

		anim.play("Idle")



# ==================================================
# ATTACK
# ==================================================

func attack():

	if is_attacking:
		return

	is_attacking = true

	anim.play("Attack")

	await anim.animation_finished

	is_attacking = false



# ==================================================
# DAMAGE
# ==================================================

func damage():

	if is_dead or is_damaged:
		return

	is_damaged = true

	is_attacking = false
	is_dashing = false
	is_crouching = false

	velocity.x = 0

	anim.play("Damage")

	await anim.animation_finished

	is_damaged = false



# ==================================================
# DIE
# ==================================================

func die():

	if is_dead:
		return

	is_dead = true

	is_attacking = false
	is_dashing = false
	is_damaged = false
	is_crouching = false

	velocity.x = 0

	anim.play("Die")
