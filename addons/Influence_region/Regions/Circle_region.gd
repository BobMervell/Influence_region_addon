@tool
extends BaseRegion
class_name CircleRegion

@export_range(.01,100,.01,"exp","or_greater") var radius:float = 1:
	set(new_value):
		radius = new_value
		on_parameter_updated.emit()

var nbr_points:int = 20
var circles:Array[Dictionary]

## Returns the list of points needed to draw a circle
func _get_circle_array(center:Vector3,circle_radius:float,start_offset:Vector2,circle_nbr:int) -> Array[Vector3]:
	var precision = 2*PI/nbr_points
	start_offset = start_offset * radius * (1 - circle_radius/radius)
	var start_pos:Vector3 = center + Vector3(start_offset.x,0,start_offset.y)
	circles[circle_nbr]["center"] = start_pos
	mesh_extremums.append({
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	})
	
	var mesh_array:Array[Vector3]
	for i in range(0,nbr_points + 1):
		var point_position:Vector3 = Vector3(circle_radius,0,0).rotated(Vector3.UP,i*precision) + start_pos
		update_extremum(circle_nbr,point_position)
		mesh_array.append(point_position)
	return mesh_array

## Returns a list of all circles
func get_meshs(center:Vector3, nbr_regions:int,start_offset:Vector2) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	circles.clear()
	mesh_extremums.clear()
	for i in range(1,nbr_regions):
		var circle_radius:float = (i) * radius/(nbr_regions+1)
		circles.append({
				"radius":pow(circle_radius,2)
				})
		var circle_array:Array[Vector3] = _get_circle_array(center,circle_radius,start_offset,i-1)
		var circle_mesh:MeshInstance3D = draw_multi_line(circle_array)
		meshs.append(circle_mesh)
	circles.append({
				"radius":pow(radius,2)
				})
	var circle_array:Array[Vector3] = _get_circle_array(center,radius,start_offset,nbr_regions-1)
	var circle_mesh:MeshInstance3D = draw_multi_line(circle_array)
	meshs.append(circle_mesh)
	return meshs

## Override perimeter detection for simpler inside/outside detection (radius based).
#region Detection

func circle_sequential_solver(pos_2D:Vector2) -> int:
	for i in range(circles.size()):
		var center_2D:Vector2 = Vector2(circles[i].center.x,circles[i].center.z)
		if pos_2D.distance_squared_to(center_2D) < circles[i].radius:
			return i
	return circles.size() # final output -> 0


func circle_binary_solver(pos_2D):
	var low: int = 0
	var high: int = circles.size()
	var result: float = circles.size()
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
#endregion
