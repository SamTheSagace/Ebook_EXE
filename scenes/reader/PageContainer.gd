class_name PageContainer
extends VBoxContainer

## A paragraph's place on the page is decided by its REAL height once fully
## typed, measured BEFORE the reveal animation starts (otherwise a paragraph
## mid-animation could look like it fits and then overflow).

signal paragraph_displayed(paragraph: Paragraph)
signal chapter_title(paragraph: Paragraph)

var book: Book
var current_index: int = -1

var _current_label: TypewriterLabel

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func start_book(new_book: Book) -> void:
	book = new_book
	current_index = -1
	_clear_page()

func advance() -> void:
	if _current_label != null and _current_label.is_running():
		_current_label.complete_instantly()
		return
	current_index += 1
	if current_index >= book.paragraphs.size():
		return
	var paragraph: Paragraph = book.paragraphs[current_index]
	if paragraph.is_chapter_start:
		_clear_page()
		chapter_title.emit(paragraph)
		return
	_add_paragraph(paragraph)

func _add_paragraph(paragraph: Paragraph) -> void:
	var label := TypewriterLabel.new()
	add_child(label)
	var speed: TypingSpeed = paragraph.speed_override if paragraph.speed_override != null else book.default_typing_speed
	label.prepare(paragraph.text, speed)
	await get_tree().process_frame

	var previous_children := get_children().filter(func(c): return c != label)
	if not previous_children.is_empty():
		var used_height: float = previous_children.size() * get_theme_constant("separation")
		for child in previous_children:
			used_height += child.size.y
		if used_height + label.get_content_height() > size.y:
			for child in previous_children:
				child.queue_free()

	label.start()
	_current_label = label
	paragraph_displayed.emit(paragraph)

func _clear_page() -> void:
	for child in get_children():
		child.queue_free()
	_current_label = null
