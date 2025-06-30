extends Control

signal chat_submitted(text)

@onready var chatLog = get_node("PanelContainer/VBoxContainer/ScrollContainer/RichTextLabel")
@onready var inputLabel = get_node("PanelContainer/VBoxContainer/HBoxContainer/Label")
@onready var inputEdit = get_node("PanelContainer/VBoxContainer/HBoxContainer/LineEdit")

var user_name = "LifeWater"

func _ready():
	inputLabel.text = "[" + user_name + "]:"
#	inputEdit.connect("text_submitted", handle_input)
	inputEdit.keep_editing_on_text_submit = true


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ENTER:
			inputEdit.grab_focus()
		if event.pressed and event.keycode == KEY_ESCAPE:
			inputEdit.release_focus()

func add_message (username, text):
	chatLog.append_text("\n["+ username + "]: " + text)
	
func broadcast_message (text):
	print ("someones trying to broadcast")
	chatLog.append_text("\n" + text)

func _on_line_edit_text_submitted(text: String) -> void:
	emit_signal("chat_submitted", text)
	


#func handle_input(incoming_text):
#	if incoming_text != '':
#		add_message(user_name, incoming_text)
#		inputEdit.text = ""
