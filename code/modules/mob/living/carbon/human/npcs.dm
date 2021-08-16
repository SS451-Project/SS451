/obj/item/clothing/under/punpun
	name = "нарядная униформа"
	desc = "Похоже, это было сшито специально для обезьяны."
	icon_state = "punpun"
	item_color = "punpun"
	species_restricted = list("Monkey")
	species_exception = list(/datum/species/monkey)

/mob/living/carbon/human/monkey/punpun/Initialize(mapload)
	. = ..()
	name = "Пун-Пун"
	real_name = name
	equip_to_slot(new /obj/item/clothing/under/punpun(src), slot_w_uniform)
