extends Node

const SAVE_PATH = "res://settings.cfg"
var save_file = ConfigFile.new()
const SECRET = "hi"

onready var Bone = load("res://Bone/Bone.tscn")
onready var HUD = get_node_or_null("/root/Game/UI/HUD")
onready var Game = load("res://Game.tscn")
onready var Bones = get_node_or_null("/root/Game/Bones")

var save_data = {
	"general": {
		"score":0
		,"bones":[]
	}
}

func _ready():
	update_score(0)
	
	
func restart_level():
	HUD = get_node_or_null("/root/Game/UI/HUD")
	Bones = get_node_or_null("/root/Game/Bones")
	
	for c in Bones.get_children():
		c.queue_free()
	for c in save_data["general"]["bones"]:
		var bone = Bone.instance()
		bone.position = str2var(c)
		Bones.add_child(bone)
	update_score(0)
	get_tree().paused = false

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit()

func update_score(s):
	save_data["general"]["score"] += s
	HUD.find_node("Score").text = "Score: " + str(save_data["general"]["score"])
	
func save_game():
	save_data["general"]["bones"] = []					# creating a list of all the coins and mines that appear in the scene
	for c in Bones.get_children():
		save_data["general"]["bones"].append(var2str(c.position))	# get a json representation of each of the coins

	var save_game = File.new()						# create a new file object
	save_game.open_encrypted_with_pass(SAVE_PATH, File.WRITE, SECRET)	# prep it for writing to, make sure the contents are encrypted
	save_game.store_string(to_json(save_data))				# convert the data to a json representation and write it to the file
	save_game.close()							# close the file so other processes can read from or write to it
						# write the data to the config file

	
func load_game():
	var save_game = File.new()						# Create a new file object
	if not save_game.file_exists(SAVE_PATH):				# If it doesn't exist, skip the rest of the function
		return
	save_game.open_encrypted_with_pass(SAVE_PATH, File.READ, SECRET)	# The file should be encrypted
	var contents = save_game.get_as_text()					# Get the contents of the file
	var result_json = JSON.parse(contents)					# And parse the JSON
	if result_json.error == OK:						# Check to make sure the JSON got successfully parsed
		save_data = result_json.result				# If so, load the data from the file into the save_data lists
	else:
		print("Error: ", result_json.error)
	save_game.close()							# Close the file so other processes can read from or write to it
	
	var _scene = get_tree().change_scene_to(Game)				# Load the scene
	call_deferred("restart_level")						# When it's done being loaded, call the restart_level method
