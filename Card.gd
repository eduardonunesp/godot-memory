extends Area2D
class_name Card

onready var globals = get_node("/root/Globals")

onready var label = get_node("Label")
onready var number = get_node("Number")
onready var face_up = get_node("FaceUp")
onready var face_down = get_node("FaceDown")

enum CardState {
	FACE_UP,
	FACE_DOWN,
	FOUND,
}

export (CardState) var state = CardState.FACE_DOWN

var card_number = 0

func should_mark_found():
	state = CardState.FOUND

func should_mark_face_down():
	state = CardState.FACE_DOWN

func _process(_delta: float):
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

func _on_card_clicked(_viewport: Node, event: InputEvent, _shape_idx: int):
	if globals.state != globals.GameStates.SELECTING_CARDS:
		return

	if (event is InputEventMouseButton && event.pressed):
		if state == CardState.FACE_DOWN:
			state = CardState.FACE_UP
			globals.selected_cards.push_back(self)
			print(self.card_number)
