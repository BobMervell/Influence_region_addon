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
		magnitude = nbr_sub_regions + 1 - magnitude
		return ceil(magnitude/float(nbr_sub_regions+1))
	elif magnitude_variation == MagnitudeVariation.Ascending:
		magnitude = (magnitude+1)/float(nbr_sub_regions)
		if magnitude > 1: return 0
		return magnitude
	elif magnitude_variation == MagnitudeVariation.Descending:
		magnitude = nbr_sub_regions + 1 - magnitude
		return magnitude/float(nbr_sub_regions+1)
	return 0

func update_extremum(mesh_indx:int,pos:Vector3) -> void:
	mesh_extremums[mesh_indx]["max_x"] = max(mesh_extremums[mesh_indx]["max_x"],pos.x)
	mesh_extremums[mesh_indx]["min_x"] = min(mesh_extremums[mesh_indx]["min_x"],pos.x)
	mesh_extremums[mesh_indx]["max_z"] = max(mesh_extremums[mesh_indx]["max_z"],pos.z)
	mesh_extremums[mesh_indx]["min_z"] = min(mesh_extremums[mesh_indx]["min_z"],pos.z)

func do_vectors_collides(vec1_A:Vector2,vec1_B:Vector2,
		vec2_A:Vector2,vec2_B:Vector2) -> bool:
	 # get infinite line expression of first segment
	var a1 = vec1_B.y - vec1_A.y
	var b1 = vec1_A.x - vec1_B.x
	var c1 = (vec1_B.x * vec1_A.y) - (vec1_A.x * vec1_B.y)
	
	# get infinite line expression of first segment
	var a2 = vec2_B.y - vec2_A.y
	var b2 = vec2_A.x - vec2_B.x
	var c2 = (vec2_B.x * vec2_A.y) - (vec2_A.x * vec2_B.y)
	
	if is_equal_approx(a1*b2 , a2*b1): return false # Colinear
	
	# solve first line equation with both segments points 
	var p1 = (a1 * vec2_A.x) + (b1 * vec2_A.y) + c1
	var p2 = (a1 * vec2_B.x) + (b1 * vec2_B.y) + c1
	
	#if p1 and p2 same sign then they are on the same side of the line thus can't have crossed first line
	if ((p1 > 0 and p2 > 0 ) or (p1 < 0 and p2 < 0 )): return false
	
	# The fact that vector 2 intersected the infinite line 1 above doesn't 
	# mean it also intersects the vector 1. Vector 1 is only a subset of that
	# infinite line 1, so it may have intersected that line before the vector
	# started or after it ended. Thus we need to check the other way around.
	p1 = (a2 * vec1_A.x) + (b2 * vec1_A.y) + c2
	p2 = (a2 * vec1_B.x) + (b2 * vec1_B.y) + c2
	if ((p1 > 0 and p2 > 0 ) or (p1 < 0 and p2 < 0 )): return false
	return true

##DEPRECATED
## (only used for devellopement debugging )
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
