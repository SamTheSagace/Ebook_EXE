class_name Livre
extends Resource

const FORMAT_VERSION := 1

@export var format_version: int = FORMAT_VERSION
@export var autoriser_skip: bool = true
@export var vitesse_ecriture_defaut: VitesseEcriture
@export var paragraphes: Array[Paragraphe] = []

static func from_dict(d: Dictionary) -> Livre:
	var l := Livre.new()
	l.format_version = d.get("format_version", l.format_version)
	l.autoriser_skip = d.get("autoriser_skip", l.autoriser_skip)
	l.vitesse_ecriture_defaut = VitesseEcriture.from_dict(d.get("vitesse_ecriture_defaut", {}))
	for p in d.get("paragraphes", []):
		l.paragraphes.append(Paragraphe.from_dict(p))
	return l

func to_dict() -> Dictionary:
	var paragraphes_dict: Array = []
	for p in paragraphes:
		paragraphes_dict.append(p.to_dict())
	var d := {
		"format_version": format_version,
		"autoriser_skip": autoriser_skip,
		"vitesse_ecriture_defaut": null,
		"paragraphes": paragraphes_dict,
	}
	if vitesse_ecriture_defaut != null:
		d["vitesse_ecriture_defaut"] = vitesse_ecriture_defaut.to_dict()
	return d
