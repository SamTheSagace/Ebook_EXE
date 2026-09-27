class_name TypingSpeed
extends Resource

enum Mode { LETTER, WORD }

@export var mode: Mode = Mode.LETTER
@export var value: float = 30.0
@export var chunk_size: int = 1   # letters revealed per step, used only in LETTER mode

static func from_dict(d: Dictionary) -> TypingSpeed:
	var s := TypingSpeed.new()
	if d.get("mode", "") == "word":
		s.mode = Mode.WORD
	s.value = d.get("value", s.value)
	s.chunk_size = d.get("chunk_size", s.chunk_size)
	return s

func to_dict() -> Dictionary:
	return {
		"mode": "word" if mode == Mode.WORD else "letter",
		"value": value,
		"chunk_size": chunk_size,
	}
