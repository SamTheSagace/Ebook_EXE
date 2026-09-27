extends Control

@onready var page_container: PageContainer = $PageContainer
@onready var mode_button: Button = $ModeButton

var _speed: TypingSpeed

func _ready() -> void:
	_speed = TypingSpeed.new()
	_speed.mode = TypingSpeed.Mode.LETTER
	_speed.value = 40.0

	var book := Book.new()
	book.default_typing_speed = _speed

	var texts := [
		"Il faisait nuit sur la ville lorsque tout commença. Les rues étaient désertes, à l'exception d'un chat noir qui traversait lentement la place principale, indifférent au silence pesant qui régnait partout ailleurs.",
		"Rien ne laissait présager ce qui allait suivre. Un bruit, au loin, avait pourtant tout changé, un grondement sourd qui semblait monter des entrailles mêmes de la terre, faisant vibrer les vitres des maisons endormies.",
		"Le silence qui suivit fut plus long que tous les précédents réunis. Personne n'osait sortir, personne n'osait parler, comme si le moindre mot aurait pu réveiller quelque chose qu'il valait mieux laisser dormir encore un peu.",
		"Pourtant, quelque part dans cette ville, une lumière s'alluma. Une fenêtre, au dernier étage d'un immeuble oublié, laissa filtrer une lueur tremblante, signe que quelqu'un, malgré tout, refusait de céder à la peur ambiante.",
	]
	for i in texts.size():
		var p := Paragraph.new()
		p.id = i + 1
		p.text = texts[i]
		book.paragraphs.append(p)

	page_container.start_book(book)
	_update_mode_button_text()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		page_container.advance()

func _on_mode_button_pressed() -> void:
	if _speed.mode == TypingSpeed.Mode.LETTER:
		_speed.mode = TypingSpeed.Mode.WORD
	else:
		_speed.mode = TypingSpeed.Mode.LETTER
	_update_mode_button_text()

func _update_mode_button_text() -> void:
	mode_button.text = "Mode: Word" if _speed.mode == TypingSpeed.Mode.WORD else "Mode: Letter"
