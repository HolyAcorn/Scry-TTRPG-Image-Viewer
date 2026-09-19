class_name SignalHelper

static func disconnect_all(connections : Array):
	print("before removing:")
	for c in connections.size():
		print(str(c) + ": " + connections[c]["callable"].get_object().tab_name)
	for i in range(connections.size()-1, -1, -1):
		connections[i]["signal"].disconnect(connections[i]["callable"])
	print("after removing:")
	for c in connections.size():
		print(str(c) + ": " + connections[c]["callable"].get_object().tab_name)
