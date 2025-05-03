@tool
extends Resource
class_name BaseRegion

signal on_parameter_updated()
enum SolverType {Sequential,Binary} 
enum MagnitudeVariation {Constant,Ascending,Descending}

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
