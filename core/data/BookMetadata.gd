class_name BookMetadata
extends Resource

@export var title: String = ""
@export var author: String = ""
@export var cover: String = ""

static func from_dict(d: Dictionary) -> BookMetadata:
	var m := BookMetadata.new()
	m.title = d.get("title", m.title)
	m.author = d.get("author", m.author)
	m.cover = d.get("cover", m.cover)
	return m

func to_dict() -> Dictionary:
	return {
		"title": title,
		"author": author,
		"cover": cover,
	}
