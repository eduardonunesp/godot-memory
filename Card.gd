extends Area2D
class_name Card

signal face_changed(card_state)

onready var label = $Label
onready var number = $Number
onready var face_up = $FaceUp
onready var face_down = $FaceDown

enum CardState {
	FACE_UP,
	FACE_DOWN,
	FOUND,
}

export (CardState) var state = CardState.FACE_DOWN

var card_number = 0

func _ready():
	_face_down()


func should_mark_found():
	print("Card %s found" % card_number)
	state = CardState.FOUND


func should_mark_face_down():
	print("Card %s is face down" % card_number)
	state = CardState.FACE_DOWN
	_face_down()


func _face_down():
	face_up.visible = false
	number.visible = false
	label.text = "FACE DOWN"
	number.text = str(card_number)


func _face_up():
	face_up.visible = true
	number.visible = true
	label.text = "FACE UP"
	number.text = str(card_number)


func _on_card_clicked(_viewport: Node, event: InputEvent, _shape_idx: int):
	if Globals.state != Globals.GameStates.SELECTING_CARDS:
		return

	if (event is InputEventMouseButton && event.pressed):
		if state == CardState.FACE_DOWN:
			state = CardState.FACE_UP
			emit_signal("face_changed", state)
			Globals.selected_cards.push_back(self)
			print("Selected card %s" % self.card_number)


func _on_Card_face_changed(card_state) -> void:
	match card_state:
		CardState.FACE_UP:
			_face_up()
		CardState.FACE_DOWN:
			_face_down()
