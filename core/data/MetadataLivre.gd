class_name MetadataLivre
extends Resource

@export var titre: String = ""
@export var auteur: String = ""
@export var couverture: String = ""

static func from_dict(d: Dictionary) -> MetadataLivre:
	var m := MetadataLivre.new()
	m.titre = d.get("titre", m.titre)
	m.auteur = d.get("auteur", m.auteur)
	m.couverture = d.get("couverture", m.couverture)
	return m

func to_dict() -> Dictionary:
	return {
		"titre": titre,
		"auteur": auteur,
		"couverture": couverture,
	}
