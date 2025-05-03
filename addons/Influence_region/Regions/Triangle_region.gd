@tool
extends BaseRegion
class_name TriangleRegion

@export_range(.01,100,.01,"or_greater") var length_A_B:float =5:
	set(new_value):
		length_A_B = new_value
		on_parameter_updated.emit()
@export_range(.01,100,.01,"or_greater") var length_B_C:float =5:
	set(new_value):
		length_B_C = new_value
		on_parameter_updated.emit()
@export_range(.01,100,.01,"or_greater") var length_C_A:float =5:
	set(new_value):
		length_C_A = new_value
		on_parameter_updated.emit()
##Ignored in 2D
@export var detection_height:float = 1.

var triangles:Array[Array]

func get_meshs(center:Vector3, nbr_sub_regions:int,start_offset:Vector2) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	triangles.clear()
	mesh_extremums.clear()
	if ( (length_A_B >= length_B_C +length_C_A) or
			(length_B_C >= length_A_B +length_C_A) or 
			(length_C_A >= length_A_B +length_B_C) ):
		return meshs
	for i in range(1,nbr_sub_regions+1):
		var triangle_size:float = i/float(nbr_sub_regions)
		var triangle_mesh:MeshInstance3D = draw_multi_line(_get_triangle_array(center,triangle_size,start_offset,i-1))
		meshs.append(triangle_mesh)
	var triangle_mesh:MeshInstance3D = draw_multi_line(_get_triangle_array(center,1,start_offset,nbr_sub_regions))
	meshs.append(triangle_mesh)
	return meshs

func _get_triangle_array(center:Vector3,x:float,start_offset:Vector2,triangle_nbr:int) -> Array[Vector3]:
	mesh_extremums.append({
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	})
	var mesh_array:Array[Vector3] = [center] #A
	mesh_array.append(center + Vector3((length_A_B*x),0,0)) #B	
	var alpha = acos( ((length_A_B*x)**2 + (length_C_A*x)**2 - (length_B_C*x)**2)/(2*(length_A_B*x)*(length_C_A*x)) )
	mesh_array.append(center + Vector3(cos(alpha) * (length_C_A*x) ,0,sin(alpha) * (length_C_A*x))) #C
	mesh_array.append(center) #A

	# offset triangle to put centroid in the center
	var centroid:Vector3 = (mesh_array[0] + mesh_array[1] + mesh_array[2])/3
	start_offset = start_offset * x * (length_A_B +length_B_C +length_C_A)/3

	var diff = (center+Vector3(start_offset.x,0,start_offset.y)) -centroid
	for i in range(mesh_array.size()):
		mesh_array[i] += diff
		update_extremum(triangle_nbr,mesh_array[i])
	
	#Add every side to the triangle memory
	triangles.append([])
	triangles[triangle_nbr].append({
		"A": mesh_array[0],
		"B": mesh_array[1]
	})
	triangles[triangle_nbr].append({
		"A": mesh_array[1],
		"B": mesh_array[2]
	})
	triangles[triangle_nbr].append({
		"A": mesh_array[2],
		"B": mesh_array[0]
	})
	
	return mesh_array

func get_distance_magnitude(solver_type:SolverType,magnitude_variation:MagnitudeVariation,
		center:Vector3,pos:Vector3,nbr_sub_regions:int) -> float:
	if pos.y > center.y + detection_height or pos.y < center.y:
		return 0
	var pos_2D:Vector2 = Vector2(pos.x,pos.z)
	var magnitude:float = find_first_greater_than(solver_type,pos_2D)
	return format_output(magnitude_variation,magnitude,nbr_sub_regions)


func find_first_greater_than(solver_type:SolverType,pos_2D:Vector2) -> float:
	if solver_type == SolverType.Sequential:
		return sequential_solver(pos_2D)
	if solver_type == SolverType.Binary:
		return binary_solver(pos_2D)
	return triangles.size() -1

func sequential_solver(pos_2D:Vector2) -> int:
	for i in range(triangles.size()):
		if is_inside_polygon(pos_2D,i):
			return i
	return triangles.size() # final output -> 0

func binary_solver(pos_2D):
	var low: int = 0
	var high: int = triangles.size()
	var result: float = triangles.size()
	var i=0
	while low <= high and i < triangles.size():
		i += 1
		var mid: int = (low + high) / 2
		if is_inside_polygon(pos_2D,mid):
			high = mid 
			result = mid 
		else:
			low = mid +1
	return result

func is_inside_polygon(pos_2D:Vector2,polygon_indx:int)-> bool:
	#position outside the polygon box with padding
	var edge_pos:Vector2 = Vector2(mesh_extremums[polygon_indx].max_x + .1 ,0) 
	var nbr_collisions:int=0
	for sides:Dictionary in triangles[polygon_indx]:
		var A:Vector2 = Vector2(sides.A.x,sides.A.z)
		var B:Vector2 = Vector2(sides.B.x,sides.B.z)
		if do_vectors_collides(pos_2D,edge_pos,A,B):
			nbr_collisions +=1
	if nbr_collisions % 2 == 0:
		return false
	return true
