extends Area2D
class_name Card

onready var face_up = get_node("FaceUp")
onready var face_down = get_node("FaceDown")

enum CardState {
	FACE_UP,
	FACE_DOWN
}

export (CardState) var state = CardState.FACE_DOWN

func _process(delta: float):
	match state:
		CardState.FACE_DOWN:
			face_up.visible = false
		CardState.FACE_UP:
			face_up.visible = true

func _on_card_clicked(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton && event.pressed):
		if state == CardState.FACE_DOWN:
			state = CardState.FACE_UP
		else:
			state = CardState.FACE_DOWN
