@tool
extends BaseRegion
class_name TriangleRegion

@export_range(.01,100,.01,"or_greater") var length_A_B:float =2:
	set(new_value):
		length_A_B = new_value
		size = (length_A_B +length_B_C +length_C_A)/3
		on_parameter_updated.emit()
@export_range(.01,100,.01,"or_greater") var length_B_C:float =2:
	set(new_value):
		length_B_C = new_value
		size = (length_A_B +length_B_C +length_C_A)/3
		on_parameter_updated.emit()
@export_range(.01,100,.01,"or_greater") var length_C_A:float =2:
	set(new_value):
		length_C_A = new_value
		size = (length_A_B +length_B_C +length_C_A)/3
		on_parameter_updated.emit()

var size:float = (length_A_B +length_B_C +length_C_A)/3

## Returns the list of points needed to draw a triangle
func _get_triangle_array(center:Vector3,triangle_size:float,start_offset:Vector2,triangle_nbr:int) -> Array[Vector3]:
	mesh_extremums.append({
		"max_x": -INF, "min_x": +INF,
		"max_z": -INF, "min_z": +INF,
	})
	var mesh_array:Array[Vector3] = [center] #A
	mesh_array.append(center + Vector3((length_A_B*triangle_size),0,0)) #B	
	var alpha = acos( ((length_A_B*triangle_size)**2 + (length_C_A*triangle_size)**2 - (length_B_C*triangle_size)**2)/(2*(length_A_B*triangle_size)*(length_C_A*triangle_size)) )
	mesh_array.append(center + Vector3(cos(alpha) * (length_C_A*triangle_size) ,0,sin(alpha) * (length_C_A*triangle_size))) #C
	mesh_array.append(center) #A
	
	# offset triangle to put centroid in the center
	var centroid:Vector3 = (mesh_array[0] + mesh_array[1] + mesh_array[2])/3

	var diff = (center+Vector3(start_offset.x,0,start_offset.y)) -centroid
	for i in range(mesh_array.size()):
		mesh_array[i] += diff
		update_extremum(triangle_nbr,mesh_array[i])
	
	#Add every side to the polygon_array
	polygon_array.append([])
	polygon_array[triangle_nbr].append({
		"A": mesh_array[0],
		"B": mesh_array[1]
	})
	polygon_array[triangle_nbr].append({
		"A": mesh_array[1],
		"B": mesh_array[2]
	})
	polygon_array[triangle_nbr].append({
		"A": mesh_array[2],
		"B": mesh_array[0]
	})
	
	return mesh_array

## Returns a list of all triangles
func get_meshs(center:Vector3, nbr_regions:int,start_offset:Vector2) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	polygon_array.clear()
	mesh_extremums.clear()
	if ( (length_A_B >= length_B_C +length_C_A) or
			(length_B_C >= length_A_B +length_C_A) or 
			(length_C_A >= length_A_B +length_B_C) ):
		return meshs
	for i in range(1,nbr_regions):
		var x:float = i/float(nbr_regions)
		var triangle_size:float = x  * size
		var offset = process_start_offset(start_offset,x,size)
		var triangle_mesh:MeshInstance3D = draw_multi_line(_get_triangle_array(center,triangle_size,offset,i-1))
		meshs.append(triangle_mesh)
	var offset = process_start_offset(start_offset,1,size)
	var triangle_mesh:MeshInstance3D = draw_multi_line(_get_triangle_array(center,size,offset,nbr_regions-1))
	meshs.append(triangle_mesh)
	return meshs
