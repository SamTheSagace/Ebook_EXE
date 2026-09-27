class_name Paragraph
extends Resource

## text: paragraph body — or the chapter title itself when is_chapter_start is true

@export var id: int = 0
@export var text: String = ""
@export var is_chapter_start: bool = false
@export var title_animation: String = ""
@export var speed_override: TypingSpeed = null
@export var music_trigger: MusicTrigger = null

static func from_dict(d: Dictionary) -> Paragraph:
	var p := Paragraph.new()
	p.id = d.get("id", p.id)
	p.text = d.get("text", p.text)
	p.is_chapter_start = d.get("is_chapter_start", p.is_chapter_start)
	p.title_animation = d.get("title_animation", p.title_animation)
	var speed: Variant = d.get("speed_override", null)
	p.speed_override = TypingSpeed.from_dict(speed) if speed != null else null
	var music: Variant = d.get("music_trigger", null)
	p.music_trigger = MusicTrigger.from_dict(music) if music != null else null
	return p

func to_dict() -> Dictionary:
	var d := {
		"id": id,
		"text": text,
		"is_chapter_start": is_chapter_start,
		"title_animation": title_animation,
		"speed_override": null,
		"music_trigger": null,
	}
	if speed_override != null:
		d["speed_override"] = speed_override.to_dict()
	if music_trigger != null:
		d["music_trigger"] = music_trigger.to_dict()
	return d
