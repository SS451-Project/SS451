GLOBAL_LIST_EMPTY(all_objectives)

GLOBAL_LIST_INIT(potential_theft_objectives, (subtypesof(/datum/theft_objective) - /datum/theft_objective/steal - /datum/theft_objective/number - /datum/theft_objective/unique))

/datum/objective
	var/datum/mind/owner = null			//Who owns the objective.
	var/explanation_text = "Nothing"	//What that person is supposed to do.
	var/datum/mind/target = null		//If they are focused on a particular person.
	var/target_amount = 0				//If they are focused on a particular number. Steal objectives have their own counter.
	var/completed = 0					//currently only used for custom objectives.
	var/martyr_compatible = 0			//If the objective is compatible with martyr objective, i.e. if you can still do it while dead.

/datum/objective/New(text)
	GLOB.all_objectives += src
	if(text)
		explanation_text = text

/datum/objective/Destroy()
	GLOB.all_objectives -= src
	return ..()

/datum/objective/proc/check_completion()
	return completed

/datum/objective/proc/is_invalid_target(datum/mind/possible_target)
	if(possible_target == owner)
		return TARGET_INVALID_IS_OWNER
	if(possible_target in owner.targets)
		return TARGET_INVALID_IS_TARGET
	if(!ishuman(possible_target.current))
		return TARGET_INVALID_NOT_HUMAN
	if(possible_target.current.stat == DEAD)
		return TARGET_INVALID_DEAD
	if(!possible_target.key)
		return TARGET_INVALID_NOCKEY
	if(possible_target.current)
		var/turf/current_location = get_turf(possible_target.current)
		if(current_location && !is_level_reachable(current_location.z))
			return TARGET_INVALID_UNREACHABLE
	if(isgolem(possible_target.current))
		return TARGET_INVALID_GOLEM
	if(possible_target.offstation_role)
		return TARGET_INVALID_EVENT


/datum/objective/proc/find_target()
	var/list/possible_targets = list()
	for(var/datum/mind/possible_target in SSticker.minds)
		if(is_invalid_target(possible_target))
			continue

		possible_targets += possible_target

	if(possible_targets.len > 0)
		target = pick(possible_targets)

/**
  * Called when the objective's target goes to cryo.
  */
/datum/objective/proc/on_target_cryo()
	if(owner?.current)
		to_chat(owner.current, "<BR><span class='userdanger'>У вас возникает ощущение, что ваша цель больше не находится в пределах досягаемости. Время для плана [pick("A","B","C","D","X","Y","Z")]. Цели обновлены!</span>")
		SEND_SOUND(owner.current, 'sound/ambience/alarm4.ogg')
	target = null
	INVOKE_ASYNC(src, .proc/post_target_cryo)

/**
  * Called a tick after when the objective's target goes to cryo.
  */
/datum/objective/proc/post_target_cryo()
	find_target()
	if(!target)
		GLOB.all_objectives -= src
		owner?.objectives -= src
		qdel(src)
	owner?.announce_objectives()

/datum/objective/assassinate
	martyr_compatible = 1

/datum/objective/assassinate/find_target()
	..()
	if(target && target.current)
		explanation_text = "Незаметно убить [target.current.real_name] - [target.assigned_role]."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/assassinate/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD)
			return 1
		if(issilicon(target.current) || isbrain(target.current)) //Borgs/brains/AIs count as dead for traitor objectives. --NeoFite
			return 1
		if(!target.current.ckey)
			return 1
		return 0
	return 1


/datum/objective/mutiny
	martyr_compatible = 1

/datum/objective/mutiny/find_target()
	..()
	if(target && target.current)
		explanation_text = "Незаметно убить [target.current.real_name] - [target.assigned_role]."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/mutiny/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || !ishuman(target.current) || !target.current.ckey || !target.current.client)
			return 1
		var/turf/T = get_turf(target.current)
		if(T && !is_station_level(T.z))			//If they leave the station they count as dead for this
			return 1
		return 0
	return 1

/datum/objective/mutiny/on_target_cryo()
	// We don't want revs to get objectives that aren't for heads of staff. Letting
	// them win or lose based on cryo is silly so we remove the objective.
	qdel(src)

/datum/objective/maroon
	martyr_compatible = 1

/datum/objective/maroon/find_target()
	..()
	if(target && target.current)
		explanation_text = "Prevent [target.current.real_name], the [target.assigned_role] from escaping alive."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/maroon/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD)
			return 1
		if(!target.current.ckey)
			return 1
		if(issilicon(target.current))
			return 1
		if(isbrain(target.current))
			return 1
		var/turf/T = get_turf(target.current)
		if(is_admin_level(T.z))
			return 0
		return 1
	return 1


