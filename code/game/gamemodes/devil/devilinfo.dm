#define BLOOD_THRESHOLD 3 //How many souls are needed per stage.
#define TRUE_THRESHOLD 7
#define ARCH_THRESHOLD 12

#define BASIC_DEVIL 0
#define BLOOD_LIZARD 1
#define TRUE_DEVIL 2
#define ARCH_DEVIL 3

#define LOSS_PER_DEATH 2

#define SOULVALUE (soulsOwned.len-reviveNumber)

#define DEVILRESURRECTTIME 600

GLOBAL_LIST_EMPTY(allDevils)
GLOBAL_LIST_INIT(lawlorify, list (
		LORE = list(
			OBLIGATION_FOOD = "Этот дьявол, кажется, всегда предлагает своим жертвам пищу, прежде чем убивать их.",
			OBLIGATION_FIDDLE = "Этот дьявол никогда не откажется от музыкального вызова.",
			OBLIGATION_DANCEOFF = "Этот дьявол никогда не откажется от танца.",
			OBLIGATION_GREET = "Этот дьявол, похоже, способен общаться только с людьми, которых он знает по имени.",
			OBLIGATION_PRESENCEKNOWN = "Этот дьявол, похоже, не способен атаковать исподтишка.",
			OBLIGATION_SAYNAME = "Он всегда будет повторять свое имя, убивая кого-то.",
			OBLIGATION_ANNOUNCEKILL = "Этот дьявол всегда громко объявляет о своих убийствах, чтобы их слышал весь мир.",
			OBLIGATION_ANSWERTONAME = "Этот дьявол всегда откликается на свое истинное имя.",
			BANE_SILVER = "Серебро, похоже, серьезно ранит этого дьявола.",
			BANE_SALT = "Бросание соли в этого дьявола временно ограничит его способность использовать адские силы.",
			BANE_LIGHT = "Яркие вспышки дезориентируют дьявола, вероятно, заставляя его бежать.",
			BANE_IRON = "Холодное железо будет медленно травмировать его, пока он не сможет очистить его от своего организма.",
			BANE_WHITECLOTHES = "Ношение чистой белой одежды поможет отогнать этого дьявола.",
			BANE_HARVEST = "Представление трудов по сбору урожая разрушит дьявола.",
			BANE_TOOLBOX = "То, что содержит средства творения, также содержит средства уничтожения дьявола.",
			BAN_HURTWOMAN = "Этот дьявол, похоже, предпочитает охотиться на мужчин.",
			BAN_CHAPEL = "Этот дьявол избегает святой земли.",
			BAN_HURTPRIEST = "Помазанное духовенство, по-видимому, невосприимчиво к его силам.",
			BAN_AVOIDWATER = "Дьявол, похоже, испытывает какое-то отвращение к воде, хотя, похоже, она ему не вредит.",
			BAN_STRIKEUNCONCIOUS = "Этот дьявол проявляет интерес только к тем, кто бодрствует.",
			BAN_HURTLIZARD = "Этот дьявол не нападет первым на Унатхи.",
			BAN_HURTANIMAL = "Этот дьявол избегает причинять боль животным.",
			BANISH_WATER = "Чтобы изгнать дьявола, вы должны наполнить его тело святой водой.",
			BANISH_COFFIN = "Этот дьявол вернется к жизни, если его останки не будут помещены в гроб.",
			BANISH_FORMALDYHIDE = "Чтобы изгнать дьявола, вы должны ввести в его безжизненное тело бальзамирующую жидкость.",
			BANISH_RUNES = "Этот дьявол воскреснет после смерти, если только его останки не окажутся внутри руны.",
			BANISH_CANDLES = "Большое количество зажженных поблизости свечей предотвратит его воскрешение.",
			BANISH_DESTRUCTION = "Его труп должен быть полностью уничтожен, чтобы предотвратить воскрешение.",
			BANISH_FUNERAL_GARB = "Если этот дьявол будет облачен в погребальные одежды, он не сможет воскреснуть. Если одежда не подойдет, аккуратно положите ее поверх трупа дьявола."
		),
		LAW = list(
			OBLIGATION_FOOD = "Когда вы не действуете в целях самообороны, вы всегда должны предлагать своей жертве пищу, прежде чем причинять ей вред.",
			OBLIGATION_FIDDLE = "Когда вам не угрожает непосредственная опасность, если вас вызывают на музыкальную дуэль, вы должны принять ее. Вы не обязаны дважды приступать на дуэль с одним и тем же человеком.",
			OBLIGATION_DANCEOFF = "Когда вам не угрожает непосредственная опасность, если вас вызывают на танец, вы должны принять это. Вы не обязаны сталкиваться с одним и тем же человеком дважды.",
			OBLIGATION_GREET = "Вы всегда должны приветствовать других людей по фамилии, прежде чем разговаривать с ними.",
			OBLIGATION_PRESENCEKNOWN = "Вы всегда должны сообщать о своем присутствии, прежде чем нападать.",
			OBLIGATION_SAYNAME = "Ты всегда должен называть свое истинное имя после того, как убьешь кого-нибудь.",
			OBLIGATION_ANNOUNCEKILL = "Убив кого-то, вы должны сообщить о своем поступке всем, кто находится в пределах слышимости. По связи, если это возможно.",
			OBLIGATION_ANSWERTONAME = "Если вы не подвергаетесь нападению, вы всегда должны откликнуться на свое истинное имя.",
			BAN_HURTWOMAN = "Вы никогда не должны причинять вред женщине вне пределов самообороны.",
			BAN_CHAPEL = "Вы никогда не должны пытаться войти в церковь.",
			BAN_HURTPRIEST = "Ты никогда не должен нападать на священника.",
			BAN_AVOIDWATER = "Вы никогда не должны добровольно прикасаться к влажной поверхности.",
			BAN_STRIKEUNCONCIOUS = "Вы никогда не должны бить человека, находящегося без сознания.",
			BAN_HURTLIZARD = "Вы никогда не должны причинять вред Унатхи вне пределов самообороны.",
			BAN_HURTANIMAL = "Вы никогда не должны причинять вред неразумному существу или роботу вне пределов самообороны.",
			BANE_SILVER = "Серебро, во всех его проявлениях, станет твоей погибелью.",
			BANE_SALT = "Соль разрушит ваши магические способности.",
			BANE_LIGHT = "Ослепляющий свет на какое-то время помешают вам использовать наступательные способности.",
			BANE_IRON = "Холодное кованое железо подействует на вас как яд.",
			BANE_WHITECLOTHES = "Те, кто одет в девственно белую одежду, поразят вас по-настоящему.",
			BANE_HARVEST = "Плоды жатвы будут твоей погибелью.",
			BANE_TOOLBOX = "Наборы инструментов по какой-то причине являются для вас плохой новостью.",
			BANISH_WATER = "Если ваш труп наполнят святой водой, вы не сможете воскреснуть.",
			BANISH_COFFIN = "Если ваш труп находится в гробу, вы не сможете воскреснуть.",
			BANISH_FORMALDYHIDE = "Если ваш труп забальзамируют, вы не сможете воскреснуть.",
			BANISH_RUNES = "Если ваш труп будет помещен в руну, вы не сможете воскреснуть.",
			BANISH_CANDLES = "Если ваш труп находится рядом с зажженными свечами, вы не сможете воскреснуть.",
			BANISH_DESTRUCTION = "Если ваш труп будет уничтожен, вы не сможете воскреснуть.",
			BANISH_FUNERAL_GARB = "Если ваш труп будет облачен в погребальные одежды, вы не сможете воскреснуть."
		)
	))

