extends TileMapLayer

class_name Board

signal confirmed_all_daed

var all_cells : Array 

func _ready():
	confirmed_all_daed.connect(_on_confirmed_all_daed)

func reset():
	while true:
		all_cells = get_children()
		#print (all_cells.size())
		if all_cells.size() <= 0:
			await get_tree().create_timer(0.01).timeout
			continue
		
		break

	for i : Cell in all_cells:
		i.set_dead()
	
	check_all_dead()
			
func check_all_dead():
	while true:
		all_cells = get_children()
		for i : Cell in all_cells:
			if i.is_alive:
				await get_tree().create_timer(0.01).timeout
				continue
		break 
	await get_tree().create_timer(0.01).timeout
	confirmed_all_daed.emit()

func _on_confirmed_all_daed():
	print ('confirmed_all_daed')

func _to_string() -> String:
	var return_string := ''
	all_cells = get_children()
	for i : Cell in all_cells:
		return_string += str(i)
	return return_string
		 
	
