extends Area2D
class_name Card

onready var label = get_node("Label")
onready var number = get_node("Number")
onready var face_up = get_node("FaceUp")
onready var face_down = get_node("FaceDown")

enum CardState {
	FACE_UP,
	FACE_DOWN
}

export (CardState) var state = CardState.FACE_DOWN

var card_number = 0

func _process(delta: float):
	match state:
		CardState.FACE_DOWN:
			_on_face_down()
		CardState.FACE_UP:
			_on_face_up()

	number.text = str(card_number)

func _on_face_down():
	face_up.visible = false
	number.visible = false
	label.text = "FACE DOWN"

func _on_face_up():
	face_up.visible = true
	number.visible = true
	label.text = "FACE UP"

func _on_card_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton && event.pressed):
		if state == CardState.FACE_DOWN:
			state = CardState.FACE_UP
		else:
			state = CardState.FACE_DOWN