/datum/devilinfo
	var/datum/mind/owner = null
	var/obligation
	var/ban
	var/bane
	var/banish
	var/truename
	var/list/datum/mind/soulsOwned = new
	var/datum/dna/humanform = null
	var/reviveNumber = 0
	var/form = BASIC_DEVIL
	var/exists = 0
	var/static/list/dont_remove_spells = list(
	/obj/effect/proc_holder/spell/targeted/click/summon_contract,
	/obj/effect/proc_holder/spell/targeted/conjure_item/violin,
	/obj/effect/proc_holder/spell/targeted/summon_dancefloor)
	var/ascendable = FALSE

/datum/devilinfo/New()
	..()
	dont_remove_spells = typecacheof(dont_remove_spells)

/proc/randomDevilInfo(name = randomDevilName())
	var/datum/devilinfo/devil = new
	devil.truename = name
	devil.bane = randomdevilbane()
	devil.obligation = randomdevilobligation()
	devil.ban = randomdevilban()
	devil.banish = randomdevilbanish()
	return devil

/proc/devilInfo(name, saveDetails = 0)
	if(GLOB.allDevils[lowertext(name)])
		return GLOB.allDevils[lowertext(name)]
	else
		var/datum/devilinfo/devil = randomDevilInfo(name)
		GLOB.allDevils[lowertext(name)] = devil
		devil.exists = saveDetails
		return devil



