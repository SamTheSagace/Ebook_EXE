class_name MusiqueTrigger
extends Resource

## fade_in_courbe / fade_out_courbe : axe Y = multiplicateur de volume linéaire
## (converti en dB via linear_to_db() au runtime). La valeur finale de la
## courbe EST le volume cible, pas de champ volume séparé.

@export var fichier: String = ""
@export var fade_in_duree: float = 1.0
@export var fade_in_courbe: Curve
@export var fade_out_duree: float = 1.0
@export var fade_out_courbe: Curve

static func from_dict(d: Dictionary) -> MusiqueTrigger:
	var t := MusiqueTrigger.new()
	t.fichier = d.get("fichier", t.fichier)
	t.fade_in_duree = d.get("fade_in_duree", t.fade_in_duree)
	t.fade_in_courbe = _courbe_from_points(d.get("fade_in_courbe", []))
	t.fade_out_duree = d.get("fade_out_duree", t.fade_out_duree)
	t.fade_out_courbe = _courbe_from_points(d.get("fade_out_courbe", []))
	return t

func to_dict() -> Dictionary:
	return {
		"fichier": fichier,
		"fade_in_duree": fade_in_duree,
		"fade_in_courbe": _courbe_to_points(fade_in_courbe),
		"fade_out_duree": fade_out_duree,
		"fade_out_courbe": _courbe_to_points(fade_out_courbe),
	}

static func _courbe_from_points(points: Array) -> Curve:
	var c := Curve.new()
	for p in points:
		c.add_point(Vector2(p.get("x", 0.0), p.get("y", 0.0)))
	return c

static func _courbe_to_points(courbe: Curve) -> Array:
	var points: Array = []
	if courbe == null:
		return points
	for i in courbe.point_count:
		var pos := courbe.get_point_position(i)
		points.append({"x": pos.x, "y": pos.y})
	return points
