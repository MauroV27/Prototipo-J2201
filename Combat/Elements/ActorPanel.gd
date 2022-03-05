extends Control
class_name ActorPanel

""" Responsavel por apresentar na tela o ator e 
	suas informações de vida """

onready var LifeBar : ProgressBar = $ProgressBar

#var actor_data : Resource

var max_life : int 
var life : int 
var in_battle : bool = true
 
func load_actor_data(_actor_data:Resource) -> void:
	if _actor_data != null:
		max_life = _actor_data.max_life
		life = max_life
		var _text = str(_actor_data.name) + " Lv. " + str(_actor_data.level)
		$NameLevel.text = _text
		$Sprite.texture = _actor_data.sprite
		
		deselect_actor()
		update_life_values()
	else:
		visible = false

func update_life_values() -> void:
	if life <= 0:
		in_battle = false
		life = 0
		$Sprite.modulate = Color(0,0,0)
	
	LifeBar.max_value = max_life
	LifeBar.value = life
	LifeBar.get_node("LabelValue").text = str(life) + "/" + str(max_life)

func select_actor() -> void:
	if in_battle:
		$Sprite.modulate = Color("ffffff")

func deselect_actor() -> void:
	if in_battle:
		$Sprite.modulate = Color("bbbbbb")

