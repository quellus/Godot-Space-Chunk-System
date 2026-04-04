class_name Space extends Node3D

@export var space_chunk_scene: PackedScene
@export var chunk_radius: int = 3
@export var focus: Node3D

var active_chunks: Array[SpaceChunk] = []
var chunk_delete_queue: Array[SpaceChunk] = []
var chunk_generate_queue: Array[SpaceChunk] = []

var chunk_process_state: ChunkProcessState = ChunkProcessState.CHECK
enum ChunkProcessState {
	CHECK,
	DELETE,
	GENERATE
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var focus_chunk_coord = Vector3i(focus.global_position / space_chunk_scene.CHUNK_SIZE)
	if chunk_process_state == ChunkProcessState.CHECK:
		_add_chunks_to_gen_queue(focus_chunk_coord)
		_add_chunks_to_delete_queue(focus_chunk_coord)
		chunk_process_state = ChunkProcessState.DELETE
	if chunk_process_state == ChunkProcessState.DELETE:
		_pop_delete_queue()
		chunk_process_state = ChunkProcessState.GENERATE
	if chunk_process_state == ChunkProcessState.GENERATE:
		_pop_gen_queue()
		chunk_process_state = ChunkProcessState.CHECK
	for x in range(-chunk_radius, chunk_radius):
		for y in range(-chunk_radius, chunk_radius):
			for z in range(-chunk_radius, chunk_radius):
				_generate_chunk(Vector3i(x, y, z))




func _generate_chunk(chunk_coord: Vector3i):
	var space_chunk = space_chunk_scene.instantiate()
	add_child(space_chunk)
	space_chunk.chunk_coord = chunk_coord
	space_chunk.generate()
	active_chunks.append(space_chunk)
