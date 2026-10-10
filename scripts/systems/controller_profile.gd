extends Node

const PATH := "user://controller.cfg"
const SECTION := "gamepad"
const REMAPPABLE := [&"jump", &"action", &"switch_character", &"pause"]
const DEFAULTS := {
	&"jump": 0,
	&"action": 2,
	&"switch_character": 3,
	&"pause": 6,
}

var bindings: Dictionary = DEFAULTS.duplicate()


func _ready() -> void:
	load_profile()
	apply_profile()


func load_profile() -> void:
	var config := ConfigFile.new()
	if config.load(PATH) != OK:
		bindings = DEFAULTS.duplicate()
		return
	for action in REMAPPABLE:
		var value: Variant = config.get_value(SECTION, String(action), DEFAULTS[action])
		bindings[action] = clampi(int(value), 0, 127)


func apply_profile() -> void:
	for action in REMAPPABLE:
		if not InputMap.has_action(action):
			continue
		for event in InputMap.action_get_events(action):
			if event is InputEventJoypadButton:
				InputMap.action_erase_event(action, event)
		var button := InputEventJoypadButton.new()
		button.device = -1
		button.button_index = int(bindings[action])
		InputMap.action_add_event(action, button)


func assign(action: StringName, button_index: int) -> void:
	if action not in REMAPPABLE:
		return
	var old_button := int(bindings[action])
	for other in REMAPPABLE:
		if other != action and int(bindings[other]) == button_index:
			bindings[other] = old_button
			break
	bindings[action] = button_index
	apply_profile()
	save_profile()


func restore_defaults() -> void:
	bindings = DEFAULTS.duplicate()
	apply_profile()
	save_profile()


func save_profile() -> void:
	var config := ConfigFile.new()
	for action in REMAPPABLE:
		config.set_value(SECTION, String(action), int(bindings[action]))
	config.save(PATH)


func button_name(index: int) -> String:
	var names := {
		0: "B · inferior", 1: "A · direito", 2: "Y · esquerdo", 3: "X · superior",
		4: "Select", 5: "Central", 6: "Start", 7: "L3", 8: "R3",
		9: "L", 10: "R", 11: "Direcional cima", 12: "Direcional baixo",
		13: "Direcional esquerdo", 14: "Direcional direito",
	}
	return names.get(index, "Botão %d" % index)
