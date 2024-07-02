extends GridMap

const blocks := preload("res://Objects/Minerals/mineral.tscn")
const rockData := preload("res://Objects/Minerals/rock/rock.tres")
const mineral1Data := preload("res://Objects/Minerals/mineral1/mineral1.tres")

var replaced_cells := []
@onready var staticBody := $"../StaticBody3D"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func get_used_cells_by_id(id: int):
	var arr = []
	var cells = get_used_cells()
	for i in cells:
		if (get_cell_item(i) == id): arr.append(i)
	return arr
	
func replace_tile(cellArr: Array, inst: PackedScene, data: MineralData):
	var cellPos = Vector3()
	for i in cellArr:
		var newObject = new_object(i, cellPos, inst, data)
		
func new_object(cell: Vector3, cellPos: Vector3, inst:PackedScene, data: MineralData):
	var newInst = inst.instantiate()
	(newInst as Mineral).data = data
	cellPos = map_to_local(cell)
	set_cell_item(cell, -1)
	staticBody.add_child(newInst)
	newInst.position = cellPos
	replaced_cells.append(newInst)

func _process_terrain():
	var mineral3 = get_used_cells_by_id(3)
	var mineral1 = get_used_cells_by_id(1)
	var rock = get_used_cells_by_id(0)
	replace_tile(rock, blocks, rockData)
	replace_tile(mineral1, blocks, mineral1Data)
	update_grid_visibility()

func _on_heightmap_generator_3d_generation_finished():
	_process_terrain()

func update_grid_visibility():
	for cell in replaced_cells:
		if cell is Mineral:
			cell.scan_and_update_faces()
