class_name MusicTrigger
extends Resource

## fade_in_curve / fade_out_curve: Y axis = linear volume multiplier
## (converted to dB via linear_to_db() at runtime). The curve's end value
## IS the target volume, no separate volume field.

@export var file_path: String = ""
@export var fade_in_duration: float = 1.0
@export var fade_in_curve: Curve
@export var fade_out_duration: float = 1.0
@export var fade_out_curve: Curve

static func from_dict(d: Dictionary) -> MusicTrigger:
	var t := MusicTrigger.new()
	t.file_path = d.get("file", t.file_path)
	t.fade_in_duration = d.get("fade_in_duration", t.fade_in_duration)
	t.fade_in_curve = _curve_from_points(d.get("fade_in_curve", []))
	t.fade_out_duration = d.get("fade_out_duration", t.fade_out_duration)
	t.fade_out_curve = _curve_from_points(d.get("fade_out_curve", []))
	return t

func to_dict() -> Dictionary:
	return {
		"file": file_path,
		"fade_in_duration": fade_in_duration,
		"fade_in_curve": _curve_to_points(fade_in_curve),
		"fade_out_duration": fade_out_duration,
		"fade_out_curve": _curve_to_points(fade_out_curve),
	}

static func _curve_from_points(points: Array) -> Curve:
	var c := Curve.new()
	for p in points:
		c.add_point(Vector2(p.get("x", 0.0), p.get("y", 0.0)))
	return c

static func _curve_to_points(curve: Curve) -> Array:
	var points: Array = []
	if curve == null:
		return points
	for i in curve.point_count:
		var pos := curve.get_point_position(i)
		points.append({"x": pos.x, "y": pos.y})
	return points
