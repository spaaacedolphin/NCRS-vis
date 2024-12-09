class_name TrailPiece


var on_delete_complete: Callable

var _time: int = 0
var _last_position: Vector3 = Vector3()
var _last_spawn_point: Vector3 = Vector3()
var _is_moving: bool = false
var _line_renderer: LineRenderer = LineRenderer.new()
var _trail_renderer: TrailRenderer


func _init(source_trail_renderer: TrailRenderer) -> void:
	self._trail_renderer = source_trail_renderer
	_trail_renderer.add_child(_line_renderer)

	_last_position = _trail_renderer.global_position
	_last_spawn_point = _trail_renderer.global_position


func process() -> void:
	_line_renderer.copy_values(_trail_renderer)
	_time = Global.cur_step
	_is_moving = _last_position != _line_renderer.global_position
	_last_position = _line_renderer.global_position
	
	if not _trail_renderer.is_emitting:
		_last_spawn_point = _trail_renderer.global_position
		_remove_points()
		return
		
	_add_points()
	_remove_points()

	if _line_renderer.points.size() == 0: #and is_dirty():
		on_delete_complete.call()
		_line_renderer.queue_free()
		
	
func _add_points() -> void:

	if _line_renderer.points.size() == 0 and _is_moving:
		_line_renderer.points.append(Point.new(_line_renderer.global_position))
		_line_renderer.points.append(Point.new(_line_renderer.global_position))

	if (
		_last_spawn_point.distance_to(_line_renderer.global_position) > _trail_renderer.min_vertex_distance 
		and _line_renderer.points.size() > 0
	):
		var previous_position: Vector3 = _line_renderer.points[-2].position
		_line_renderer.points[-2].position = _line_renderer.global_position
		_line_renderer.points.insert(_line_renderer.points.size() - 2, Point.new(previous_position, _trail_renderer.global_basis.x.normalized()))
		_last_spawn_point = _line_renderer.global_position

	if _line_renderer.points.size() > 1:
		_line_renderer.points[-1].position = _line_renderer.global_position
		_line_renderer.points[-1].alignment_vector = _trail_renderer.global_basis.x
		_line_renderer.points[-2].alignment_vector = _trail_renderer.global_basis.x


func _remove_points() -> void:

	for i in _line_renderer.points.size():
		if abs(_time - _line_renderer.get_point(0).time) > _trail_renderer.lifetime:
			_line_renderer.points.remove_at(0)