/datum/objective/debrain //I want braaaainssss
	martyr_compatible = 0

/datum/objective/debrain/find_target()
	..()
	if(target && target.current)
		explanation_text = "Украсть мозг [target.current.real_name] - [target.assigned_role]."
	else
		explanation_text = "Free Objective."
	return target


/datum/objective/debrain/check_completion()
	if(!target)//If it's a free objective.
		return 1
	if(!owner.current || owner.current.stat == DEAD)
		return 0
	if(!target.current || !isbrain(target.current))
		return 0
	var/atom/A = target.current
	while(A.loc)			//check to see if the brainmob is on our person
		A = A.loc
		if(A == owner.current)
			return 1
	return 0


/datum/objective/protect //The opposite of killing a dude.
	martyr_compatible = 1

/datum/objective/protect/find_target()
	..()
	if(target && target.current)
		explanation_text = "Защитить [target.current.real_name] - [target.assigned_role]."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/protect/check_completion()
	if(!target) //If it's a free objective.
		return 1
	if(target.current)
		if(target.current.stat == DEAD)
			return 0
		if(issilicon(target.current))
			return 0
		if(isbrain(target.current))
			return 0
		return 1
	return 0

/datum/objective/protect/mindslave //subytpe for mindslave implants


/datum/objective/hijack
	martyr_compatible = 0 //Technically you won't get both anyway.
	explanation_text = "Захватите шаттл, сбежав на нем без лоялистов экипажа Nanotrasen на борту и быть свободным. \
	Агенты синдиката, другие враги Nanotrasen, киборги, домашние животные и заложники в наручниках могут быть допущены на шаттл живыми."

/datum/objective/hijack/check_completion()
	if(!owner.current || owner.current.stat)
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	if(issilicon(owner.current))
		return 0

	var/area/A = get_area(owner.current)
	if(SSshuttle.emergency.areaInstance != A)
		return 0

	return SSshuttle.emergency.is_hijacked()

/datum/objective/hijackclone
	explanation_text = "Захватите шаттл, обеспечив побег только вам (или вашим копиям)."
	martyr_compatible = 0

/datum/objective/hijackclone/check_completion()
	if(!owner.current)
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0

	var/area/A = SSshuttle.emergency.areaInstance

	for(var/mob/living/player in GLOB.player_list) //Make sure nobody else is onboard
		if(player.mind && player.mind != owner)
			if(player.stat != DEAD)
				if(issilicon(player))
					continue
				if(get_area(player) == A)
					if(player.real_name != owner.current.real_name && !istype(get_turf(player.mind.current), /turf/simulated/shuttle/floor4))
						return 0

	for(var/mob/living/player in GLOB.player_list) //Make sure at least one of you is onboard
		if(player.mind && player.mind != owner)
			if(player.stat != DEAD)
				if(issilicon(player))
					continue
				if(get_area(player) == A)
					if(player.real_name == owner.current.real_name && !istype(get_turf(player.mind.current), /turf/simulated/shuttle/floor4))
						return 1
	return 0

/datum/objective/block
	explanation_text = "Не позволяйте никаким формам жизни, будь-то органические или синтетические, сбежать на шаттле живыми. ИИ, киборги, беспилотные летательные аппараты технического обслуживания и пИИ не считаются живыми."
	martyr_compatible = 1

/datum/objective/block/check_completion()
	if(!istype(owner.current, /mob/living/silicon))
		return 0
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	if(!owner.current)
		return 0

	var/area/A = SSshuttle.emergency.areaInstance

	for(var/mob/living/player in GLOB.player_list)
		if(issilicon(player))
			continue // If they're silicon, they're not considered alive, skip them.

		if(player.mind && player.stat != DEAD)
			if(get_area(player) == A)
				return 0 // If there are any other organic mobs on the shuttle, you failed the objective.

	return 1

/datum/objective/escape
	explanation_text = "Побег на шаттле или спасательной капсуле живым и свободным."

