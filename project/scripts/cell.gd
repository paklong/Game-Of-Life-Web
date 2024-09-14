extends Node2D
class_name Cell

@onready var color_rect: ColorRect = %ColorRect
@onready var ray_cast_2d: RayCast2D = %RayCast2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

var is_alive : bool = false 
var neighbour_count := 0

func _ready() -> void:
	#set_alive()
	pass
		
func check_neighbour():
	var _neighbour_count : int = 0
	var x_offset := color_rect.size.x * scale.x * 1.5 # 40 * 0.5 * 1.5 = 30
	var y_offset := color_rect.size.y * scale.y * 1.5
	var top := Vector2(0, -y_offset)
	var bottom := Vector2(0, y_offset)
	var left := Vector2(-x_offset, 0)
	var right := Vector2(x_offset, 0)
	var top_left : = Vector2(-x_offset, -y_offset)
	var top_right : = Vector2(x_offset, -y_offset)
	var bottom_left : = Vector2(-x_offset, y_offset)
	var bottom_right : = Vector2(x_offset, y_offset)
	var directions := [top,bottom,left,right,top_left,top_right,bottom_left,bottom_right]
	for direction in directions:
		ray_cast_2d.target_position = direction
		ray_cast_2d.force_raycast_update()
		if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider().get_parent().is_alive:
			_neighbour_count += 1
	return _neighbour_count

func step():
	neighbour_count = check_neighbour()
	if is_alive:
		if neighbour_count < 2:
			return dead()
		elif neighbour_count == 2 or neighbour_count == 3:
			return ''
		elif neighbour_count > 3:
			return dead()
	else:
		if neighbour_count == 3:
			return alive()
		

	
func dead():
	return 'set_dead'
	
func alive():
	return 'set_alive'
	
func set_dead():
	is_alive = false
	call_deferred('set_visible', false)
	
func set_alive():
	is_alive = true
	call_deferred('set_visible', true)
	
func _to_string() -> String:
	if is_alive:
		return '1'
	else:
		return '0'
