extends GridMap

const mineral := preload("res://Objects/Enemy.tscn")
const blocks := preload("res://Objects/Minerals/mineral.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_used_cells_by_id(id: int):
	var arr = []
	var cells = get_used_cells()
	for i in cells:
		if (get_cell_item(i) == id): arr.append(i)
	return arr
	
func replace_tile(cellArr: Array, inst: PackedScene):
	var cellPos = Vector3()
	for i in cellArr:
		var newObject = new_object(i, cellPos, inst)
		
func new_object(cell: Vector3, cellPos: Vector3, inst:PackedScene):
	var newInst = inst.instantiate()
	cellPos = map_to_local(cell)
	set_cell_item(cell, -1)
	add_child(newInst)
	newInst.position = cellPos

func _on_heightmap_generator_3d_generation_finished():
	var mineral3 = get_used_cells_by_id(3)
	var rock = get_used_cells_by_id(0)
	#replace_tile(rock, blocks)
	replace_tile(mineral3, mineral)
