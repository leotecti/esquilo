extends RefCounted
const VILLAGE = preload("res://assets/narrative/opening_village.png")
const OWL_TRAPPED = preload("res://assets/narrative/opening_owl_trapped.png")
const OWL_RESCUED = preload("res://assets/narrative/opening_owl_rescued.png")

static func steps() -> Array:
	return [
		{"type":"scene","title":"O vilarejo na floresta","background":VILLAGE,"actor_position":Vector2(0.14,0.67)},
		{"type":"dialogue","speaker":"Narrador","text":"O inverno estava chegando. Todos guardavam comida para os dias frios."},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Ainda cabem muitas nozes no meu depósito! Vou buscar mais."},
		{"type":"animation","actor":"tico","animation":"run_and_jump","duration":1.65,"from":Vector2(0.14,0.67),"to":Vector2(0.58,0.62),"arc":72.0,"pose":"run"},
		{"type":"dialogue","speaker":"Narrador","text":"Tico correu, saltou e procurou por toda parte. Mas quase não encontrou comida."},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Estranho... até meu depósito está quase vazio. Vou procurar mais longe!"},
		{"type":"transition","duration":0.6,"color":"fff0c9"},
		{"type":"scene","title":"Além das trilhas conhecidas","background":OWL_TRAPPED,"actor_position":Vector2(0.17,0.67)},
		{"type":"dialogue","speaker":"Narrador","text":"As marcas levaram Tico a uma parte desconhecida da floresta."},
		{"type":"dialogue","speaker":"Coruja","text":"Olá, pequeno explorador! Estes galhos caíram bem na hora errada."},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Não se preocupe. Eu vou ajudar!"},
		{"type":"animation","actor":"tico","animation":"rescue_owl","duration":1.45,"from":Vector2(0.17,0.67),"to":Vector2(0.47,0.64),"arc":26.0,"pose":"run"},
		{"type":"transition","duration":0.45,"color":"fff0c9"},
		{"type":"scene","title":"Uma nova amiga","background":OWL_RESCUED,"actor_position":Vector2(0.34,0.67)},
		{"type":"event","id":"owl_rescued"},
		{"type":"dialogue","speaker":"Coruja","text":"Obrigada, Tico! Vi comida sendo levada pela trilha. Siga as nozes e observe as penas."},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":"Então não foi só comigo. Vou descobrir o que aconteceu e ajudar o vilarejo!"},
		{"type":"event","id":"first_clue_received"},
		{"type":"transition","duration":0.7,"color":"fff4d7"},
		{"type":"scene","title":"Tico e a Floresta das Nozes","background":VILLAGE,"actor_position":Vector2(0.50,0.66)},
		{"type":"dialogue","speaker":"Uma aventura entre amigos","text":"A jornada começa agora."}
	]
