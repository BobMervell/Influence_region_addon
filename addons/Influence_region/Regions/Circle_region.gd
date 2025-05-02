@tool
extends BaseRegion
class_name CircleRegion


@export_range(0,100,.01,"or_greater") var radius:float = 1:
	set(new_value):
		radius = new_value
		on_parameter_updated.emit()


func _get_circle_array(center:Vector3,circle_radius:float) -> Array[Vector3]:
	var precision = 2*PI/20
	var circle_array:Array[Vector3]
	for i in range(0,21):
		var pos:Vector3 = Vector3(circle_radius,0,0)
		circle_array.append(pos.rotated(Vector3.UP,i*precision) + center)
	return circle_array

func get_meshs(center:Vector3, nbr_sub_regions:int) -> Array[MeshInstance3D]:
	var meshs:Array[MeshInstance3D]
	for i in range(1,nbr_sub_regions+2):
		var circle_radius:float = i * radius/(nbr_sub_regions+1)
		var circle_array:Array[Vector3] = _get_circle_array(center,circle_radius)
		var circle_mesh:MeshInstance3D = draw_multi_line(circle_array)
		meshs.append(circle_mesh)
	return meshs
