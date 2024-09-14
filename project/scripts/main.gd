extends Node2D
# TODO: Add stats: life time (longest life time), number of cell alive (highest cell alive)
# TODO: fortune telling web, name as input, hash to seed, life time is health, highest cell alive is money, area gain is wisdom, number of blinking stars 


const TILE_MAP_LAYER = preload("res://scenes/tile_map_layer.tscn")

@onready var input_edit: LineEdit = %InputEdit
@onready var speed_edit: LineEdit = %SpeedEdit
@onready var stats: RichTextLabel = %Stats


var tile_map_layer : Board
var my_seed := "Paklong Wan".hash()
var elapsed_time: float = 0.0

var total_steps : int = 0
var cell_alive : int = 0
var max_cell_alive: int = 0
var speed: float = 16.0
var gen_history := []
var tracking_time := true

func _ready() -> void:
	input_edit.text_submitted.connect(_on_input_edit)
	speed_edit.text_changed.connect(_on_speed_edit)
	create_new_tilemap()
	init_cell()
	
func _on_input_edit(_new_seed):
	input_edit.text = _new_seed
	my_seed = _new_seed.hash()
	init_cell()
	
func _on_speed_edit(_new_speed):
	speed = clampf(float(_new_speed), 1, 100) 
	

func reset_stats():
	total_steps = 0
	max_cell_alive = 0
	tracking_time = true
	gen_history = []

func init_cell():
	set_process(false)
	var cleaned = await clean_up()
	if cleaned:
		print ('clean up successful\n')
		randomize_first_gen()
		reset_stats()
		set_process(true)
	
func clean_up():
	tile_map_layer.reset()
	await tile_map_layer.confirmed_all_daed
	return true 


func create_new_tilemap():
	tile_map_layer = TILE_MAP_LAYER.instantiate()
	add_child(tile_map_layer)

func randomize_first_gen():
	seed(my_seed + int(input_edit.text))
	for cell in tile_map_layer.get_children():
		if randi_range(0, randi_range(5, 15)) == 1:
			cell.set_alive()
		else:
			cell.set_dead()
			
			
func check_end_gen() -> int:
	var n1 : int = check_same_step_as_n_last(1)
	if n1:
		return 1
	var n2 : int = check_same_step_as_n_last(2)
	if n2:
		return 2
	var n3 : int = check_same_step_as_n_last(3)
	if n3:
		return 3
	var n4 : int = check_same_step_as_n_last(4)
	if n4:
		return 4
	var n5 : int = check_same_step_as_n_last(5)
	if n5:
		return 5
	var n6 : int = check_same_step_as_n_last(6)
	if n6:
		return 6 
	return 0
	
	
func check_same_step_as_n_last(n):
	if gen_history.size() > n:
		if gen_history[-1] == gen_history[-(n+1)]:
			return n
		else:
			return 0 
	else: 
		return 0
		

func _process(delta: float) -> void:
	await get_tree().process_frame
	
	elapsed_time += delta
	
	if elapsed_time >= 1.0/speed:
		elapsed_time = 0.0 
		cell_alive = 0
		
		if total_steps >= 5:
			for cell in tile_map_layer.get_children():
				if cell.is_alive:
					cell_alive += 1
		
		var instructions := {}
		for cell in tile_map_layer.get_children():
			var instruction = cell.step()
			if instruction:
				instructions[cell] = instruction
		if instructions:
			total_steps += 1
			for cell in instructions:
				cell.call_deferred(instructions[cell])
		
		gen_history.append(str(tile_map_layer))
		
		var is_ended : int = check_end_gen()
		if is_ended > 0 :
			if tracking_time:
				var ending_type : int = check_end_gen()
				var total_score : float = (total_steps + max_cell_alive + cell_alive) * ending_type
				stats.text = 'Total generations: %d\nHighest cells: %d\nEnding cells: %d\nEnding type: %d\nTotal score: %d' % [total_steps, max_cell_alive, cell_alive, ending_type, total_score]
				tracking_time = false 
	
	
	if tracking_time:
		max_cell_alive = max(max_cell_alive, cell_alive)
		var total_score : float = total_steps + max_cell_alive + cell_alive
		stats.text = 'Total generations: %d\nHighest cells: %d\nEnding cells: %d\nTotal score: %d' % [total_steps, max_cell_alive, cell_alive, total_score]
	
		
	
#KaShing Li 19280729 : 134
#KaShing Li 1928 : 266
#Ka Li 19280729 : 1854
#Ka Li 1928 : 1314

#Donald Trump 19460614 : 502
#Dnald Trump 1946 : 726

#Elon Musk 19710628 : 59
#Elon Musk 1971 : 528

#MingKai Lee 19930923 : 608
#MingKai Lee 1993 : 488
#Ming Lee 19930923 : 358
#Ming Lee 1993 : 280
#Isaac Lee 19930923 : 144
#Isaac Lee 1993 : 152

#WingSuen Kwan 19940916 : 1698
#WingSuen Kwan 1994 : 1380
#Wing Kwan 19940916 : 1172
#Wing Kwan 1994 : 562
#Winsey Kwan 19940916 : 4260
#Winsey Kwan 1994 : 1758

#PakLong Wan 19940601 : 826
#PakLong Wan 1994 : 734
#Pak Wan 19940601 : 1082
#Pak Wan 1994 : 648
#Anson Wan 19940601 : 1112
#Anson Wan 1994 : 600
