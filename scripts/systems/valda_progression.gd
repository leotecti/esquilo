extends RefCounted
const VALDA = preload("res://assets/narrative/opening_owl_rescued.png")

static func event_id(stage: int) -> String:
	return "valda_after_%d" % stage

static func steps(stage: int) -> Array:
	var content: Dictionary = {
		3:{
			"title":"O caminho até o rio",
			"tico":"O Guardião está bem e a passagem foi aberta. Mas ainda não sabemos para onde levaram a comida.",
			"valda_1":"Vocês devolveram a paz ao bosque. As marcas seguem para o Rio das Pedras.",
			"valda_2":"A correnteza carrega sementes e pistas. Atravessem com cuidado e observem tudo o que estiver fora do lugar.",
			"tico_end":"Vamos seguir juntos. Encontraremos a próxima pista do outro lado do rio!"},
		7:{
			"title":"Pistas levadas pelo vento",
			"tico":"O rio voltou a correr em segurança. Encontramos penas apontando para as montanhas.",
			"valda_1":"Essas penas vieram das partes mais altas da floresta. O vento está espalhando os rastros.",
			"valda_2":"O Gavião da Montanha protege aquelas passagens. Descubram por que ele está tão agitado e encontrem um caminho até o alto.",
			"tico_end":"Seguiremos as penas. A montanha não vai nos fazer desistir!"},
		11:{
			"title":"A trilha até a vila",
			"tico":"O Gavião se acalmou. Ele viu carregamentos descendo na direção da Vila dos Castores.",
			"valda_1":"Então alguém está usando os caminhos do rio e da montanha para transportar a comida.",
			"valda_2":"Os castores conhecem cada canal e mecanismo da região. Ajudem a vila e descubram quem abriu essa rota.",
			"tico_end":"Vamos chegar à vila e ajudar quem estiver precisando de nós."},
		15:{
			"title":"O bosque volta a respirar",
			"tico":"A vila está segura e recuperamos os alimentos levados para a Grande Árvore.",
			"valda_1":"Vocês uniram animais de todas as regiões. O bosque atravessará o inverno graças à coragem dos dois.",
			"valda_2":"Ainda existem caminhos para compreender, mas agora a floresta sabe que pode contar com seus amigos.",
			"tico_end":"Enquanto alguém precisar de ajuda, nossa aventura continuará!"}
	}.get(stage,{})
	if content.is_empty(): return []
	return [
		{"type":"scene","title":content.title,"background":VALDA,"actor_position":Vector2(0.34,0.67)},
		{"type":"camera","focus":Vector2(0.34,0.58),"zoom":1.10,"duration":0.8},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":content.tico},
		{"type":"camera","focus":Vector2(0.68,0.38),"zoom":1.12,"duration":0.8},
		{"type":"dialogue","speaker":"Valda","text":content.valda_1},
		{"type":"dialogue","speaker":"Valda","text":content.valda_2},
		{"type":"camera","focus":Vector2(0.48,0.47),"zoom":1.04,"duration":0.8},
		{"type":"animation","actor":"tico","animation":"accept_guidance","duration":0.85,"from":Vector2(0.34,0.67),"to":Vector2(0.36,0.67),"arc":2.0,"pose":"gesture"},
		{"type":"dialogue","speaker":"Tico","portrait":"tico","text":content.tico_end},
		{"type":"transition","duration":0.6,"color":"fff4d7"}
	]