/datum/objective/escape/check_completion()
	if(issilicon(owner.current))
		return 0
	if(isbrain(owner.current))
		return 0
	if(!owner.current || owner.current.stat == DEAD)
		return 0
	if(SSticker.force_ending) //This one isn't their fault, so lets just assume good faith
		return 1
	if(SSticker.mode.station_was_nuked) //If they escaped the blast somehow, let them win
		return 1
	if(SSshuttle.emergency.mode < SHUTTLE_ENDGAME)
		return 0
	var/turf/location = get_turf(owner.current)
	if(!location)
		return 0

	if(istype(location, /turf/simulated/shuttle/floor4) || istype(location, /turf/simulated/floor/mineral/plastitanium/red/brig)) // Fails traitors if they are in the shuttle brig -- Polymorph
		return 0

	if(location.onCentcom() || location.onSyndieBase())
		return 1

	return 0


/datum/objective/escape/escape_with_identity
	var/target_real_name // Has to be stored because the target's real_name can change over the course of the round

/datum/objective/escape/escape_with_identity/find_target()
	var/list/possible_targets = list() //Copypasta because NO_DNA races, yay for snowflakes.
	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && possible_target.current.client)
			var/mob/living/carbon/human/H = possible_target.current
			if(!(NO_DNA in H.dna.species.species_traits))
				possible_targets += possible_target
	if(possible_targets.len > 0)
		target = pick(possible_targets)
	if(target && target.current)
		target_real_name = target.current.real_name
		explanation_text = "Побег на шаттле или спасательной капсуле с ID-картой [target_real_name], [target.assigned_role] при ношении ID-карты [target.p_their()]."
	else
		explanation_text = "Free Objective."

/datum/objective/escape/escape_with_identity/check_completion()
	if(!target_real_name)
		return 1
	if(!ishuman(owner.current))
		return 0
	var/mob/living/carbon/human/H = owner.current
	if(..())
		if(H.dna.real_name == target_real_name)
			if(H.get_id_name()== target_real_name)
				return 1
	return 0

/datum/objective/die
	explanation_text = "Умереть достойной смертью."

/datum/objective/die/check_completion()
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return 1
	if(issilicon(owner.current) && owner.current != owner.original)
		return 1
	return 0



/datum/objective/survive
	explanation_text = "Останься в живых до конца."

/datum/objective/survive/check_completion()
	if(!owner.current || owner.current.stat == DEAD || isbrain(owner.current))
		return 0		//Brains no longer win survive objectives. --NEO
	if(issilicon(owner.current) && owner.current != owner.original)
		return 0
	return 1

/datum/objective/nuclear
	explanation_text = "Уничтожьте станцию с помощью Ядерного Устройства."
	martyr_compatible = 1

/datum/objective/steal
	var/datum/theft_objective/steal_target
	martyr_compatible = 0
	var/theft_area

/datum/objective/steal/proc/get_location()
	if(steal_target.location_override)
		return steal_target.location_override
	var/list/obj/item/steal_candidates = get_all_of_type(steal_target.typepath, subtypes = TRUE)
	for(var/obj/item/candidate in steal_candidates)
		if(!is_admin_level(candidate.loc.z))
			theft_area = get_area(candidate.loc)
			return "[theft_area]"
	return "an unknown area"

/datum/objective/steal/find_target()
	var/loop=50
	while(!steal_target && loop > 0)
		loop--
		var/thefttype = pick(GLOB.potential_theft_objectives)
		var/datum/theft_objective/O = new thefttype
		if(owner.assigned_role in O.protected_jobs)
			continue
		if(O in owner.targets)
			continue
		if(O.flags & 2)
			continue
		steal_target = O

		explanation_text = "Украдите [steal_target]. Один такой в последний раз видели в [get_location()]. "
		if(islist(O.protected_jobs) && O.protected_jobs.len)
			explanation_text += "Он также может находиться во владении [jointext(O.protected_jobs, ", ")]."
		return
	explanation_text = "Free Objective.."


/datum/objective/steal/proc/select_target()
	var/list/possible_items_all = GLOB.potential_theft_objectives+"custom"
	var/new_target = input("Выбрать цель:", "Цель", null) as null|anything in possible_items_all
	if(!new_target) return
	if(new_target == "custom")
		var/datum/theft_objective/O=new
		O.typepath = input("Выбрать тип:","Тип") as null|anything in typesof(/obj/item)
		if(!O.typepath) return
		var/tmp_obj = new O.typepath
		var/custom_name = tmp_obj:name
		qdel(tmp_obj)
		O.name = sanitize(copytext_char(input("Введите имя цели:", "Цель", custom_name) as text|null,1,MAX_NAME_LEN))
		if(!O.name) return
		steal_target = O
		explanation_text = "Украсть [O.name]."
	else
		steal_target = new new_target
		explanation_text = "Украсть [steal_target.name]."
	return steal_target

