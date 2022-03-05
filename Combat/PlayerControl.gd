extends Control

var actor_damage : int
var possible_targets 
var energy : int 
var controller_actor : ActorBaseData

signal attack_enemy
signal end_turn

func _ready() -> void:
	for _skill_btn in $SkillsOptions.get_children():
		_skill_btn.visible = false

func _on_Combat_player_turn(actor:ActorBaseData) -> void:
	$AttackOptions.visible = false
	$SkillsOptions.visible = false
	controller_actor = actor
	energy = controller_actor.energy
	show_energy()

	for _attack in controller_actor.base_attack:
		for btn in $AttackOptions.get_children():
			if btn.target == _attack.targets[0]:
				btn.energy_price = _attack.energy_cost
				btn.show_energy_price()
				break
	
	if len(controller_actor.skills) == 0:
		for button in $SkillsOptions.get_children():
			button.visible = false
	else:
		for _index in len(controller_actor.skills):
			var _skill_button : Button = $SkillsOptions.get_children()[_index]
			_skill_button.visible = true
			_skill_button.energy_price = controller_actor.skills[_index].energy_cost
			_skill_button.hint_tooltip = controller_actor.skills[_index].skill_description
			_skill_button.show_energy_price()
		

func show_energy() -> void:
	$PlayerStatus/energy.text = "Energy: "+str(energy)

func _on_ButtonEndTurn_pressed() -> void:
	emit_signal("end_turn")

func _on_button_show_attack_pressed() -> void:
	$SkillsOptions.visible = false
	$AttackOptions.visible = !$AttackOptions.visible 

func _on_Button_attack_pressed(_target:String, _energy_price:int) -> void:
	if energy >= _energy_price:
		energy -= _energy_price
		emit_signal("attack_enemy", _target)
		show_energy()
		if energy == 0:
			_on_ButtonEndTurn_pressed()

func _on_Combat_enemy_exit_battle(_pos:String, _state:bool) -> void:
	match _pos:
		'LEFT':
			$AttackOptions/btn_left.visible = _state
		'RIGHT':
			$AttackOptions/btn_right.visible = _state
		'TOP':
			$AttackOptions/btn_top.visible = _state
		'BOTTOM':
			$AttackOptions/btn_bottom.visible = _state

func _on_ButtonUseSkill_pressed() -> void:
	$AttackOptions.visible = false
	$SkillsOptions.visible = !$SkillsOptions.visible

func _on_Button_useSkill_pressed(_target:String, _energy_price:int) -> void:
	if len(controller_actor.skills) > 0:
		# skills[0] pq só tem 1 por enquanto
		for _index in len(controller_actor.skills[0].targets):
			yield(get_tree().create_timer(1.0), "timeout")
			var _local = controller_actor.skills[0].targets[_index]
			var _skill_damage : float = controller_actor.skills[0].skill_damage[_index]
			emit_signal("attack_enemy", _local, _skill_damage)
		
		_on_ButtonEndTurn_pressed()
