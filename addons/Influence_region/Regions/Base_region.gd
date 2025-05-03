@tool
extends Resource
class_name BaseRegion

signal on_parameter_updated()
enum SolverType {Sequential,Binary} 
enum MagnitudeVariation {Constant,Ascending,Descending}

var mesh_extremums:Array[Dictionary]

## Draw a multipointLine
func draw_multi_line(position_list:Array[Vector3], color:=Color.WHITE, shadow_on:=false) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	if shadow_on: mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	else: mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(position_list[0])
	for i in range(1,position_list.size()-1):
		immediate_mesh.surface_add_vertex(position_list[i])
		immediate_mesh.surface_add_vertex(position_list[i])
	immediate_mesh.surface_add_vertex(position_list[-1])
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	return mesh_instance

#func find_first_greater_than(arr: Array, x: float) -> float:
	#var low: int = 0
	#var high: int = arr.size() - 1
	#var result: float = 0
	#var i = 0
	#while low <= high  and i < 100:
		#i+=1
		#var mid: int = (low + high) / 2
		#if arr[mid] > x:
			#high = mid 
			#result = mid 
		#else:
			#low = mid +1
	#return result

func get_distance_magnitude(solver_type:SolverType,magnitude_variation:MagnitudeVariation,
		center:Vector3,pos:Vector3,nbr_sub_regions:int) -> float:
	return 0

func get_meshs(center:Vector3, nbr_sub_regions:int,start_offset:Vector2) -> Array[MeshInstance3D]:
	return []

## format the output amplitude to follow the currnt MagnitudeVariation mode
func format_output(magnitude_variation:MagnitudeVariation,magnitude:float,nbr_sub_regions:int) -> float:
	if magnitude_variation == MagnitudeVariation.Constant:
		return ceil(magnitude)
	elif magnitude_variation == MagnitudeVariation.Ascending:
		if magnitude == 0: return 0
		return 1 + 1/float(nbr_sub_regions) - magnitude
	elif magnitude_variation == MagnitudeVariation.Descending:
		return magnitude
	return 0

func update_extremum(mesh_indx:int,pos:Vector3) -> void:
	mesh_extremums[mesh_indx]["max_x"] = max(mesh_extremums[mesh_indx]["max_x"],pos.x)
	mesh_extremums[mesh_indx]["min_x"] = min(mesh_extremums[mesh_indx]["min_x"],pos.x)
	mesh_extremums[mesh_indx]["max_z"] = max(mesh_extremums[mesh_indx]["max_z"],pos.z)
	mesh_extremums[mesh_indx]["min_z"] = min(mesh_extremums[mesh_indx]["min_z"],pos.z)

func get_extremum_meshs(center) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	for ext:Dictionary in mesh_extremums:
		var arr:Array[Vector3] = [
			Vector3(ext.max_x,center.y,ext.max_z),
			Vector3(ext.max_x,center.y,ext.min_z),
			Vector3(ext.min_x,center.y,ext.min_z),
			Vector3(ext.min_x,center.y,ext.max_z),
			Vector3(ext.max_x,center.y,ext.max_z)
		]
		meshs.append(draw_multi_line(arr,Color.RED))
	return meshs
