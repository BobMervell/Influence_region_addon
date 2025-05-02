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
