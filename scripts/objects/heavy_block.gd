extends StaticBody2D
signal broken(block: Node2D)
var destroyed: bool = false

func receive_charge(character: Node2D) -> bool:
	if destroyed or not character.is_in_group("pipo") or character.ability != "charge":
		return false
	destroyed = true
	hide()
	$Collision.set_deferred("disabled",true)
	broken.emit(self)
	return true

func _draw() -> void:
	draw_rect(Rect2(-45,-140,90,140),Color("687b6d"))
	draw_rect(Rect2(-45,-140,90,140),Color("3d5746"),4)
	for y in [-110,-70,-30]:
		draw_line(Vector2(-42,y),Vector2(42,y),Color("aec1a1"),3)
	draw_colored_polygon(PackedVector2Array([Vector2(-18,-92),Vector2(20,-70),Vector2(-18,-48)]),Color("e5ce82"))

func reset_puzzle() -> void:
	destroyed = false
	show()
	$Collision.set_deferred("disabled",false)
