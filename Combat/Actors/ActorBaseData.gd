extends Resource
class_name ActorBaseData

export var name : String = "None"
export var level : int = 1
export var max_life : int = 10
export var life : int = 10
export var energy : int = 5
export var force :  int = 3
export var inteligence : int = 3
export var defense : int = 2
export var resistence : int = 2
export var dexterity : int = 4
export var luck : int = 3
export(Array, Resource) var base_attack = [
	preload("res://Combat/Skills/BaseAttack_LEFT.tres"),
	preload("res://Combat/Skills/BaseAttack_RIGHT.tres"),
	preload("res://Combat/Skills/BaseAttack_TOP.tres"),
	preload("res://Combat/Skills/BaseAttack_BOTTOM.tres")
	]
export var sprite : Texture = null

export(Array, Resource) var skills = []

func set_life(_value:int) -> void:
	life = _value