/proc/randomDevilName()
	var/preTitle = ""
	var/title = ""
	var/mainName = ""
	var/suffix = ""
	if(prob(65))
		if(prob(35))
			preTitle = pick("Тёмный ", "Адский ", "Пламенный ", "Грешный ", "Кровавый ")
		title = pick("Господин ", "Падший Прелат ", "Конт ", "Виконт ", "Визир ", "Древний ", "Адепт ")
	var/probability = 100
	mainName = pick("Хал", "Ве", "Одр", "Наэт", "Ци", "Къон", "Миа", "Фолтх", "Врэн", "Гьер", "Гэер", "Хил", "Найет", "Тоу", "Ху", "Дон")
	while(prob(probability))
		mainName += pick("хал", "вэ", "одр", "нэет", "ца", "къан", "мие", "фолтх", "врэн", "гьер", "гаэр", "хиль", "найет", "тьуэй", "фай", "кьоа")
		probability -= 20
	if(prob(40))
		suffix = pick(" Красный", " Бездушный", " Повелитель", ", Господь всего сущего", ", Младший")
	return preTitle + title + mainName + suffix

/proc/randomdevilobligation()
	return pick(OBLIGATION_FOOD, OBLIGATION_FIDDLE, OBLIGATION_DANCEOFF, OBLIGATION_GREET, OBLIGATION_PRESENCEKNOWN, OBLIGATION_SAYNAME, OBLIGATION_ANNOUNCEKILL, OBLIGATION_ANSWERTONAME)

/proc/randomdevilban()
	return pick(BAN_HURTWOMAN, BAN_CHAPEL, BAN_HURTPRIEST, BAN_AVOIDWATER, BAN_STRIKEUNCONCIOUS, BAN_HURTLIZARD, BAN_HURTANIMAL)

/proc/randomdevilbane()
	return pick(BANE_SALT, BANE_LIGHT, BANE_IRON, BANE_WHITECLOTHES, BANE_SILVER, BANE_HARVEST, BANE_TOOLBOX)

/proc/randomdevilbanish()
	return pick(BANISH_WATER, BANISH_COFFIN, BANISH_FORMALDYHIDE, BANISH_RUNES, BANISH_CANDLES, BANISH_DESTRUCTION, BANISH_FUNERAL_GARB)

