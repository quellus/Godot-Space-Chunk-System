class_name SpaceChunk extends Node3D

const SPACE_OBJECT = preload("res://scenes/space_object.tscn")


var chunk_size: int = 16:
	set(value):
		chunk_size = value
		chunk_radius = chunk_size/2

var chunk_radius: int = 8


var chunk_coord: Vector3i = Vector3i.ZERO:
	set(value):
		chunk_coord = value
		global_position = Vector3(value) * chunk_size

var fast_noise_lite: FastNoiseLite = load("res://resources/new_fast_noise_lite.tres")

func generate() -> void:
	fast_noise_lite.seed = hash(chunk_coord)
	var avg_cubes = 1
	for n in range(avg_cubes):
		var rand_x = n
		var random_position = Vector3(
			fast_noise_lite.get_noise_2d(rand_x, 1),
			fast_noise_lite.get_noise_2d(rand_x, 2),
			fast_noise_lite.get_noise_2d(rand_x, 3)
		)
		var sized_position = random_position * chunk_radius
		var global_coords: Vector3 = global_position + sized_position
		var space_object = SPACE_OBJECT.instantiate()
		add_child(space_object);
		space_object.add_to_group("SpaceObjects")
		space_object.global_position = global_coords