/datum/objective/steal/check_completion()
	if(!steal_target)
		return 1 // Free Objective.

	if(!owner.current)
		return FALSE

	var/list/all_items = owner.current.GetAllContents()

	for(var/obj/I in all_items)
		if(istype(I, steal_target.typepath))
			return steal_target.check_special_completion(I)
		if(I.type in steal_target.altitems)
			return steal_target.check_special_completion(I)


/datum/objective/steal/exchange
	martyr_compatible = 0

/datum/objective/steal/exchange/proc/set_faction(var/faction,var/otheragent)
	target = otheragent
	var/datum/theft_objective/unique/targetinfo
	if(faction == "red")
		targetinfo = new /datum/theft_objective/unique/docs_blue
	else if(faction == "blue")
		targetinfo = new /datum/theft_objective/unique/docs_red
	explanation_text = "Получите [targetinfo.name] удерживаемого [target.current.real_name] - [target.assigned_role] и Агент Синдиката"
	steal_target = targetinfo

/datum/objective/steal/exchange/backstab
/datum/objective/steal/exchange/backstab/set_faction(var/faction)
	var/datum/theft_objective/unique/targetinfo
	if(faction == "red")
		targetinfo = new /datum/theft_objective/unique/docs_red
	else if(faction == "blue")
		targetinfo = new /datum/theft_objective/unique/docs_blue
	explanation_text = "Не сдавайтесь и не потеряйте [targetinfo.name]."
	steal_target = targetinfo

/datum/objective/download
/datum/objective/download/proc/gen_amount_goal()
	target_amount = rand(10,20)
	explanation_text = "Скачайте [target_amount] уровни исследований."
	return target_amount


/datum/objective/download/check_completion()
	return 0



/datum/objective/capture
/datum/objective/capture/proc/gen_amount_goal()
	target_amount = rand(5,10)
	explanation_text = "Накопите [target_amount] очков захвата."
	return target_amount


/datum/objective/capture/check_completion()//Basically runs through all the mobs in the area to determine how much they are worth.
	return 0




/datum/objective/absorb
/datum/objective/absorb/proc/gen_amount_goal(var/lowbound = 4, var/highbound = 6)
	target_amount = rand (lowbound,highbound)
	if(SSticker)
		var/n_p = 1 //autowin
		if(SSticker.current_state == GAME_STATE_SETTING_UP)
			for(var/mob/new_player/P in GLOB.player_list)
				if(P.client && P.ready && P.mind != owner)
					if(P.client.prefs && (P.client.prefs.species == "Machine")) // Special check for species that can't be absorbed. No better solution.
						continue
					n_p++
		else if(SSticker.current_state == GAME_STATE_PLAYING)
			for(var/mob/living/carbon/human/P in GLOB.player_list)
				if(NO_DNA in P.dna.species.species_traits)
					continue
				if(P.client && !(P.mind in SSticker.mode.changelings) && P.mind!=owner)
					n_p++
		target_amount = min(target_amount, n_p)

	explanation_text = "Получите [target_amount] совместимых геномов. 'Жало экстракта ДНК' может быть использовано для скрытого получения геномов, не убивая кого-либо."
	return target_amount

/datum/objective/absorb/check_completion()
	if(owner && owner.changeling && owner.changeling.absorbed_dna && (owner.changeling.absorbedcount >= target_amount))
		return 1
	else
		return 0

/datum/objective/destroy
	martyr_compatible = 1
	var/target_real_name

/datum/objective/destroy/find_target()
	var/list/possible_targets = active_ais(1)
	var/mob/living/silicon/ai/target_ai = pick(possible_targets)
	target = target_ai.mind
	if(target && target.current)
		target_real_name = target.current.real_name
		explanation_text = "Уничтожить [target_real_name], ИИ."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/destroy/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD || is_away_level(target.current.z) || !target.current.ckey)
			return 1
		return 0
	return 1

/datum/objective/steal_five_of_type
	explanation_text = "Укради как минимум пять предметов!"
	var/list/wanted_items = list()

/datum/objective/steal_five_of_type/New()
	..()
	wanted_items = typecacheof(wanted_items)

/datum/objective/steal_five_of_type/check_completion()
	var/stolen_count = 0
	if(!isliving(owner.current))
		return FALSE
	var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
	for(var/obj/I in all_items) //Check for wanted items
		if(is_type_in_typecache(I, wanted_items))
			stolen_count++
	return stolen_count >= 5

