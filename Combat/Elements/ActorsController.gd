extends Control

export(Resource) var actor_left
export(Resource) var actor_right
export(Resource) var actor_top
export(Resource) var actor_bottom

export var flip_sprite : bool = false

var controller_data : Array = [
	{"local": "LEFT", "data": null, "pos": Vector2.ZERO},
	{"local": "RIGHT", "data": null, "pos": Vector2.ZERO},
	{"local": "TOP", "data": null, "pos": Vector2.ZERO},
	{"local": "BOTTOM", "data": null, "pos": Vector2.ZERO},
]
var actor_focus : ActorPanel = null

func _ready() -> void:
	load_actors_data()

func load_actors_data() -> void:
	if flip_sprite:
		for actor in get_children():
			actor.get_node("Sprite").flip_h = true
	
	controller_data[0].data = actor_left
	controller_data[1].data = actor_right
	controller_data[2].data = actor_top
	controller_data[3].data = actor_bottom
	
	load_actor_data($ActorLeft, actor_left)
	load_actor_data($ActorRight, actor_right)
	load_actor_data($ActorTop, actor_top)
	load_actor_data($ActorBottom, actor_bottom)

func get_controller_data() -> Array:
	return controller_data

func load_actor_data(_actor:ActorPanel, _resouce:Resource) -> void:
	_actor.load_actor_data(_resouce)

func focus_actor(_pos:String) -> ActorPanel:
	var _actorPanel : ActorPanel = null
	
	match _pos:
		'LEFT':
			_actorPanel = $ActorLeft
		'RIGHT':
			_actorPanel = $ActorRight
		'TOP':
			_actorPanel = $ActorTop
		'BOTTOM':
			_actorPanel = $ActorBottom
	
	return _actorPanel

func get_resource(_pos:String) -> ActorBaseData:
	match _pos:
		'LEFT':
			return actor_left
		'RIGHT':
			return actor_right
		'TOP':
			return actor_top
		'BOTTOM':
			return actor_bottom
	
	return null
