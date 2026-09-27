class_name TypewriterLabel
extends RichTextLabel

signal finished

var _speed: TypingSpeed
var _accum: float = 0.0
var _word_end_positions: Array[int] = []
var _word_index: int = 0
var _running: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	bbcode_enabled = false
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	visible_characters = 0
	set_process(false)

func prepare(paragraph_text: String, speed: TypingSpeed) -> void:
	text = paragraph_text
	_speed = speed
	visible_characters = 0
	_word_index = 0
	_word_end_positions = _compute_word_end_positions(paragraph_text)
	_running = false

func start() -> void:
	_running = true
	_accum = 0.0
	set_process(true)

func complete_instantly() -> void:
	if visible_characters == -1:
		return
	visible_characters = -1
	_running = false
	set_process(false)
	finished.emit()

func is_running() -> bool:
	return _running

func _process(delta: float) -> void:
	_accum += delta
	var interval := 1.0 / maxf(_speed.value, 0.01)
	while _accum >= interval and _running:
		_accum -= interval
		_advance()

func _advance() -> void:
	if _speed.mode == TypingSpeed.Mode.WORD:
		_word_index += 1
		if _word_index >= _word_end_positions.size():
			complete_instantly()
		else:
			visible_characters = _word_end_positions[_word_index]
	else:
		visible_characters += maxi(_speed.chunk_size, 1)
		if visible_characters >= text.length():
			complete_instantly()

func _compute_word_end_positions(paragraph_text: String) -> Array[int]:
	var positions: Array[int] = []
	var regex := RegEx.new()
	regex.compile("\\S+")
	for m in regex.search_all(paragraph_text):
		positions.append(m.get_end())
	return positions
