extends Node

enum ACTORS_POS {LEFT, RIGHT, TOP, BOTTOM}

## TESTE de DESIGN : Mapa de bonus baseado na posição
var map = [[1.9,1.6, 1.3], [1.6, 1.3, 1], [1.3, 1, 0.7]]

func calulcate_bonus_position(_actor_A:String, _actor_B:String) -> float:	
	var _local_A :int = _corrige_values(_actor_A, false)
	var _local_B :int = _corrige_values(_actor_B, true)
	
	var _value = map[_local_A][_local_B]
	return _value

func _corrige_values(_actor_local, _inverse:bool) -> int:
	if _actor_local == "LEFT":
		return 0 if _inverse else 2
	elif _actor_local == "TOP" or _actor_local == "BOTTOM":
		return 1
	else:
		return 2 if _inverse else 0
