extends RefCounted
const FOREST = preload("res://assets/slice/forest.png")

static func first_meeting() -> Array:
	return [
		{"type":"scene","title":"Um pedido de ajuda","background":FOREST,"actor_position":Vector2(0.25,0.67),"companion_position":Vector2(0.73,0.67),"companion_pose":11},
		{"type":"camera","focus":Vector2(0.70,0.49),"zoom":1.08,"duration":0.75},
		{"type":"dialogue","speaker":"Pipo","portrait":"pipo","text":"Ei! Eu sou Pipo. Fiquei preso nestes cipós enquanto procurava comida para minha família."},
		{"type":"camera","focus":Vector2(0.28,0.52),"zoom":1.09,"duration":0.7},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Eu também estou procurando comida para o vilarejo. Não se preocupe, Pipo: vou tirar você daí!"},
		{"type":"dialogue","speaker":"Pipo","portrait":"pipo","text":"O bloco rachado sustenta os cipós. Acerte-o por baixo com um salto!"},
		{"type":"event","id":"pipo_first_meeting"}
	]

static func joins_team() -> Array:
	return [
		{"type":"scene","title":"A força da amizade","background":FOREST,"actor_position":Vector2(0.29,0.67),"companion_position":Vector2(0.69,0.67),"companion_pose":9},
		{"type":"dialogue","speaker":"Pipo","portrait":"pipo","text":"Conseguiu! Obrigado, Tico. A comida sumiu perto da minha casa também, e eu não sabia a quem pedir ajuda."},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Valda me contou que muitos animais estão passando pelo mesmo problema. Estou seguindo as trilhas para ajudar o bosque."},
		{"type":"dialogue","speaker":"Pipo","portrait":"pipo","text":"Então vamos juntos! Sou forte e consigo mover pedras pesadas que bloqueiam o caminho."},
		{"type":"animation","actor":"pipo","animation":"push_rock","duration":1.1,"from":Vector2(0.69,0.67),"to":Vector2(0.55,0.67),"arc":0.0,"pose":"push"},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"E eu consigo saltar mais alto e passar por lugares estreitos. Um pode abrir o caminho para o outro!"},
		{"type":"animation","actor":"tico","animation":"high_jump","duration":1.2,"from":Vector2(0.29,0.67),"to":Vector2(0.46,0.57),"arc":78.0,"pose":"jump"},
		{"type":"actors","tico_position":Vector2(0.38,0.67),"tico_pose":"gesture","pipo_position":Vector2(0.62,0.67),"pipo_pose":9},
		{"type":"dialogue","speaker":"Pipo","portrait":"pipo","text":"Combinado! Troque de personagem quando o caminho pedir força ou agilidade."},
		{"type":"event","id":"pipo_joins_team"}
	]
