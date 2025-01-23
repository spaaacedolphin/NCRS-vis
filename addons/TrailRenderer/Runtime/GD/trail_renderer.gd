class_name TrailRenderer
extends LineRenderer


@export var lifetime: int = 1
@export var min_vertex_distance: float = 0.5

var _trail_pieces: Array = []

func _enter_tree() -> void:
	super._enter_tree()
	_trail_pieces.append(TrailPiece.new(self))


func update() -> void:
	if _trail_pieces.size()==0:
		_trail_pieces.insert(0, TrailPiece.new(self))

	if _trail_pieces.size() > 0:
		_trail_pieces[0].on_delete_complete = _on_delete_complete

	for i in _trail_pieces.size():
		_trail_pieces[i].process()


func _on_delete_complete() -> void:
	var last_idx: int = _trail_pieces.size() - 1
	_trail_pieces.remove_at(last_idx)