/datum/devilinfo/proc/link_with_mob(mob/living/L)
	if(istype(L, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = L
		humanform = H.dna.Clone()
	owner = L.mind
	give_base_spells(1)

/datum/devilinfo/proc/add_soul(datum/mind/soul)
	if(soulsOwned.Find(soul))
		return
	soulsOwned += soul
	owner.current.set_nutrition(NUTRITION_LEVEL_FULL)
	to_chat(owner.current, "<span class='warning'>Вы чувствуете себя сытым, так как получили новую душу.</span>")
	update_hud()
	switch(SOULVALUE)
		if(0)
			to_chat(owner.current, "<span class='warning'>Твои адские силы восстановлены.</span>")
			give_base_spells()
		if(BLOOD_THRESHOLD)
			to_chat(owner.current, "<span class='warning'>Вам кажется, что ваша гуманоидная форма вот-вот исчезнет. Ты скоро превратишься в кровавую ящерицу.</span>")
			sleep(50)
			increase_blood_lizard()
		if(TRUE_THRESHOLD)
			to_chat(owner.current, "<span class='warning'>Вы чувствуете, что ваша нынешняя форма вот-вот потеряет свою форму. Ты скоро превратишься в настоящего дьявола.</span>")
			sleep(50)
			increase_true_devil()
		if(ARCH_THRESHOLD)
			arch_devil_prelude()
			increase_arch_devil()

/datum/devilinfo/proc/remove_soul(datum/mind/soul)
	if(soulsOwned.Remove(soul))
		to_chat(owner.current, "<span class='warning'>Вы чувствуете, как будто душа выскользнула из ваших рук.</span>")
		check_regression()
		update_hud()

/datum/devilinfo/proc/check_regression()
	if(form == ARCH_DEVIL)
		return //arch devil can't regress
	//Yes, fallthrough behavior is intended, so I can't use a switch statement.
	if(form == TRUE_DEVIL && SOULVALUE < TRUE_THRESHOLD)
		regress_blood_lizard()
	if(form == BLOOD_LIZARD && SOULVALUE < BLOOD_THRESHOLD)
		regress_humanoid()
	if(SOULVALUE < 0)
		remove_spells()
		to_chat(owner.current, "<span class='warning'>В наказание за ваши неудачи все ваши полномочия, кроме создания контракта, были аннулированы.</span>")

/datum/devilinfo/proc/regress_humanoid()
	to_chat(owner.current, "<span class='warning'>Ваши силы ослабевают, нужно подписать больше контрактов, чтобы восстановить власть.</span>")
	if(istype(owner.current, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner.current
		if(humanform)
			H.set_species(humanform.species)
			H.dna = humanform.Clone()
			H.sync_organ_dna(assimilate = 0)
		else
			H.set_species(/datum/species/human)
			// TODO: Add some appearance randomization here or something
			humanform = H.dna.Clone()
		H.regenerate_icons()
	else
		owner.current.color = ""
	give_base_spells()
	if(istype(owner.current.loc, /obj/effect/dummy/slaughter))
		owner.current.forceMove(get_turf(owner.current))//Fixes dying while jaunted leaving you permajaunted.
	form = BASIC_DEVIL

/datum/devilinfo/proc/regress_blood_lizard()
	var/mob/living/carbon/true_devil/D = owner.current
	to_chat(D, "<span class='warning'>Ваши силы ослабевают, нужно подписать больше контрактов, чтобы восстановить власть.</span>")
	D.oldform.loc = D.loc
	owner.transfer_to(D.oldform)
	D.oldform.status_flags &= ~GODMODE
	give_lizard_spells()
	qdel(D)
	form = BLOOD_LIZARD
	update_hud()


/datum/devilinfo/proc/increase_blood_lizard()
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		var/list/language_temp = H.languages.Copy()
		H.set_species(/datum/species/unathi)
		H.languages = language_temp
		H.underwear = "Nude"
		H.undershirt = "Nude"
		H.socks = "Nude"
		H.change_skin_color(80, 16, 16) //A deep red
		H.regenerate_icons()
	else //Did the devil get hit by a staff of transmutation?
		owner.current.color = "#501010"
	give_lizard_spells()
	form = BLOOD_LIZARD



/datum/devilinfo/proc/increase_true_devil()
	var/mob/living/carbon/true_devil/A = new /mob/living/carbon/true_devil(owner.current.loc, owner.current)
	A.faction |= "hell"
	// Put the old body in stasis
	owner.current.status_flags |= GODMODE
	owner.current.loc = A
	A.oldform = owner.current
	owner.transfer_to(A)
	A.set_name()
	give_true_spells()
	form = TRUE_DEVIL
	update_hud()

/datum/devilinfo/proc/arch_devil_prelude()
	if(!ascendable)
		return
	var/mob/living/carbon/true_devil/D = owner.current
	to_chat(D, "<span class='warning'>Вы чувствуете, как будто ваша форма вот-вот вознесется.</span>")
	sleep(50)
	if(!D)
		return
	D.visible_message("<span class='warning'>Кожа [D] начинает покрываться шипами.</span>", \
		"<span class='warning'>Ваша плоть начинает создавать щит вокруг вас самих.</span>")
	sleep(100)
	if(!D)
		return
	D.visible_message("<span class='warning'>Рога на голове [D] медленно растут и удлиняются.</span>", \
		"<span class='warning'>Ваше тело продолжает мутировать. Твои телепатические способности растут.</span>")
	sleep(90)
	if(!D)
		return
	D.visible_message("<span class='warning'>Тело [D] начинает яростно растягиваться и искривляться.</span>", \
		"<span class='warning'>Вы начинаете разрушать последние барьеры на пути к высшей власти.</span>")
	sleep(40)
	if(!D)
		return
	to_chat(D, "<span class='sinister'>Да!</span>")
	sleep(10)
	if(!D)
		return
	to_chat(D, "<span class='big sinister'>ДА!!</span>")
	sleep(10)
	if(!D)
		return
	to_chat(D, "<span class='reallybig sinister'>ДА-А--</span>")
	sleep(1)
	if(!D)
		return
	to_chat(world, "<font size=5><span class='danger'>ЛЕНЬ, ГНЕВ, ОБЖОРСТВО, ЗЛОБА, ЗАВИСТЬ, ЖАДНОСТЬ, ГОРДЫНЯ! АДСКОЕ ПЛАМЯ ПРОБУЖДАЕТСЯ!!!</span></font>")
	world << 'sound/hallucinations/veryfar_noise.ogg'
	sleep(50)
	if(!SSticker.mode.devil_ascended)
		SSshuttle.emergency.request(null, 0.3)
	SSticker.mode.devil_ascended++

/datum/devilinfo/proc/increase_arch_devil()
	if(!ascendable)
		return
	var/mob/living/carbon/true_devil/D = owner.current
	if(!istype(D))
		return
	give_arch_spells()
	D.convert_to_archdevil()
	if(istype(D.loc, /obj/effect/dummy/slaughter))
		D.forceMove(get_turf(D))
	var/area/A = get_area(owner.current)
	if(A)
		notify_ghosts("Архидемон вознесся в [A.name]. Обратитесь к дьяволу, чтобы начать восхождение по внутренней корпоративной лестнице.", title = "Архидемон вознесся", source = owner.current, action = NOTIFY_ATTACK)
	form = ARCH_DEVIL

/datum/devilinfo/proc/remove_spells()
	for(var/X in owner.spell_list)
		var/obj/effect/proc_holder/spell/S = X
		if(!is_type_in_typecache(S, dont_remove_spells))
			owner.RemoveSpell(S)

/datum/devilinfo/proc/give_summon_contract()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/click/summon_contract(null))


/datum/devilinfo/proc/give_base_spells(give_summon_contract = 0)
	remove_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/click/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/pitchfork(null))
	if(give_summon_contract)
		give_summon_contract()
		if(obligation == OBLIGATION_FIDDLE)
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/violin(null))
		if(obligation == OBLIGATION_DANCEOFF)
			owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/summon_dancefloor(null))

