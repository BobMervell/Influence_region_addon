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

var triangles:Array[Dictionary]

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
		var triangle_mesh:MeshInstance3D = draw_multi_line(_get_triangle_array(center,triangle_size,start_offset,i))
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
		update_extremum(triangle_nbr-1,mesh_array[i])
	return mesh_array
