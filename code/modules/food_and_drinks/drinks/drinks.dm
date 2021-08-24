////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food/drinks
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	icon_state = null
	container_type = OPENCONTAINER
	consume_sound = 'sound/items/drink.ogg'
	possible_transfer_amounts = list(5,10,15,20,25,30,50)
	volume = 50
	resistance_flags = NONE
	antable = FALSE

/obj/item/reagent_containers/food/drinks/New()
	..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	bitesize = amount_per_transfer_from_this
	if(bitesize < 5)
		bitesize = 5

/obj/item/reagent_containers/food/drinks/attack_self(mob/user)
	return

/obj/item/reagent_containers/food/drinks/attack(mob/M, mob/user, def_zone)
	if(!reagents || !reagents.total_volume)
		to_chat(user, "<span class='warning'>Ничего из [src] не осталось, о чёрт!</span>")
		return FALSE

	if(!is_drainable())
		to_chat(user, "<span class='warning'>Сначала вам нужно открыть [src]!</span>")
		return FALSE

	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(C.eat(src, user))
			if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
				var/mob/living/silicon/robot/borg = user
				borg.cell.use(30)
				var/refill = reagents.get_master_reagent_id()
				if(refill in GLOB.drinks) // Only synthesize drinks
					addtimer(CALLBACK(reagents, /datum/reagents.proc/add_reagent, refill, bitesize), 600)
			return TRUE
	return FALSE

/obj/item/reagent_containers/food/drinks/MouseDrop(atom/over_object) //CHUG! CHUG! CHUG!
	var/mob/living/carbon/chugger = over_object
	if (!(container_type & DRAINABLE))
		to_chat(chugger, "<span class='notice'>Сначала вам нужно открыть [src]!</span>")
		return
	if(istype(chugger) && loc == chugger && src == chugger.get_active_hand() && reagents.total_volume)
		chugger.visible_message("<span class='notice'>[chugger] поднимает [src] к [chugger.p_their()] рту и начинает [pick("захлёбывать","глотать")] как [pick("дикарь","бешеный зверь","уже вышло из моды","будто завтрашнего дня не будет")]!</span>", "<span class='notice'>Ты начинаешь заглатывать [src].</span>", "<span class='notice'>Вы слышите звук, похожий на судорожное глотание.</span>")
		while(do_mob(chugger, chugger, 40)) //Between the default time for do_mob and the time it takes for a vampire to suck blood.
			chugger.eat(src, chugger, 25) //Half of a glass, quarter of a bottle.
			if(!reagents.total_volume) //Finish in style.
				chugger.emote("gasp")
				chugger.visible_message("<span class='notice'>[chugger] [pick("заканчивает","опусташает","выхлёбывает","загребает")] весь [src], что за [pick("дикарь","монстр","свинота","зверь")]!</span>", "<span class='notice'>Ты опустошил [src]![prob(50) ? " Может быть, это была не такая уж хорошая идея..." : ""]</span>", "<span class='notice'>Вы слышите вздох и звон.</span>")
				break

/obj/item/reagent_containers/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity)
		return

	if(target.is_refillable() && is_drainable()) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			to_chat(user, "<span class='warning'> [src] пуста.</span>")
			return FALSE

		if(target.reagents.holder_full())
			to_chat(user, "<span class='warning'> [target] полная.</span>")
			return FALSE

		var/datum/reagent/refill
		var/datum/reagent/refillName
		if(isrobot(user))
			refill = reagents.get_master_reagent_id()
			refillName = reagents.get_master_reagent_name()

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'> Вы переливаете [trans] юнит/ов в [target].</span>")

		if(isrobot(user)) //Cyborg modules that include drinks automatically refill themselves, but drain the borg's cell
			if(refill in GLOB.drinks) // Only synthesize drinks
				var/mob/living/silicon/robot/bro = user
				var/chargeAmount = max(30,4*trans)
				bro.cell.use(chargeAmount)
				to_chat(user, "<span class='notice'>Теперь синтезирует юниты [trans] от [refillName]...</span>")
				addtimer(CALLBACK(reagents, /datum/reagents.proc/add_reagent, refill, trans), 300)
				addtimer(CALLBACK(GLOBAL_PROC, .proc/to_chat, user, "<span class='notice'>[src] киборга снова наполнилась.</span>"), 300)

	else if(target.is_drainable()) //A dispenser. Transfer FROM it TO us.
		if(!is_refillable())
			to_chat(user, "<span class='warning'>Вкладка [src] не открыта!</span>")
			return FALSE
		if(!target.reagents.total_volume)
			to_chat(user, "<span class='warning'>[target] пуста.</span>")
			return FALSE

		if(reagents.holder_full())
			to_chat(user, "<span class='warning'>[src] полна.</span>")
			return FALSE

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>Вы заполняете [src] юнитами [trans] содержимого [target].</span>")

	return FALSE

