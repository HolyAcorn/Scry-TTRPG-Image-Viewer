class_name Setup
extends Resource

class TabResource:
	var index : int
	var title : String
	var image_paths : Array[String]
	var ease_type : Tween.EaseType
	var trans_type : Tween.TransitionType
	var fade_duration : float
	var duration : float

var tabs : Array[TabResource]
var current_tab : int
var current_item_index : int

func save_setup(new_tabs : Array[Tab], new_ease_type : Tween.EaseType, new_trans_type : Tween.TransitionType, new_duration : float, new_fade_duration :float, new_current_tab : int, new_current_item_index : int) -> Setup:
	for i in range(new_tabs.size()):
		var tab : Tab = new_tabs[i]
		var tab_resource := TabResource.new()
		tab_resource.index = i
		tab_resource.title = tab.name
		tab_resource.image_paths = tab.images
		tab_resource.ease_type = new_ease_type
		tab_resource.trans_type = new_trans_type
		tab_resource.duration = new_duration
		tab_resource.fade_duration = new_fade_duration
	current_tab = new_current_tab
	current_item_index = new_current_item_index
	return self

func new_default_setup(new_ease_type : Tween.EaseType, new_trans_type : Tween.TransitionType, new_duration : float, new_fade_duration :float) -> Setup:
	var tab_resource := TabResource.new()
	tab_resource.index = 0
	tab_resource.title = "Tab 1"
	tab_resource.ease_type = new_ease_type
	tab_resource.trans_type = new_trans_type
	tab_resource.duration = new_duration
	tab_resource.fade_duration = new_fade_duration
	current_tab = 0
	current_item_index = 0
	tabs.append(tab_resource)
	return self
