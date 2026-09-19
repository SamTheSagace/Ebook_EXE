class_name TypewriterLabel
extends RichTextLabel

signal termine

var _vitesse: VitesseEcriture
var _accum: float = 0.0
var _positions_mots: Array[int] = []
var _index_mot: int = 0
var _en_cours: bool = false

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	bbcode_enabled = false
	fit_content = true
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	visible_characters = 0
	set_process(false)

func preparer(texte: String, vitesse: VitesseEcriture) -> void:
	text = texte
	_vitesse = vitesse
	visible_characters = 0
	_index_mot = 0
	_positions_mots = _positions_fins_de_mots(texte)
	_en_cours = false

func demarrer() -> void:
	_en_cours = true
	_accum = 0.0
	set_process(true)

func terminer_instantanement() -> void:
	if visible_characters == -1:
		return
	visible_characters = -1
	_en_cours = false
	set_process(false)
	termine.emit()

func est_en_cours() -> bool:
	return _en_cours

func _process(delta: float) -> void:
	_accum += delta
	var intervalle := 1.0 / maxf(_vitesse.valeur, 0.01)
	while _accum >= intervalle and _en_cours:
		_accum -= intervalle
		_avancer()

func _avancer() -> void:
	if _vitesse.mode == VitesseEcriture.Mode.MOT:
		_index_mot += 1
		if _index_mot >= _positions_mots.size():
			terminer_instantanement()
		else:
			visible_characters = _positions_mots[_index_mot]
	else:
		visible_characters += maxi(_vitesse.taille_bloc, 1)
		if visible_characters >= text.length():
			terminer_instantanement()

func _positions_fins_de_mots(texte: String) -> Array[int]:
	var positions: Array[int] = []
	var regex := RegEx.new()
	regex.compile("\\S+")
	for m in regex.search_all(texte):
		positions.append(m.get_end())
	return positions
