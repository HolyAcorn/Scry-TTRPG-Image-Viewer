class_name JsonConverter
extends Node

static func setup_to_json(setup : Setup) -> String:
	var json : String = "{\n\t"
	json += "\"current_tab\": " + str(setup.current_tab) + ",\n\t"
	json += "\"current_item_index\": " + str(setup.current_item_index) + ",\n\t"
	json += "\"tabs\": [\n\t\t"
	for i in range(setup.tabs.size()):
		var tab := setup.tabs[i]
		json += "{\n\t\t\t"
		json += "\"index\": " + str(tab.index) + ",\n\t\t\t"
		json += "\"title\": \"" + str(tab.title) + "\",\n\t\t\t"
		json += "\"ease_type\": " + str(tab.ease_type) + ",\n\t\t\t"
		json += "\"trans_type\": " + str(tab.trans_type) + ",\n\t\t\t"
		json += "\"duration\": " + str(tab.duration) + ",\n\t\t\t"
		json += "\"fade_duration\": " + str(tab.fade_duration) + ",\n\t\t\t"
		json += "\"image_paths\": ["
		for y in range(tab.image_paths.size()):
			var path = tab.image_paths[y]
			json += "\n\t\t\t\t{"
			json += "\n\t\t\t\t\t \"path\": \"" + path.path + "\","
			json += "\n\t\t\t\t\t\t \"is_slideshow\": " + str(path.is_slideshow)
			json += "\n\t\t\t\t}"
			if y < tab.image_paths.size()-1:
				json += ","
		json += "\n\t\t\t]"
		json += "\n\t\t}"
		if i < setup.tabs.size()-1:
			json += ","
	json += "\n\t]\n}"
	return json


static func json_to_setup(json : Dictionary) -> Setup:
	var setup : Setup = Setup.new()
	
	setup.current_item_index = json["current_item_index"]
	setup.current_tab = json["current_tab"]
	for json_tab in json["tabs"]:
		var tab : Setup.TabResource = Setup.TabResource.new()
		tab.index = json_tab["index"]
		tab.title = json_tab["title"]
		tab.ease_type = json_tab["ease_type"]
		tab.trans_type = json_tab["trans_type"]
		tab.duration = json_tab["duration"]
		tab.fade_duration = json_tab["fade_duration"]
		for image_path in json_tab["image_paths"]:
			var image_item := Setup.ImageItem.new()
			image_item.path = image_path["path"]
			image_item.is_slideshow = image_path["is_slideshow"]
			tab.image_paths.append(image_item)
		setup.tabs.append(tab)
	
	return setup
