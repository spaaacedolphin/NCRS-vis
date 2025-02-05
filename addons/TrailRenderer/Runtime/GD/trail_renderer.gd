class_name TrailRenderer
extends LineRenderer


@export var lifetime: int = 1
@export var min_vertex_distance: float = 0.5

var _trail_piece: TrailPiece

func _enter_tree() -> void:
	super._enter_tree()
	_trail_piece = TrailPiece.new(self)

func update() -> void:
	_trail_piece.process()