/obj/item/reagent_containers/food/drinks/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		if(!reagents || reagents.total_volume == 0)
			. += "<span class='notice'>Пустой!</span>"
		else if(reagents.total_volume <= volume/4)
			. += "<span class='notice'>Почти пустой!</span>"
		else if(reagents.total_volume <= volume*0.66)
			. += "<span class='notice'>Наполовину полон!</span>"// We're all optimistic, right?!

		else if(reagents.total_volume <= volume*0.90)
			. += "<span class='notice'>Почти полный!</span>"
		else
			. += "<span class='notice'>Полный!</span>"

////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food/drinks/trophy
	name = "Оловянный кубок"
	desc = "Каждый получит трофей."
	icon_state = "pewter_cup"
	w_class = WEIGHT_CLASS_TINY
	force = 1
	throwforce = 1
	amount_per_transfer_from_this = 5
	materials = list(MAT_METAL=100)
	possible_transfer_amounts = list()
	volume = 5
	flags = CONDUCT
	container_type = OPENCONTAINER
	resistance_flags = FIRE_PROOF

/obj/item/reagent_containers/food/drinks/trophy/gold_cup
	name = "Оолотой кубок"
	desc = "Ты победитель!"
	icon_state = "golden_cup"
	w_class = WEIGHT_CLASS_BULKY
	force = 14
	throwforce = 10
	amount_per_transfer_from_this = 20
	materials = list(MAT_GOLD=1000)
	volume = 150

/obj/item/reagent_containers/food/drinks/trophy/silver_cup
	name = "Серебряный кубок"
	desc = "Лучший неудачник!"
	icon_state = "silver_cup"
	w_class = WEIGHT_CLASS_NORMAL
	force = 10
	throwforce = 8
	amount_per_transfer_from_this = 15
	materials = list(MAT_SILVER=800)
	volume = 100

/obj/item/reagent_containers/food/drinks/trophy/bronze_cup
	name = "Бронзовый кубок"
	desc = "По крайней мере, ты занял место!"
	icon_state = "bronze_cup"
	w_class = WEIGHT_CLASS_SMALL
	force = 5
	throwforce = 4
	amount_per_transfer_from_this = 10
	materials = list(MAT_METAL=400)
	volume = 25


///////////////////////////////////////////////Drinks
//Notes by Darem: Drinks are simply containers that start preloaded. Unlike condiments, the contents can be ingested directly
//	rather then having to add it to something else first. They should only contain liquids. They have a default container size of 50.
//	Formatting is the same as food.


/obj/item/reagent_containers/food/drinks/coffee
	name = "Крепкий Кофе"
	desc = "Осторожно, напиток, которым вы собираетесь насладиться, очень горячий."
	icon_state = "coffee"
	list_reagents = list("coffee" = 30)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/food/drinks/ice
	name = "Чашка со льдом"
	desc = "Осторожно, холодный лед. Не жуй."
	icon_state = "icecup"
	list_reagents = list("ice" = 30)

/obj/item/reagent_containers/food/drinks/tea
	name = "Чай Duke Purple"
	desc = "Оскорбление герцога Пурпурного - это оскорбление Космической Королевы! Любой порядочный джентльмен будет драться с тобой, если ты испортишь этот чай."
	icon_state = "teacup"
	item_state = "coffee"
	list_reagents = list("tea" = 30)

/obj/item/reagent_containers/food/drinks/tea/New()
	..()
	if(prob(20))
		reagents.add_reagent("mugwort", 3)

/obj/item/reagent_containers/food/drinks/mugwort
	name = "Чай из полыни"
	desc = "Горький травяной чай."
	icon_state = "manlydorfglass"
	item_state = "coffee"
	list_reagents = list("mugwort" = 30)

/obj/item/reagent_containers/food/drinks/h_chocolate
	name = "Голландский горячий коко"
	desc = "Сделано в космосе Южной Америки."
	icon_state = "hot_coco"
	item_state = "coffee"
	list_reagents = list("hot_coco" = 30, "sugar" = 5)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/food/drinks/chocolate
	name = "Горячий шоколад"
	desc = "Сделано в космической Швейцарии."
	icon_state = "hot_coco"
	item_state = "coffee"
	list_reagents = list("hot_coco" = 15, "chocolate" = 6, "water" = 9)
	resistance_flags = FREEZE_PROOF

/obj/item/reagent_containers/food/drinks/weightloss
	name = "Коктейль для похудения"
	desc = "Коктейль, предназначенная для снижения веса. Упаковка с гордостью заявляет, что она 'без ленточных червей'."
	icon_state = "weightshake"
	list_reagents = list("lipolicide" = 30, "chocolate" = 5)

/obj/item/reagent_containers/food/drinks/dry_ramen
	name = "Чашка рамена"
	desc = "Просто добавьте 10 мл воды и она самонагреется! Вкус, который напоминает вам о ваших школьных годах."
	icon_state = "ramen"
	item_state = "ramen"
	list_reagents = list("dry_ramen" = 30)

