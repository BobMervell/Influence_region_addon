@tool
extends Node

@export var magnitude_processing_on:bool

@onready var influence_region: InfluenceRegion = $InfluenceRegion
@onready var marker_3d: Marker3D = $Marker3D

func _physics_process(_delta: float) -> void:
	influence_region = $InfluenceRegion
	if not magnitude_processing_on: return
	var x:float = influence_region.get_distance_magnitude(marker_3d.position)
	print(x)