/datum/objective/steal_five_of_type/summon_guns
	explanation_text = "Укради по крайней мере пять пушек!"
	wanted_items = list(/obj/item/gun)

/datum/objective/steal_five_of_type/summon_magic
	explanation_text = "Укради по крайней мере пять магических артефактов!"
	wanted_items = list()

/datum/objective/steal_five_of_type/summon_magic/New()
	wanted_items = GLOB.summoned_magic_objectives
	..()

/datum/objective/steal_five_of_type/summon_magic/check_completion()
	var/stolen_count = 0
	if(!isliving(owner.current))
		return FALSE
	var/list/all_items = owner.current.GetAllContents()	//this should get things in cheesewheels, books, etc.
	for(var/obj/I in all_items) //Check for wanted items
		if(istype(I, /obj/item/spellbook) && !istype(I, /obj/item/spellbook/oneuse))
			var/obj/item/spellbook/spellbook = I
			if(spellbook.uses) //if the book still has powers...
				stolen_count++ //it counts. nice.
		if(istype(I, /obj/item/spellbook/oneuse))
			var/obj/item/spellbook/oneuse/oneuse = I
			if(!oneuse.used)
				stolen_count++
		else if(is_type_in_typecache(I, wanted_items))
			stolen_count++
	return stolen_count >= 5

/datum/objective/blood
/datum/objective/blood/proc/gen_amount_goal(low = 150, high = 400)
	target_amount = rand(low,high)
	target_amount = round(round(target_amount/5)*5)
	explanation_text = "Накопить хотя бы [target_amount] общего количества юнитов крови."
	return target_amount

/datum/objective/blood/check_completion()
	if(owner && owner.vampire && owner.vampire.bloodtotal && owner.vampire.bloodtotal >= target_amount)
		return 1
	else
		return 0

// /vg/; Vox Inviolate for humans :V
/datum/objective/minimize_casualties
	explanation_text = "Сведите к минимуму потери."

/datum/objective/minimize_casualties/check_completion()
	return TRUE


//Vox heist objectives.

/datum/objective/heist
/datum/objective/heist/proc/choose_target()
	return

/datum/objective/heist/kidnap
/datum/objective/heist/kidnap/choose_target()
	var/list/roles = list("Chief Engineer","Research Director","Roboticist","Chemist","Station Engineer")
	var/list/possible_targets = list()
	var/list/priority_targets = list()

	for(var/datum/mind/possible_target in SSticker.minds)
		if(possible_target != owner && ishuman(possible_target.current) && (possible_target.current.stat != DEAD) && (possible_target.assigned_role != possible_target.special_role) && !possible_target.offstation_role)
			possible_targets += possible_target
			for(var/role in roles)
				if(possible_target.assigned_role == role)
					priority_targets += possible_target
					continue

	if(priority_targets.len > 0)
		target = pick(priority_targets)
	else if(possible_targets.len > 0)
		target = pick(possible_targets)

	if(target && target.current)
		explanation_text = "У Shoal есть потребность в [target.current.real_name] - [target.assigned_role]. Заберите [target.current.p_them()] живым."
	else
		explanation_text = "Free Objective."
	return target

/datum/objective/heist/kidnap/check_completion()
	if(target && target.current)
		if(target.current.stat == DEAD)
			return 0

		var/area/shuttle/vox/A = locate() //stupid fucking hardcoding
		var/area/vox_station/B = locate() //but necessary

		for(var/mob/living/carbon/human/M in A)
			if(target.current == M)
				return 1
		for(var/mob/living/carbon/human/M in B)
			if(target.current == M)
				return 1
	else
		return 0

/datum/objective/heist/loot
/datum/objective/heist/loot/choose_target()
	var/loot = "an object"
	switch(rand(1,8))
		if(1)
			target = /obj/structure/particle_accelerator
			target_amount = 6
			loot = "полный ускоритель частиц"
		if(2)
			target = /obj/machinery/the_singularitygen
			target_amount = 1
			loot = "генератор гравитационных сингулярностей"
		if(3)
			target = /obj/machinery/power/emitter
			target_amount = 4
			loot = "четыре излучателя"
		if(4)
			target = /obj/machinery/nuclearbomb
			target_amount = 1
			loot = "ядерную бомбу"
		if(5)
			target = /obj/item/gun
			target_amount = 6
			loot = "шесть пистолетов. Электрошокеры и другое нелетальное оружие приемлемы"
		if(6)
			target = /obj/item/gun/energy
			target_amount = 4
			loot = "четыре энергетических ружья"
		if(7)
			target = /obj/item/gun/energy/laser
			target_amount = 2
			loot = "два лазерных пистолета"
		if(8)
			target = /obj/item/gun/energy/ionrifle
			target_amount = 1
			loot = "ионную пушку"

	explanation_text = "Нам не хватает оборудования. Своруйте или выторгуйте [loot]."

