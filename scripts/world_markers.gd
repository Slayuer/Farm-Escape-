extends Node3D

## WORLD MARKERS — purely a visual testing aid, not a real gameplay system.
##
## The MVP test scene is intentionally empty (no farm art yet), which makes it
## nearly impossible to tell whether the player is actually moving, especially
## on a slow/software-rendered device. This script spawns a line of simple
## colored posts along both sides of the lane so forward speed and left/right
## steering are obvious to see, even at a low frame rate.
##
## This is a temporary debug tool — it gets replaced once real farm-row art
## exists (crop rows, fences, etc. from the design brief).

@export var post_spacing: float = 20.0    # distance between each pair of posts
@export var post_count: int = 20          # how many pairs to spawn down the lane
@export var lane_half_width: float = 5.0  # how far from center each post sits

func _ready() -> void:
	var post_mesh := BoxMesh.new()
	post_mesh.size = Vector3(0.5, 3.0, 0.5)

	var post_material := StandardMaterial3D.new()
	post_material.albedo_color = Color(0.9, 0.2, 0.2)  # bright red, easy to spot passing by

	for i in range(post_count):
		var z_position := -float(i) * post_spacing
		for side in [-1, 1]:
			var post := MeshInstance3D.new()
			post.mesh = post_mesh
			post.material_override = post_material
			post.position = Vector3(side * lane_half_width, 1.5, z_position)
			add_child(post)