/datum/devilinfo/proc/give_lizard_spells()
	remove_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/pitchfork(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/click/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))

/datum/devilinfo/proc/give_true_spells()
	remove_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/pitchfork/greater(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/click/fireball/hellish(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/infernal_jaunt(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/sintouch(null))

/datum/devilinfo/proc/give_arch_spells()
	remove_spells()
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/conjure_item/pitchfork/ascended(null))
	owner.AddSpell(new /obj/effect/proc_holder/spell/targeted/sintouch/ascended(null))

/datum/devilinfo/proc/beginResurrectionCheck(mob/living/body)
	if(owner.current != body)
		body = owner.current
	if(SOULVALUE > 0)
		to_chat(owner.current, "<span class='userdanger'>Ваше тело было повреждено до такой степени, что вы больше не можете им пользоваться. Ценой некоторой части вашей силы вы скоро вернетесь к жизни.</span>")
		addtimer(CALLBACK(src, "activateResurrection", body), DEVILRESURRECTTIME)
	else
		to_chat(owner.messageable_mob(), "<span class='userdanger'>Твои адские силы слишком слабы, чтобы воскресить себя.</span>")

/datum/devilinfo/proc/activateResurrection(mob/living/body)
	if(QDELETED(body) ||  body.stat == DEAD)
		if(SOULVALUE > 0)
			if(check_banishment(body))
				to_chat(owner.messageable_mob(), "<span class='userdanger'>К сожалению, смертные завершили ритуал, который препятствует вашему воскрешению.</span>")
				return -1
			else
				to_chat(owner.messageable_mob(), "<span class='userdanger'>МЫ СНОВА ЖИВЫ!</span>")
				return hellish_resurrection(body)
		else
			to_chat(owner.messageable_mob(), "<span class='userdanger'>К сожалению, сила, которая проистекала из ваших контрактов, была уничтожена. У тебя больше нет достаточно сил, чтобы воскреснуть.</span>")
			return -1
	else
		to_chat(owner.current, "<span class='danger'>Ты, кажется, воскрес без своих адских сил.</span>")

/datum/devilinfo/proc/check_banishment(mob/living/body)
	switch(banish)
		if(BANISH_WATER)
			if(!QDELETED(body) && iscarbon(body))
				var/mob/living/carbon/H = body
				return H.reagents.has_reagent("holy water")
			return 0
		if(BANISH_COFFIN)
			return (!QDELETED(body) && istype(body.loc, /obj/structure/closet/coffin))
		if(BANISH_FORMALDYHIDE)
			if(!QDELETED(body) && iscarbon(body))
				var/mob/living/carbon/H = body
				return H.reagents.has_reagent("formaldehyde")
			return 0
		if(BANISH_RUNES)
			if(!QDELETED(body))
				for(var/obj/effect/decal/cleanable/crayon/R in range(0,body))
					if (R.name == "rune")
						return 1
			return 0
		if(BANISH_CANDLES)
			if(!QDELETED(body))
				var/count = 0
				for(var/obj/item/candle/C in range(1,body))
					count += C.lit
				if(count>=4)
					return 1
			return 0
		if(BANISH_DESTRUCTION)
			if(!QDELETED(body))
				return 0
			return 1
		if(BANISH_FUNERAL_GARB)
			if(!QDELETED(body) && iscarbon(body))
				var/mob/living/carbon/human/H = body
				if(H.w_uniform && istype(H.w_uniform, /obj/item/clothing/under/burial))
					return 1
				return 0
			else
				for(var/obj/item/clothing/under/burial/B in range(0,body))
					if(B.loc == get_turf(B)) //Make sure it's not in someone's inventory or something.
						return 1
				return 0

/datum/devilinfo/proc/hellish_resurrection(mob/living/body)
	message_admins("[owner.name] (настоящее имя: [truename]) воскрешается, используя адскую энергию.</a>")
	if(SOULVALUE <= ARCH_THRESHOLD && ascendable) // once ascended, arch devils do not go down in power by any means.
		reviveNumber += LOSS_PER_DEATH
		update_hud()
	if(!QDELETED(body))
		body.revive()
		if(!body.client)
			var/mob/dead/observer/O = owner.get_ghost()
			O.reenter_corpse()
		if(istype(body.loc, /obj/effect/dummy/slaughter))
			body.forceMove(get_turf(body))//Fixes dying while jaunted leaving you permajaunted.
		if(istype(body, /mob/living/carbon/true_devil))
			var/mob/living/carbon/true_devil/D = body
			if(D.oldform)
				D.oldform.revive() // Heal the old body too, so the devil doesn't resurrect, then immediately regress into a dead body.
		if(body.stat == DEAD) // Not sure why this would happen
			create_new_body()
		else if(GLOB.blobstart.len > 0)
			// teleport the body so repeated beatdowns aren't an option)
			body.forceMove(get_turf(pick(GLOB.blobstart)))
			// give them the devil lawyer outfit in case they got stripped
			if(ishuman(body))
				var/mob/living/carbon/human/H = body
				H.equipOutfit(/datum/outfit/devil_lawyer)
	else
		create_new_body()
	check_regression()

/datum/devilinfo/proc/create_new_body()
	if(GLOB.blobstart.len > 0)
		var/turf/targetturf = get_turf(pick(GLOB.blobstart))
		var/mob/currentMob = owner.current
		if(QDELETED(currentMob))
			currentMob = owner.get_ghost()
			if(!currentMob)
				message_admins("Воскрешение дьявола не удалось из-за выхода [owner.name] из системы. Отмена.")
				return -1
			if(currentMob.mind != owner)
				message_admins("Воскрешение [owner.name] (дьявола) не удалось из-за того, что он стал другим мобом.  Отмена.")
				return -1
		var/mob/living/carbon/human/H = new /mob/living/carbon/human(targetturf)
		owner.transfer_to(H)
		if(isobserver(currentMob))
			var/mob/dead/observer/O = currentMob
			O.reenter_corpse()
		if(humanform)
			H.set_species(humanform.species)
			H.dna = humanform.Clone()

			H.dna.UpdateSE()
			H.dna.UpdateUI()

			H.sync_organ_dna(1) // It's literally a fresh body as you can get, so all organs properly belong to it
			H.UpdateAppearance()
		else
			// gibbed cyborg or similar - create a randomized "humanform" appearance
			H.scramble_appearance()
			humanform = H.dna.Clone()


		H.equipOutfit(/datum/outfit/devil_lawyer)
		give_base_spells(TRUE)
		if(SOULVALUE >= BLOOD_THRESHOLD)
			increase_blood_lizard()
			if(SOULVALUE >= TRUE_THRESHOLD) //Yes, BOTH this and the above if statement are to run if soulpower is high enough.
				increase_true_devil()
				if(SOULVALUE >= ARCH_THRESHOLD && ascendable)
					increase_arch_devil()
	else
		throw EXCEPTION("Unable to find a blobstart landmark for hellish resurrection")

/datum/devilinfo/proc/update_hud()
	if(istype(owner.current, /mob/living/carbon))
		var/mob/living/C = owner.current
		if(C.hud_used && C.hud_used.devilsouldisplay)
			C.hud_used.devilsouldisplay.update_counter(SOULVALUE)

// SECTION: Messages and explanations

/datum/devilinfo/proc/announce_laws(mob/living/owner)
	to_chat(owner, "<span class='boldwarning'>Ты помнишь свою связь с адом.  Ты, [truename], агент ада, сам дьявол.  И вы были посланы не просто так. А для великой цели. Убедите экипаж согрешить и вырвитесь из объятий Ада.</span>")
	to_chat(owner, "<span class='boldwarning'>Однако ваша адская форма не лишена слабостей.</span>")
	to_chat(owner, "Вы не можете использовать насилие, чтобы заставить кого-то продать свою душу.")
	to_chat(owner, "Вы не можете прямо и сознательно причинять физический вред дьяволу, кроме себя.")
	to_chat(owner,GLOB.lawlorify[LAW][bane])
	to_chat(owner,GLOB.lawlorify[LAW][ban])
	to_chat(owner,GLOB.lawlorify[LAW][obligation])
	to_chat(owner,GLOB.lawlorify[LAW][banish])
	to_chat(owner, "<br/><br/><span class='warning'>Помните, что команда может исследовать ваши слабые места, если они узнают ваше дьявольское имя.</span><br>")


#undef BLOOD_THRESHOLD
#undef TRUE_THRESHOLD
#undef ARCH_THRESHOLD
#undef BASIC_DEVIL
#undef BLOOD_LIZARD
#undef TRUE_DEVIL
#undef ARCH_DEVIL
#undef LOSS_PER_DEATH
#undef SOULVALUE
#undef DEVILRESURRECTTIME

/datum/outfit/devil_lawyer
	name = "Адвокат Дьявола"
	uniform = /obj/item/clothing/under/lawyer/black
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack
	l_hand = /obj/item/storage/briefcase
	l_pocket = /obj/item/pen
	l_ear = /obj/item/radio/headset

	id = /obj/item/card/id

/datum/outfit/devil_lawyer/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	var/obj/item/card/id/W = H.wear_id
	if(!istype(W) || W.assignment) // either doesn't have a card, or the card is already written to
		return
	var/name_to_use = H.real_name
	if(H.mind && H.mind.devilinfo)
		// Having hell create an ID for you causes its risks
		name_to_use = H.mind.devilinfo.truename

	W.name = "ID-карта [name_to_use] (Адвокат)"
	W.registered_name = name_to_use
	W.assignment = "Lawyer"
	W.rank = W.assignment
	W.age = H.age
	W.sex = capitalize(H.gender)
	W.access = list(ACCESS_MAINT_TUNNELS, ACCESS_SYNDICATE, ACCESS_EXTERNAL_AIRLOCKS)
	W.photo = get_id_photo(H)
