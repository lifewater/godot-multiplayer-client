extends Node2D

const packets := preload("res://addons/protobuf/packets.gd")
@onready var Chatbox = get_node("CanvasLayer/Chatbox")



var myID = 0
func _ready() -> void:
	get_node("CanvasLayer/Chatbox").connect("chat_submitted", Callable(self, "_on_chatbox_message"))
	WS.connected_to_server.connect(_on_ws_connected_to_server)
	WS.connection_closed.connect(_on_ws_connection_closed)
	WS.packet_received.connect(_on_ws_packet_received)
	
	Chatbox.broadcast_message("Connecting to server...")
	WS.connect_to_url("ws://127.0.0.1:8080/ws")

func _on_ws_connected_to_server() -> void:
	Chatbox.broadcast_message("You've successfully connected to the server.")


func _on_ws_connection_closed() -> void:
	print("Connection closed")
	
func _on_ws_packet_received(packet: packets.Packet) -> void:
	print("Received packet from the server: %s" % packet)

	var sender_id := packet.get_sender_id()
	var myID = sender_id
	if packet.has_id():
		_handle_id_msg(sender_id, packet.get_id())
	elif packet.has_chat():
		_handle_chat_msg(sender_id, packet.get_chat())

func _handle_id_msg(sender_id: int, id_msg: packets.IdMessage) -> void:
	var client_id := id_msg.get_id()
	Chatbox.broadcast_message("Recieved client ID: %d" % client_id)

func _handle_chat_msg(sender_id: int, chat_msg: packets.ChatMessage) -> void:
	Chatbox.broacast_message("Client %d" % sender_id, chat_msg.get_msg())

func _on_chatbox_message(text: String) -> void:
	print("hit")
	var packet := packets.Packet.new()
	var chat_msg := packet.new_chat()
	chat_msg.set_msg(text)
	
	var err := WS.send(packet)
	if err:
		Chatbox.broadcast("Error sending chat message")
	else:
		Chatbox.add_message(myID, text)
