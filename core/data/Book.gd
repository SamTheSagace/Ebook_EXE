class_name Book
extends Resource

const FORMAT_VERSION := 1

@export var format_version: int = FORMAT_VERSION
@export var allow_skip: bool = true
@export var default_typing_speed: TypingSpeed
@export var paragraphs: Array[Paragraph] = []

static func from_dict(d: Dictionary) -> Book:
	var b := Book.new()
	b.format_version = d.get("format_version", b.format_version)
	b.allow_skip = d.get("allow_skip", b.allow_skip)
	b.default_typing_speed = TypingSpeed.from_dict(d.get("default_typing_speed", {}))
	for p in d.get("paragraphs", []):
		b.paragraphs.append(Paragraph.from_dict(p))
	return b

func to_dict() -> Dictionary:
	var paragraphs_dict: Array = []
	for p in paragraphs:
		paragraphs_dict.append(p.to_dict())
	var d := {
		"format_version": format_version,
		"allow_skip": allow_skip,
		"default_typing_speed": null,
		"paragraphs": paragraphs_dict,
	}
	if default_typing_speed != null:
		d["default_typing_speed"] = default_typing_speed.to_dict()
	return d
