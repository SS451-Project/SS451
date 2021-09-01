// Basic lighters
/obj/item/lighter
	name = "Дешевая зажигалка"
	desc = "Дешевая, почти как бесплатная."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = null
	resistance_flags = FIRE_PROOF
	var/lit = FALSE
	var/icon_on = "lighter-g-on"
	var/icon_off = "lighter-g"

/obj/item/lighter/random/New()
	..()
	var/color = pick("r","c","y","g")
	icon_on = "lighter-[color]-on"
	icon_off = "lighter-[color]"
	icon_state = icon_off

/obj/item/lighter/attack_self(mob/living/user)
	. = ..()
	if(!lit)
		turn_on_lighter(user)
	else
		turn_off_lighter(user)

/obj/item/lighter/proc/turn_on_lighter(mob/living/user)
	lit = TRUE
	w_class = WEIGHT_CLASS_BULKY
	icon_state = icon_on
	item_state = icon_on
	force = 5
	damtype = BURN
	hitsound = 'sound/items/welder.ogg'
	attack_verb = list("обжёг", "опалил")

	attempt_light(user)
	set_light(2)
	START_PROCESSING(SSobj, src)

/obj/item/lighter/proc/attempt_light(mob/living/user)
	if(prob(75) || issilicon(user)) // Robots can never burn themselves trying to light it.
		to_chat(user, "<span class='notice'>Ты зажёг [src].</span>")
	else
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ("[user.hand ? "l" : "r" ]_hand")
		if(affecting.receive_damage( 0, 5 ))		//INFERNO
			H.UpdateDamageIcon()
		to_chat(user,"<span class='notice'>Ты зжаёг [src], но при этом ты обжигаешь себе руку.</span>")

/obj/item/lighter/proc/turn_off_lighter(mob/living/user)
	lit = FALSE
	w_class = WEIGHT_CLASS_TINY
	icon_state = icon_off
	item_state = icon_off
	hitsound = "swing_hit"
	force = 0
	attack_verb = null //human_defense.dm takes care of it

	show_off_message(user)
	set_light(0)
	STOP_PROCESSING(SSobj, src)

/obj/item/lighter/proc/show_off_message(mob/living/user)
	to_chat(user, "<span class='notice'>Ты потушил [src].")

/obj/item/lighter/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!isliving(M))
		return
	M.IgniteMob()
	if(!istype(M, /mob))
		return

	if(istype(M.wear_mask, /obj/item/clothing/mask/cigarette) && user.zone_selected == "mouth" && lit)
		var/obj/item/clothing/mask/cigarette/cig = M.wear_mask
		if(M == user)
			cig.attackby(src, user)
		else
			if(istype(src, /obj/item/lighter/zippo))
				cig.light("<span class='rose'>[user] выхватывает [name] и держит его для [M]. Рука [user.p_their(TRUE)] так же тверда, как мерцающее пламя [user.p_they()] light[user.p_s()], подкуривающее [cig].</span>")
			else
				cig.light("<span class='notice'>[user] удерживает [name] для [M], и поджигает [cig.name].</span>")
			M.update_inv_wear_mask()
	else
		..()

/obj/item/lighter/process()
	var/turf/location = get_turf(src)
	if(location)
		location.hotspot_expose(700, 5)
	return

// Zippo lighters
/obj/item/lighter/zippo
	name = "Зажигалка Zippo"
	desc = "Zippo."
	icon_state = "zippo"
	item_state = "zippo"
	icon_on = "zippoon"
	icon_off = "zippo"
	var/next_on_message
	var/next_off_message

/obj/item/lighter/zippo/turn_on_lighter(mob/living/user)
	. = ..()
	if(world.time > next_on_message)
		user.visible_message("<span class='rose'>Не сбавляя темп, [user] открывает и зажигает [src] одним плавным движением.</span>")
		playsound(src.loc, 'sound/items/zippolight.ogg', 25, 1)
		next_on_message = world.time + 5 SECONDS
	else
		to_chat(user, "<span class='notice'>Ты зажёг [src].</span>")

/obj/item/lighter/zippo/turn_off_lighter(mob/living/user)
	. = ..()
	if(world.time > next_off_message)
		user.visible_message("<span class='rose'>Вы слышите тихий щелчок, когда [user] закрывает [src] даже не глядя на то, что делает. Вау.")
		playsound(src.loc, 'sound/items/zippoclose.ogg', 25, 1)
		next_off_message = world.time + 5 SECONDS
	else
		to_chat(user, "<span class='notice'>Ты потушил [src].")

/obj/item/lighter/zippo/show_off_message(mob/living/user)
	return

/obj/item/lighter/zippo/attempt_light(mob/living/user)
	return

//EXTRA LIGHTERS
/obj/item/lighter/zippo/nt_rep
	name = "Zippo с золотой гравировкой"
	desc = "Золотая зажигалка Zippo с гравировкой и буквами NT на ней."
	icon_state = "zippo_nt_off"
	icon_on = "zippo_nt_on"
	icon_off = "zippo_nt_off"

/obj/item/lighter/zippo/blue
	name = "Синяя зажигалка zippo"
	desc = "Зажигалка zippo из какого-то синего металла."
	icon_state = "bluezippo"
	icon_on = "bluezippoon"
	icon_off = "bluezippo"

/obj/item/lighter/zippo/black
	name = "Черная зажигалка Zippo"
	desc = "Черная зажигалка Zippo."
	icon_state = "blackzippo"
	icon_on = "blackzippoon"
	icon_off = "blackzippo"

