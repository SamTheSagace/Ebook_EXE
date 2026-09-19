extends Control

@onready var page_container: PageContainer = $PageContainer
@onready var mode_button: Button = $ModeButton

var _vitesse: VitesseEcriture

func _ready() -> void:
	_vitesse = VitesseEcriture.new()
	_vitesse.mode = VitesseEcriture.Mode.LETTRE
	_vitesse.valeur = 40.0

	var livre := Livre.new()
	livre.vitesse_ecriture_defaut = _vitesse

	var textes := [
		"Il faisait nuit sur la ville lorsque tout commença. Les rues étaient désertes, à l'exception d'un chat noir qui traversait lentement la place principale, indifférent au silence pesant qui régnait partout ailleurs.",
		"Rien ne laissait présager ce qui allait suivre. Un bruit, au loin, avait pourtant tout changé, un grondement sourd qui semblait monter des entrailles mêmes de la terre, faisant vibrer les vitres des maisons endormies.",
		"Le silence qui suivit fut plus long que tous les précédents réunis. Personne n'osait sortir, personne n'osait parler, comme si le moindre mot aurait pu réveiller quelque chose qu'il valait mieux laisser dormir encore un peu.",
		"Pourtant, quelque part dans cette ville, une lumière s'alluma. Une fenêtre, au dernier étage d'un immeuble oublié, laissa filtrer une lueur tremblante, signe que quelqu'un, malgré tout, refusait de céder à la peur ambiante.",
	]
	for i in textes.size():
		var p := Paragraphe.new()
		p.id = i + 1
		p.texte = textes[i]
		livre.paragraphes.append(p)

	page_container.demarrer_livre(livre)
	_mettre_a_jour_texte_bouton()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		page_container.avancer()

func _on_mode_button_pressed() -> void:
	if _vitesse.mode == VitesseEcriture.Mode.LETTRE:
		_vitesse.mode = VitesseEcriture.Mode.MOT
	else:
		_vitesse.mode = VitesseEcriture.Mode.LETTRE
	_mettre_a_jour_texte_bouton()

func _mettre_a_jour_texte_bouton() -> void:
	mode_button.text = "Mode : Mot" if _vitesse.mode == VitesseEcriture.Mode.MOT else "Mode : Lettre"
