@tool
extends BaseRegion
class_name CircleRegion


@export_range(.01,100,.01,"exp","or_greater") var radius:float = 1:
	set(new_value):
		radius = new_value
		on_parameter_updated.emit()

##Ignored in 2D
@export var detection_height:float = 1.

var nbr_points:int = 20
var circles:Array[Dictionary]

func _get_circle_array(center:Vector3,circle_radius:float,start_offset:Vector2,circle_nbr:int) -> Array[Vector3]:
	var precision = 2*PI/nbr_points
	start_offset = start_offset * radius * (1 - circle_radius/radius)
	var start_pos:Vector3 = center + Vector3(start_offset.x,0,start_offset.y)
	circles[circle_nbr-1]["center"] = start_pos
	mesh_extremums.append({
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	})
	
	var mesh_array:Array[Vector3]
	for i in range(0,nbr_points + 1):
		var point_position:Vector3 = Vector3(circle_radius,0,0).rotated(Vector3.UP,i*precision) + start_pos
		update_extremum(circle_nbr-1,point_position)
		mesh_array.append(point_position)
	return mesh_array

func get_meshs(center:Vector3, nbr_sub_regions:int,start_offset:Vector2) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	circles.clear()
	mesh_extremums.clear()
	for i in range(1,nbr_sub_regions+1):
		var circle_radius:float = i * radius/(nbr_sub_regions)
		circles.append({
				"radius":pow(circle_radius,2)
				})
		var circle_array:Array[Vector3] = _get_circle_array(center,circle_radius,start_offset,i)
		var circle_mesh:MeshInstance3D = draw_multi_line(circle_array)
		meshs.append(circle_mesh)
	circles.append({
				"radius":pow(radius,2)
				})
	var circle_array:Array[Vector3] = _get_circle_array(center,radius,start_offset,nbr_sub_regions+1)
	var circle_mesh:MeshInstance3D = draw_multi_line(circle_array)
	meshs.append(circle_mesh)
	return meshs

func get_distance_magnitude(solver_type:SolverType,magnitude_variation:MagnitudeVariation,
		center:Vector3,pos:Vector3,nbr_sub_regions:int) -> float:
	if not(circles[0].has("radius") and circles[0].has("center")): return 0
	if pos.y > center.y + detection_height or pos.y < center.y:
		return 0
	var pos_2D:Vector2 = Vector2(pos.x,pos.z)
	var center_2D:Vector2 = Vector2(circles[-1].center.x,circles[-1].center.z)
	var magnitude:float = nbr_sub_regions - find_first_greater_than(solver_type,pos_2D)
	if nbr_sub_regions > 0: magnitude = magnitude/float(nbr_sub_regions)
	return format_output(magnitude_variation,magnitude,nbr_sub_regions)

func find_first_greater_than(solver_type:SolverType,pos_2D:Vector2) -> float:
	if solver_type == SolverType.Sequential:
		return sequential_solver(pos_2D)
	if solver_type == SolverType.Binary:
		return binary_solver(pos_2D)
	return circles.size() -1

func sequential_solver(pos_2D:Vector2) -> int:
	for i in range(circles.size()):
		var center_2D:Vector2 = Vector2(circles[i].center.x,circles[i].center.z)
		if pos_2D.distance_squared_to(center_2D) < circles[i].radius:
			return i
	return circles.size() -1

func binary_solver(pos_2D):
	var low: int = 0
	var high: int = circles.size() - 1
	var result: float = circles.size() -1
	var i=0
	while low <= high and i < circles.size():
		i +=1
		var mid: int = (low + high) / 2
		var center_2D:Vector2 = Vector2(circles[mid].center.x,circles[mid].center.z)
		if pos_2D.distance_squared_to(center_2D) < circles[mid].radius:
			high = mid 
			result = mid 
		else:
			low = mid +1
	return result