/obj/item/reagent_containers/food/drinks/dry_ramen/New()
	..()
	if(prob(20))
		reagents.add_reagent("enzyme", 3)

/obj/item/reagent_containers/food/drinks/chicken_soup
	name = "Консервированный куриный суп"
	desc = "Вкусная и успокаивающая банка куриного супа с лапшой; точно так же, как мамаша-техник использовала его для микроволновки."
	icon_state = "soupcan"
	item_state = "soupcan"
	list_reagents = list("chicken_soup" = 30)

/obj/item/reagent_containers/food/drinks/sillycup
	name = "Бумажный стаканчик"
	desc = "Бумажный стаканчик с водой."
	icon_state = "water_cup_e"
	item_state = "coffee"
	possible_transfer_amounts = list()
	volume = 10

/obj/item/reagent_containers/food/drinks/sillycup/on_reagent_change()
	if(reagents.total_volume)
		icon_state = "water_cup"
	else
		icon_state = "water_cup_e"

//////////////////////////drinkingglass and shaker//
//Note by Darem: This code handles the mixing of drinks. New drinks go in three places: In Chemistry-Reagents.dm (for the drink
//	itself), in Chemistry-Recipes.dm (for the reaction that changes the components into the drink), and here (for the drinking glass
//	icon states.

/obj/item/reagent_containers/food/drinks/shaker
	name = "Шейкер"
	desc = "Металлический шейкер для смешивания напитков."
	icon_state = "shaker"
	materials = list(MAT_METAL=1500)
	amount_per_transfer_from_this = 10
	volume = 100

/obj/item/reagent_containers/food/drinks/flask
	name = "Фляжка"
	desc = "Каждый хороший космонавт знает, что это хорошая идея - взять с собой пару пинт виски, куда бы они не отправились."
	icon_state = "flask"
	materials = list(MAT_METAL=250)
	volume = 60

/obj/item/reagent_containers/food/drinks/flask/barflask
	name = "Фляжка"
	desc = "Для тех, кто не может побеспокоиться о том, чтобы потусоваться в баре и выпить."
	icon_state = "barflask"

/obj/item/reagent_containers/food/drinks/flask/gold
	name = "Фляжка капитана"
	desc = "Золотая фляжка, принадлежащая капитану."
	icon_state = "flask_gold"
	materials = list(MAT_GOLD=500)

/obj/item/reagent_containers/food/drinks/flask/detflask
	name = "Фляжка детектива"
	desc = "Единственный настоящий друг детектива."
	icon_state = "detflask"
	list_reagents = list("whiskey" = 30)

/obj/item/reagent_containers/food/drinks/flask/hand_made
	name = "Самодельная фляжка"
	desc = "Деревянная фляжка с серебряной крышкой и дном. На нем матовая темно-синяя краска с выгравированными черными инициалами 'W.H.'."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "williamhackett"
	materials = list()

/obj/item/reagent_containers/food/drinks/flask/thermos
	name = "Винтажный термос"
	desc = "Старый термос со тусклым блеском."
	icon_state = "thermos"
	volume = 50

/obj/item/reagent_containers/food/drinks/flask/shiny
	name = "Блестящая фляжка"
	desc = "Блестящая металлическая фляжка. На нем, похоже, начертан греческий символ."
	icon_state = "shinyflask"
	volume = 50

/obj/item/reagent_containers/food/drinks/flask/lithium
	name = "Литиевая фляжка"
	desc = "Фляжка с символом атома лития на ней."
	icon = 'icons/obj/custom_items.dmi'
	icon_state = "lithiumflask"
	volume = 50


/obj/item/reagent_containers/food/drinks/britcup
	name = "Чашка"
	desc = "Чашка с изображенным на ней британским флагом."
	icon_state = "britcup"
	volume = 30

/obj/item/reagent_containers/food/drinks/bag
	name = "Пакет для напитков"
	desc = "Обычно кладут в винные коробки или когда спускают туда."
	icon_state = "goonbag"
	volume = 70

/obj/item/reagent_containers/food/drinks/bag/goonbag
	name = "Пакет для напитков из специального выпуска Blue Toolbox"
	desc = "Самый дешевый винный напиток из известных природе. Вино из под земли, где бродят черти."
	icon_state = "goonbag"
	list_reagents = list("wine" = 70)

/obj/item/reagent_containers/food/drinks/oilcan
	name = "Канистра с маслом"
	desc = "Содержит масло, предназначенное для использования на киборгах, роботах и других синтетах."
	icon = 'icons/goonstation/objects/oil.dmi'
	icon_state = "oilcan"
	volume = 100

/obj/item/reagent_containers/food/drinks/oilcan/full
	list_reagents = list("oil" = 100)
