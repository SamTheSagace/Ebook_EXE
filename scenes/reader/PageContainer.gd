class_name PageContainer
extends VBoxContainer

## Un paragraphe fixe sa place sur la page en fonction de sa hauteur
## RÉELLE une fois entièrement écrit, mesurée AVANT de démarrer l'animation
## (sinon un paragraphe en cours d'écriture peut sembler tenir puis déborder).

signal paragraphe_affiche(paragraphe: Paragraphe)
signal chapitre_titre(paragraphe: Paragraphe)

var livre: Livre
var index_courant: int = -1

var _label_en_cours: TypewriterLabel

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func demarrer_livre(nouveau_livre: Livre) -> void:
	livre = nouveau_livre
	index_courant = -1
	_vider_page()

func avancer() -> void:
	if _label_en_cours != null and _label_en_cours.est_en_cours():
		_label_en_cours.terminer_instantanement()
		return
	index_courant += 1
	if index_courant >= livre.paragraphes.size():
		return
	var paragraphe: Paragraphe = livre.paragraphes[index_courant]
	if paragraphe.est_debut_chapitre:
		_vider_page()
		chapitre_titre.emit(paragraphe)
		return
	_ajouter_paragraphe(paragraphe)

func _ajouter_paragraphe(paragraphe: Paragraphe) -> void:
	var label := TypewriterLabel.new()
	add_child(label)
	var vitesse: VitesseEcriture = paragraphe.vitesse_override if paragraphe.vitesse_override != null else livre.vitesse_ecriture_defaut
	label.preparer(paragraphe.texte, vitesse)
	await get_tree().process_frame

	var predecesseurs := get_children().filter(func(c): return c != label)
	if not predecesseurs.is_empty():
		var hauteur_utilisee: float = predecesseurs.size() * get_theme_constant("separation")
		for enfant in predecesseurs:
			hauteur_utilisee += enfant.size.y
		if hauteur_utilisee + label.get_content_height() > size.y:
			for enfant in predecesseurs:
				enfant.queue_free()

	label.demarrer()
	_label_en_cours = label
	paragraphe_affiche.emit(paragraphe)

func _vider_page() -> void:
	for enfant in get_children():
		enfant.queue_free()
	_label_en_cours = null
