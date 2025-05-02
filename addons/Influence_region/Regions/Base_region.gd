@tool
extends Resource
class_name BaseRegion

signal on_parameter_updated()

## Draw a multipointLine
func draw_multi_line(position_list:Array[Vector3], color:=Color.BLACK, shadow_on:=false) -> MeshInstance3D:
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

func find_first_greater_than(arr: Array, x: float) -> float:
	var low: int = 0
	var high: int = arr.size() - 1
	var result: float = 0
	var i = 0
	while low <= high  and i < 100:
		i+=1
		var mid: int = (low + high) / 2
		if arr[mid] > x:
			high = mid 
			result = mid 
		else:
			low = mid +1
	return result

func get_distance_magnitude(center:Vector3,pos:Vector3,nbr_sub_regions:int) -> int:
	return 0

func get_meshs(center:Vector3, nbr_sub_regions:int) -> Array[MeshInstance3D]:
	return []
