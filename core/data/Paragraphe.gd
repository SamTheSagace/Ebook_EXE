class_name Paragraphe
extends Resource

## texte : corps du paragraphe, ou titre du chapitre si est_debut_chapitre == true

@export var id: int = 0
@export var texte: String = ""
@export var est_debut_chapitre: bool = false
@export var animation_titre: String = ""
@export var vitesse_override: VitesseEcriture = null
@export var musique_trigger: MusiqueTrigger = null

static func from_dict(d: Dictionary) -> Paragraphe:
	var p := Paragraphe.new()
	p.id = d.get("id", p.id)
	p.texte = d.get("texte", p.texte)
	p.est_debut_chapitre = d.get("est_debut_chapitre", p.est_debut_chapitre)
	p.animation_titre = d.get("animation_titre", p.animation_titre)
	var vitesse: Variant = d.get("vitesse_override", null)
	p.vitesse_override = VitesseEcriture.from_dict(vitesse) if vitesse != null else null
	var musique: Variant = d.get("musique_trigger", null)
	p.musique_trigger = MusiqueTrigger.from_dict(musique) if musique != null else null
	return p

func to_dict() -> Dictionary:
	var d := {
		"id": id,
		"texte": texte,
		"est_debut_chapitre": est_debut_chapitre,
		"animation_titre": animation_titre,
		"vitesse_override": null,
		"musique_trigger": null,
	}
	if vitesse_override != null:
		d["vitesse_override"] = vitesse_override.to_dict()
	if musique_trigger != null:
		d["musique_trigger"] = musique_trigger.to_dict()
	return d
