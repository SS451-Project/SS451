/obj/item/organ/internal/liver/skrell
	species_type = /datum/species/skrell
	name = "печень скрелла"
	icon = 'icons/obj/species_organs/skrell.dmi'
	alcohol_intensity = 4

/obj/item/organ/internal/headpocket
	species_type = /datum/species/skrell
	name = "головной карман"
	desc = "Позволяет Скреллу прятать крошечные предметы в своих головных щупальцах."
	icon = 'icons/obj/species_organs/skrell.dmi'
	icon_state = "skrell_headpocket"
	origin_tech = "biotech=2"
	w_class = WEIGHT_CLASS_TINY
	parent_organ = "head"
	slot = "headpocket"
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	var/obj/item/storage/internal/pocket

/obj/item/organ/internal/headpocket/New()
	..()
	pocket = new /obj/item/storage/internal(src)
	pocket.storage_slots = 1
	// Allow adjacency calculation to work properly
	loc = owner
	// Fit only pocket sized items
	pocket.max_w_class = WEIGHT_CLASS_SMALL
	pocket.max_combined_w_class = 2

/obj/item/organ/internal/headpocket/on_life()
	..()
	var/obj/item/organ/external/head/head = owner.get_organ("head")
	if(pocket.contents.len && !findtextEx(head.h_style, "Щупальца"))
		owner.visible_message("<span class='notice'>Что-то падает с головы [owner]!</span>",
													"<span class='notice'>Что-то выпало из твоей головы!</span>")
		empty_contents()

/obj/item/organ/internal/headpocket/ui_action_click()
	if(!loc)
		loc = owner
	pocket.MouseDrop(owner)

/obj/item/organ/internal/headpocket/on_owner_death()
	empty_contents()

/obj/item/organ/internal/headpocket/remove(mob/living/carbon/M, special = 0)
	empty_contents()
	. = ..()

/obj/item/organ/internal/headpocket/proc/empty_contents()
	for(var/obj/item/I in pocket.contents)
		pocket.remove_from_storage(I, get_turf(owner))

/obj/item/organ/internal/headpocket/proc/get_contents()
	return pocket.contents

/obj/item/organ/internal/headpocket/emp_act(severity)
	pocket.emp_act(severity)
	..()

/obj/item/organ/internal/headpocket/hear_talk(mob/living/M as mob, list/message_pieces)
	pocket.hear_talk(M, message_pieces)
	..()

/obj/item/organ/internal/headpocket/hear_message(mob/living/M as mob, msg)
	pocket.hear_message(M, msg)
	..()

/obj/item/organ/internal/heart/skrell
	species_type = /datum/species/skrell
	name = "сердце скрелла"
	desc = "Обтекаемое кровью сердце."
	icon = 'icons/obj/species_organs/skrell.dmi'

/obj/item/organ/internal/brain/skrell
	species_type = /datum/species/skrell
	icon = 'icons/obj/species_organs/skrell.dmi'
	desc = "Мозг со странным делением посередине."
	icon_state = "brain2"
	mmi_icon = 'icons/obj/species_organs/skrell.dmi'
	mmi_icon_state = "mmi_full"

/obj/item/organ/internal/lungs/skrell
	species_type = /datum/species/skrell
	name = "легкие скрелла"
	icon = 'icons/obj/species_organs/skrell.dmi'

/obj/item/organ/internal/kidneys/skrell
	species_type = /datum/species/skrell
	name = "почки скрелла"
	icon = 'icons/obj/species_organs/skrell.dmi'
	desc = "Самые маленькие почки, которые ты когда-либо видели, вероятно, даже не работают."

/obj/item/organ/internal/eyes/skrell
	species_type = /datum/species/skrell
	name = "глазные яблоки скрелла"
	icon = 'icons/obj/species_organs/skrell.dmi'
