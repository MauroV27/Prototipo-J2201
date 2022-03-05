extends Resource
class_name Skill

export var skill_name : String = ''
export var skill_description : String = ''
export var energy_cost : int = 4
export(Array, String, "LEFT", "RIGHT", "TOP", "BOTTOM") var targets = ["LEFT"]
export(Array, float) var skill_damage = [4.0]


