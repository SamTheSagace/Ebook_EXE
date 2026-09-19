class_name VitesseEcriture
extends Resource

enum Mode { LETTRE, MOT }

@export var mode: Mode = Mode.LETTRE
@export var valeur: float = 60.0 
@export var taille_bloc: int = 3 # nombre de lettres révélées par cran, utilisé seulement en mode LETTRE

static func from_dict(d: Dictionary) -> VitesseEcriture:
	var v := VitesseEcriture.new()
	if d.get("mode", "") == "mot":
		v.mode = Mode.MOT
	v.valeur = d.get("valeur", v.valeur)
	v.taille_bloc = d.get("taille_bloc", v.taille_bloc)
	return v

func to_dict() -> Dictionary:
	return {
		"mode": "mot" if mode == Mode.MOT else "lettre",
		"valeur": valeur,
		"taille_bloc": taille_bloc,
	}