/datum/objective/heist/loot/check_completion()
	var/total_amount = 0

	for(var/obj/O in locate(/area/shuttle/vox))
		if(istype(O, target))
			total_amount++
		for(var/obj/I in O.contents)
			if(istype(I, target))
				total_amount++
			if(total_amount >= target_amount)
				return 1

	for(var/obj/O in locate(/area/vox_station))
		if(istype(O, target))
			total_amount++
		for(var/obj/I in O.contents)
			if(istype(I, target))
				total_amount++
			if(total_amount >= target_amount)
				return 1

	var/datum/game_mode/heist/H = SSticker.mode
	for(var/datum/mind/raider in H.raiders)
		if(raider.current)
			for(var/obj/O in raider.current.get_contents())
				if(istype(O,target))
					total_amount++
				if(total_amount >= target_amount)
					return 1

	return 0

/datum/objective/heist/salvage
/datum/objective/heist/salvage/choose_target()
	switch(rand(1,8))
		if(1)
			target = "металла"
			target_amount = 300
		if(2)
			target = "стекла"
			target_amount = 200
		if(3)
			target = "пластали"
			target_amount = 100
		if(4)
			target = "твёрдой плазмы"
			target_amount = 100
		if(5)
			target = "серебра"
			target_amount = 50
		if(6)
			target = "золота"
			target_amount = 20
		if(7)
			target = "ураниума"
			target_amount = 20
		if(8)
			target = "алмаза"
			target_amount = 20

	explanation_text = "Обыщите или обменяйтесь со станцией и сбежите с [target_amount] шт. [target]."

/datum/objective/heist/salvage/check_completion()
	var/total_amount = 0

	for(var/obj/item/O in locate(/area/shuttle/vox))
		var/obj/item/stack/sheet/S
		if(istype(O,/obj/item/stack/sheet))
			if(O.name == target)
				S = O
				total_amount += S.get_amount()

		for(var/obj/I in O.contents)
			if(istype(I,/obj/item/stack/sheet))
				if(I.name == target)
					S = I
					total_amount += S.get_amount()

	for(var/obj/item/O in locate(/area/vox_station))
		var/obj/item/stack/sheet/S
		if(istype(O,/obj/item/stack/sheet))
			if(O.name == target)
				S = O
				total_amount += S.get_amount()

		for(var/obj/I in O.contents)
			if(istype(I,/obj/item/stack/sheet))
				if(I.name == target)
					S = I
					total_amount += S.get_amount()

	var/datum/game_mode/heist/H = SSticker.mode
	for(var/datum/mind/raider in H.raiders)
		if(raider.current)
			for(var/obj/item/O in raider.current.get_contents())
				if(istype(O,/obj/item/stack/sheet))
					if(O.name == target)
						var/obj/item/stack/sheet/S = O
						total_amount += S.get_amount()

	if(total_amount >= target_amount) return 1
	return 0


/datum/objective/heist/inviolate_crew
	explanation_text = "Не оставляйте ни одного Вокса, живого или мертвого."

/datum/objective/heist/inviolate_crew/check_completion()
	var/datum/game_mode/heist/H = SSticker.mode
	if(H.is_raider_crew_safe())
		return 1
	return 0

/datum/objective/heist/inviolate_death
	explanation_text = "Следуйте за Неприкосновенным. Сведите к минимуму смертность и потерю ресурсов."

/datum/objective/heist/inviolate_death/check_completion()
	return TRUE

// Traders
// These objectives have no check_completion, they exist only to tell Sol Traders what to aim for.

/datum/objective/trade/proc/choose_target()
	return

/datum/objective/trade/plasma/choose_target()
	explanation_text = "Приобретите не менее 15 листов плазмы через торги."

/datum/objective/trade/credits/choose_target()
	explanation_text = "Приобретите не менее 10 000 кредитов через торги."

//wizard

/datum/objective/wizchaos
	explanation_text = "Посейте хаос на станции, как только сможете. Отправь этим безжалостным подонкам Nanotrasen послание!"
	completed = 1
