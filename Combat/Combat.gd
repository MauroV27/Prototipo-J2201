extends Control
class_name CombatContoller

var turn_queue : Array = []
var active_actor : Dictionary
var actor_in_focus = null 

signal player_turn
signal enemy_exit_battle

"""CÓDIGO MUITO BAGUNÇADO, MAL FEITO E POUCO OTIMIZADO, mas funciona"""

#### Combat Setup -------------------------------

func _ready() -> void:
	$ColorRect.visible = true
	$AnimationPlayer.play("StartCombat")
	
	$EnemyActors.load_actors_data()
	$PlayerActors.load_actors_data()

func _wait_to_inicialize() -> void:
	initialize()

func initialize() -> void:
	for actor in $PlayerActors.get_controller_data():
		if actor.data != null:
			var actor_data = {"actor": actor.data, "local": actor.local, "controller": "Player", "pos": actor.pos}
			turn_queue.append(actor_data)
	
	for actor in $EnemyActors.get_controller_data():
		if actor.data != null:
			var actor_data = {"actor": actor.data, "local": actor.local, "controller": "Enemy", "pos": actor.pos}
			turn_queue.append(actor_data)
		else:
			emit_signal("enemy_exit_battle", actor.local, false)
	
	sort_turn_order(0)

# Class to reorder actors based in dexterity values
class SorterActorByDexterity:
	static func sort_ascending(a, b):
		if a.actor.dexterity > b.actor.dexterity:
			return true
		return false

func sort_turn_order(_last_index:int) -> void:
	turn_queue.sort_custom(SorterActorByDexterity, "sort_ascending")
	active_actor = turn_queue[_last_index]
	
	if active_actor.controller == "Player":
		actor_in_focus = $PlayerActors.focus_actor(active_actor.local)
		actor_in_focus.select_actor()
		
		## Rever a função e posição disso aqui
		for actor in turn_queue:
			if actor.controller == "Enemy":
				if $EnemyActors.focus_actor(actor.local).life <= 0:
					emit_signal("enemy_exit_battle", actor.local, false)
		
		if actor_in_focus.life > 0:
			emit_signal("player_turn", active_actor.actor)
		else:
			next_turn()
	else:
		play_AI()

func next_turn() -> void:
	actor_in_focus.deselect_actor()
	
	var _index = turn_queue.find(active_actor) + 1
	if _index <= 0 or _index >= len(turn_queue):
		_index = 0
	sort_turn_order(_index)

#### AI Systems ---------------------------------

func play_AI() -> void:	
	actor_in_focus = $EnemyActors.focus_actor(active_actor.local)
	actor_in_focus.select_actor()
	if actor_in_focus.in_battle == false:
		next_turn()
		return
	
	yield(get_tree().create_timer(1.0), "timeout")
	
	var _player_actors : Array = []
	
	for _actor in turn_queue:
		if _actor.controller == "Player":
			_player_actors.append(_actor)

	var _selected_actor = _player_actors[ randi() % len(_player_actors) ]
	# Animation : Enemy attack player
	var _player_actor = $PlayerActors.focus_actor(_selected_actor.local)
	anim_attack(actor_in_focus, _player_actor.get_global_rect().position)
	
	_player_actor.life -= attack_calculate(active_actor, _selected_actor)
	_player_actor.update_life_values()
	
	next_turn()

#### Player Contollers --------------------------

func _on_PlayerControl_attack_enemy(_enemy_pos:String, _bonus:float=1.0) -> void:
	var enemy_panel = $EnemyActors.focus_actor(_enemy_pos)
	
	# Animation : Player attack enemy
	anim_attack(actor_in_focus, enemy_panel.get_global_rect().position)
	
	var _enemy_pos_in_queue : int = 0
	for _actor in turn_queue:
		if _actor.controller == "Enemy" and _actor.local == _enemy_pos:
			break
		_enemy_pos_in_queue += 1
	
	var _damage = attack_calculate(active_actor, turn_queue[_enemy_pos_in_queue])
	
	enemy_panel.life -= int(_damage * _bonus)
	enemy_panel.update_life_values()


func _on_PlayerControl_end_turn() -> void:
	if active_actor.controller == "Player":
		next_turn()

#### Attack controllers -------------------------

func attack_calculate(_attacker:Dictionary, _defenser:Dictionary) -> int:
	var _position_bonus : float = Global.calulcate_bonus_position(_attacker.local, _defenser.local)
	var _calculate : int = attack_damage_calculate(_attacker.actor, _defenser.actor, _position_bonus)
	
	return _calculate

func attack_damage_calculate(actor_attack: ActorBaseData, actor_deffen:ActorBaseData, _bonus:float)-> int:
	var _attack : float = (4*actor_attack.force) / (1 + (actor_deffen.defense))
	_attack = _attack * ( 1 + (actor_attack.dexterity - actor_deffen.dexterity)/5 ) * (0.5 + _bonus/2)
	return int(round(_attack))

func anim_attack(_current_actor, _enemy_pos:Vector2) -> void:
	var _sprite : Sprite = _current_actor.get_node("Sprite")
	var _sprite_pos : Vector2 = _sprite.position
	
	$Tween.interpolate_property(_sprite, "global_position",
		_sprite.global_position, _enemy_pos, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	_sprite.position = _sprite_pos