/obj/item/lighter/zippo/engraved
	name = "Зажигалка Zippo с гравировкой"
	desc = "Зажигалка Zippo с замысловатой гравировкой."
	icon_state = "engravedzippo"
	icon_on = "engravedzippoon"
	icon_off = "engravedzippo"

/obj/item/lighter/zippo/gonzofist
	name = "Zippo Кулака Гонзо"
	desc = "Зажигалка Zippo с культовым кулаком Гонзо на матовой черной отделке."
	icon_state = "gonzozippo"
	icon_on = "gonzozippoon"
	icon_off = "gonzozippo"

/obj/item/lighter/zippo/cap
	name = "Zippo Капитана"
	desc = "Золотой Zippo с ограниченным тиражом, специально для капитанов NT. Выглядит очень дорого."
	icon_state = "zippo_cap"
	icon_on = "zippo_cap_on"
	icon_off = "zippo_cap"

/obj/item/lighter/zippo/hop
	name = "Zippo Главы Персонала"
	desc = "Ограниченная серия Zippo для глав NT. Старается изо всех сил выглядеть как у капитана."
	icon_state = "zippo_hop"
	icon_on = "zippo_hop_on"
	icon_off = "zippo_hop"

/obj/item/lighter/zippo/hos
	name = "Zippo Начальника Службы Безопасности"
	desc = "Ограниченная серия Zippo для глав NT. Заправлен слезами клоунов."
	icon_state = "zippo_hos"
	icon_on = "zippo_hos_on"
	icon_off = "zippo_hos"

/obj/item/lighter/zippo/cmo
	name = "Zippo Главного Врача"
	desc = "Ограниченная серия Zippo для глав NT. Изготовлен из гипоаллергенной стали."
	icon_state = "zippo_cmo"
	icon_on = "zippo_cmo_on"
	icon_off = "zippo_cmo"

/obj/item/lighter/zippo/ce
	name = "Zippo Главного Инженера"
	desc = "Ограниченная серия Zippo для глав NT. Кто-то пытался починить крышку синей изолентой."
	icon_state = "zippo_ce"
	icon_on = "zippo_ce_on"
	icon_off = "zippo_ce"

/obj/item/lighter/zippo/rd
	name = "Zippo Директора по Исследованиям"
	desc = "Ограниченная серия Zippo для глав NT. Использует передовые технологии для создания огня из плазмы."
	icon_state = "zippo_rd"
	icon_on = "zippo_rd_on"
	icon_off = "zippo_rd"

///////////
//MATCHES//
///////////
/obj/item/match
	name = "Спичка"
	desc = "Простая спичка, используемая для подкуривания."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/lit = FALSE
	var/burnt = FALSE
	var/smoketime = 5
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1"
	attack_verb = null

/obj/item/match/process()
	var/turf/location = get_turf(src)
	smoketime--
	if(smoketime < 1)
		matchburnout()
	if(location)
		location.hotspot_expose(700, 5)
		return

/obj/item/match/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume, global_overlay = TRUE)
	..()
	matchignite()

/obj/item/match/proc/matchignite()
	if(!lit && !burnt)
		lit = TRUE
		icon_state = "match_lit"
		damtype = "fire"
		force = 3
		hitsound = 'sound/items/welder.ogg'
		item_state = "cigon"
		name = "Зажженная спичка"
		desc = "Спичка. И она горит."
		attack_verb = list("обжёг", "опалил")
		START_PROCESSING(SSobj, src)
		update_icon()
		return TRUE

/obj/item/match/proc/matchburnout()
	if(lit)
		lit = FALSE
		burnt = TRUE
		damtype = "brute"
		force = initial(force)
		icon_state = "match_burnt"
		item_state = "cigoff"
		name = "Сгоревшая спичка"
		desc = "Спичка. Отжигала свои лучшие дни."
		attack_verb = list("щёлкнул")
		STOP_PROCESSING(SSobj, src)
		return TRUE

/obj/item/match/dropped(mob/user)
	matchburnout()
	. = ..()

/obj/item/match/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!isliving(M))
		return ..()
	if(lit && M.IgniteMob())
		message_admins("[key_name_admin(user)] set [key_name_admin(M)] on fire")
		log_game("[key_name(user)] set [key_name(M)] on fire")
	var/obj/item/clothing/mask/cigarette/cig = help_light_cig(M)
	if(lit && cig && user.a_intent == INTENT_HELP)
		if(cig.lit)
			to_chat(user, "<span class='notice'>[cig] уже подкурена.</span>")
		if(M == user)
			cig.attackby(src, user)
		else
			cig.light("<span class='notice'>[user] держит [src] над [M], и покуривает [cig].</span>")
	else
		..()

/obj/item/match/decompile_act(obj/item/matter_decompiler/C, mob/user)
	if(burnt)
		C.stored_comms["wood"] += 1
		qdel(src)
		return TRUE
	return ..()

/obj/item/proc/help_light_cig(mob/living/M)
	var/mask_item = M.get_item_by_slot(slot_wear_mask)
	if(istype(mask_item, /obj/item/clothing/mask/cigarette))
		return mask_item

/obj/item/match/firebrand
	name = "Головешка"
	desc = "Незажженная головешка. Заставляет задуматься, почему это не просто палка."
	smoketime = 20 //40 seconds

/obj/item/match/firebrand/New()
	..()
	matchignite()
