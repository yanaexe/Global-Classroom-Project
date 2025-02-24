extends Node

const SAVE_PATH = "user://savegame.json"

var save_data = {
	"player_position": [0.0, 0.0],  # Stored as an array to avoid JSON errors
	"game_progress": 0,
	"settings": {
		"volume": 1.0,
		"difficulty": "normal"
	}
}

# Save data to a file
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(save_data, "\t")  # Pretty formatting
		file.store_string(json_string)
		file.close()
		print("✅ Game saved successfully! Data:", save_data)
	else:
		print("❌ Error: Could not open save file for writing.")

# Load data from a file
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("⚠ No save file found. Creating a new save file.")
		save_game()  # Create a new save file with default values
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var parse_result = json.parse(json_string)

		if parse_result == OK:
			var loaded_data = json.get_data()

			# Ensure data integrity
			if "player_position" in loaded_data and loaded_data["player_position"] is Array:
				save_data["player_position"] = [loaded_data["player_position"][0], loaded_data["player_position"][1]]
			if "game_progress" in loaded_data:
				save_data["game_progress"] = loaded_data["game_progress"]
			if "settings" in loaded_data:
				save_data["settings"] = loaded_data["settings"]

			print("✅ Game loaded successfully! Data:", save_data)
		else:
			print("❌ Failed to parse save file. Using default values.")

# Update player position before saving
func update_player_position(pos: Vector2):
	save_data["player_position"] = [pos.x, pos.y]  # Convert Vector2 to an array
