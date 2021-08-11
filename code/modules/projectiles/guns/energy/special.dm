// Ion Rifles //
/obj/item/gun/energy/ionrifle
	name = "ионная винтовка"
	desc = "Переносное противоборствующее оружие для мужчин, предназначенное для отключения механических угроз."
	icon_state = "ionrifle"
	item_state = null	//so the human update icon uses the icon_state instead.
	fire_sound = 'sound/weapons/ionrifle.ogg'
	origin_tech = "combat=4;magnets=4"
	w_class = WEIGHT_CLASS_HUGE
	can_holster = FALSE
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	ammo_type = list(/obj/item/ammo_casing/energy/ion)
	ammo_x_offset = 3
	flight_x_offset = 17
	flight_y_offset = 9

/obj/item/gun/energy/ionrifle/emp_act(severity)
	return

/obj/item/gun/energy/ionrifle/carbine
	name = "ионный карабин"
	desc = "МК.II Прототип ионного проектора - это облегченная карабинная версия более крупной ионной винтовки, спроектированная таким образом, чтобы быть эргономичной и эффективной."
	icon_state = "ioncarbine"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = SLOT_BELT
	ammo_x_offset = 2
	flight_x_offset = 18
	flight_y_offset = 11

// Decloner //
/obj/item/gun/energy/decloner
	name = "биологический разрушитель"
	desc = "Пистолет, который разряжает большое количество контролируемого излучения, чтобы медленно развалить цель на составные элементы."
	icon_state = "decloner"
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = "combat=4;materials=4;biotech=5;plasmatech=6"
	ammo_type = list(/obj/item/ammo_casing/energy/declone)
	ammo_x_offset = 1

/obj/item/gun/energy/decloner/update_icon()
	..()
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	if(cell.charge > shot.e_cost)
		overlays += "decloner_spin"

// Flora Gun //
/obj/item/gun/energy/floragun
	name = "цветочный соматорей"
	desc = "Инструмент, который разряжает контролируемое излучение, вызывающее мутации в растительных клетках."
	icon_state = "flora"
	item_state = "gun"
	fire_sound = 'sound/effects/stealthoff.ogg'
	ammo_type = list(/obj/item/ammo_casing/energy/flora/yield, /obj/item/ammo_casing/energy/flora/mut)
	origin_tech = "materials=2;biotech=4"
	modifystate = 1
	ammo_x_offset = 1
	selfcharge = 1

// Meteor Gun //
/obj/item/gun/energy/meteorgun
	name = "метеоритная пушка"
	desc = "Ради любви к Богу, убедитесь, что вы на правильном пути!"
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "riotgun"
	item_state = "c20r"
	fire_sound = 'sound/weapons/gunshots/gunshot_shotgun.ogg'
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/meteor)
	cell_type = /obj/item/stock_parts/cell/potato
	clumsy_check = 0 //Admin spawn only, might as well let clowns use it.
	selfcharge = 1

/obj/item/gun/energy/meteorgun/pen
	name = "метеоритная ручка"
	desc = "Люди говорят: 'Перо сильнее меча!' "
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY

// Mind Flayer //
/obj/item/gun/energy/mindflayer
	name = "неподобающий Пожиратель Разума"
	desc = "Прототип оружия, найденный в руинах исследовательской станции Эпсилон."
	icon_state = "xray"
	item_state = null
	ammo_type = list(/obj/item/ammo_casing/energy/mindflayer)
	ammo_x_offset = 2

// Energy Crossbows //
/obj/item/gun/energy/kinetic_accelerator/crossbow
	name = "мини-энергетический арбалет"
	desc = "Оружие, излюбленное специалистами Cиндиката по скрытности."
	icon_state = "crossbow"
	item_state = "crossbow"
	w_class = WEIGHT_CLASS_SMALL
	materials = list(MAT_METAL=2000)
	origin_tech = "combat=4;magnets=4;syndicate=4"
	suppressed = 1
	ammo_type = list(/obj/item/ammo_casing/energy/bolt)
	weapon_weight = WEAPON_LIGHT
	unique_rename = 0
	overheat_time = 20
	holds_charge = TRUE
	unique_frequency = TRUE
	can_flashlight = 0
	max_mod_capacity = 0
	empty_state = null

/obj/item/gun/energy/kinetic_accelerator/crossbow/large
	name = "энергетический арбалет"
	desc = "Оружие обратной разработки с использованием технологии Cиндиката."
	icon_state = "crossbowlarge"
	w_class = WEIGHT_CLASS_NORMAL
	materials = list(MAT_METAL=4000)
	origin_tech = "combat=4;magnets=4;syndicate=2"
	suppressed = 0
	ammo_type = list(/obj/item/ammo_casing/energy/bolt/large)

/obj/item/gun/energy/kinetic_accelerator/crossbow/large/cyborg
	desc = "Раз и готово!"
	icon_state = "crossbowlarge"
	origin_tech = null
	materials = list()

/obj/item/gun/energy/kinetic_accelerator/suicide_act(mob/user)
	if(!suppressed)
		playsound(loc, 'sound/weapons/kenetic_reload.ogg', 60, 1)
	user.visible_message("<span class='suicide'>[user] вводит [name] и делает вид, что вышибает мозги [user.p_their()]! Похоже, что [user.p_theyre()] пытается покончить с собой!</b></span>")
	shoot_live_shot(user, user, FALSE, FALSE)
	return OXYLOSS

// Plasma Cutters //
/obj/item/gun/energy/plasmacutter
	name = "плазменный резак"
	desc = "Инструмент для добычи полезных ископаемых, способный выбрасывать концентрированные всплески плазмы. Ты мог бы использовать его, чтобы отрезать конечности ксеносам! Ну, или добывать разные штуки."
	icon_state = "plasmacutter"
	item_state = "plasmacutter"
	modifystate = -1
	origin_tech = "combat=1;materials=3;magnets=2;plasmatech=3;engineering=1"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma)
	fire_sound = 'sound/weapons/laser.ogg'
	usesound = 'sound/items/welder.ogg'
	toolspeed = 1
	container_type = OPENCONTAINER
	flags = CONDUCT
	attack_verb = list("атакует", "порезал", "подрезал", "нарезал")
	force = 12
	sharp = 1
	can_charge = 0

/obj/item/gun/energy/plasmacutter/examine(mob/user)
	. = ..()
	if(cell)
		. += "<span class='notice'>[src] заряжен на [round(cell.percent())]%.</span>"

/obj/item/gun/energy/plasmacutter/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/stack/sheet/mineral/plasma))
		if(cell.charge >= cell.maxcharge)
			to_chat(user,"<span class='notice'>[src] полностью заряжен.")
			return
		var/obj/item/stack/sheet/S = A
		S.use(1)
		cell.give(1000)
		on_recharge()
		to_chat(user, "<span class='notice'>Вы поставили [A] в [src] на подзарядку.</span>")
	else if(istype(A, /obj/item/stack/ore/plasma))
		if(cell.charge >= cell.maxcharge)
			to_chat(user,"<span class='notice'>[src] уже заряжен.")
			return
		var/obj/item/stack/ore/S = A
		S.use(1)
		cell.give(500)
		on_recharge()
		to_chat(user, "<span class='notice'>Вы поставили [A] в [src] на зарядку.</span>")
	else
		return ..()

/obj/item/gun/energy/plasmacutter/update_icon()
	return

/obj/item/gun/energy/plasmacutter/adv
	name = "усовершенствованный плазменный резак"
	icon_state = "adv_plasmacutter"
	modifystate = "adv_plasmacutter"
	origin_tech = "combat=3;materials=4;magnets=3;plasmatech=4;engineering=2"
	ammo_type = list(/obj/item/ammo_casing/energy/plasma/adv)
	force = 15

// Wormhole Projectors //
/obj/item/gun/energy/wormhole_projector
	name = "проектор червоточины Bluespace"
	desc = "Проектор, излучающий пучки Bluespace с квантовой связью высокой плотности."
	ammo_type = list(/obj/item/ammo_casing/energy/wormhole, /obj/item/ammo_casing/energy/wormhole/orange)
	item_state = null
	icon_state = "wormhole_projector1"
	origin_tech = "combat=4;bluespace=6;plasmatech=4;engineering=4"
	charge_delay = 5
	selfcharge = TRUE
	var/obj/effect/portal/blue
	var/obj/effect/portal/orange


/obj/item/gun/energy/wormhole_projector/update_icon()
	icon_state = "wormhole_projector[select]"
	item_state = icon_state
	return

/obj/item/gun/energy/wormhole_projector/process_chamber()
	..()
	select_fire(usr)

/obj/item/gun/energy/wormhole_projector/portal_destroyed(obj/effect/portal/P)
	if(P.icon_state == "portal")
		blue = null
		if(orange)
			orange.target = null
	else
		orange = null
		if(blue)
			blue.target = null

/obj/item/gun/energy/wormhole_projector/proc/create_portal(obj/item/projectile/beam/wormhole/W)
	var/obj/effect/portal/P = new /obj/effect/portal(get_turf(W), null, src)
	P.precision = 0
	P.failchance = 0
	P.can_multitool_to_remove = 1
	if(W.name == "bluespace beam")
		qdel(blue)
		blue = P
	else
		qdel(orange)
		P.icon_state = "portal1"
		orange = P
	if(orange && blue)
		blue.target = get_turf(orange)
		orange.target = get_turf(blue)

/* 3d printer 'pseudo guns' for borgs */
/obj/item/gun/energy/printer
	name = "ручной пулемёт киборга"
	desc = "Пулемет, стреляющий 3D-печатными шашками. Медленно регенерируется с помощью внутреннего источника питания киборга."
	icon_state = "l6closed0"
	icon = 'icons/obj/guns/projectile.dmi'
	cell_type = /obj/item/stock_parts/cell/secborg
	ammo_type = list(/obj/item/ammo_casing/energy/c3dbullet)
	can_charge = 0

/obj/item/gun/energy/printer/update_icon()
	return

/obj/item/gun/energy/printer/emp_act()
	return

// Instakill Lasers //
/obj/item/gun/energy/laser/instakill
	name = "винтовка Instakill"
	icon_state = "instagib"
	item_state = "instagib"
	desc = "Специализированная лазерная винтовка ASMD типа, способная уничтожать большинство целей одним попаданием."
	ammo_type = list(/obj/item/ammo_casing/energy/instakill)
	force = 60
	origin_tech = "combat=7;magnets=6"

/obj/item/gun/energy/laser/instakill/emp_act() //implying you could stop the instagib
	return

/obj/item/gun/energy/laser/instakill/red
	desc = "Специализированная лазерная винтовка ASMD типа, способная уничтожать большинство целей одним попаданием. У этого же - красный дизайн. Круть."
	icon_state = "instagibred"
	item_state = "instagibred"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/red)

/obj/item/gun/energy/laser/instakill/blue
	desc = "Специализированная лазерная винтовка ASMD, способная уничтожать большинство целей одним попаданием. У этого же - синий дизайн. Неплохо."
	icon_state = "instagibblue"
	item_state = "instagibblue"
	ammo_type = list(/obj/item/ammo_casing/energy/instakill/blue)

// HONK Rifle //
/obj/item/gun/energy/clown
	name = "HONK винтовка"
	desc = "Планета Клоунов - самая лучшая."
	icon_state = "disabler"
	ammo_type = list(/obj/item/ammo_casing/energy/clown)
	clumsy_check = 0
	selfcharge = 1
	ammo_x_offset = 3

/obj/item/gun/energy/toxgun
	name = "плазменный пистолет"
	desc = "Специализированное огнестрельное оружие, предназначенное для стрельбы смертоносными зарядами токсинов."
	icon_state = "toxgun"
	fire_sound = 'sound/effects/stealthoff.ogg'

	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "combat=4;magnets=4;powerstorage=3"
	ammo_type = list(/obj/item/ammo_casing/energy/toxplasma)
	shaded_charge = 1

// Energy Sniper //
/obj/item/gun/energy/sniperrifle
	name = "снайперская винтовка L.W.A.P."
	desc = "Винтовка, изготовленная из легких материалов и оснащенная технологией SMART для лёгкого прицеливания."
	icon_state = "esniper"
	origin_tech = "combat=6;materials=5;powerstorage=4"
	ammo_type = list(/obj/item/ammo_casing/energy/sniper)
	item_state = null
	weapon_weight = WEAPON_HEAVY
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	can_holster = FALSE
	zoomable = TRUE
	zoom_amt = 7 //Long range, enough to see in front of you, but no tiles behind you.
	shaded_charge = 1

// Temperature Gun //
/obj/item/gun/energy/temperature
	name = "температурный пистолет"
	icon = 'icons/obj/guns/gun_temperature.dmi'
	icon_state = "tempgun_4"
	item_state = "tempgun_4"
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	fire_sound = 'sound/weapons/pulse3.ogg'
	desc = "Пистолет, который изменяет температуру тела своих целей."
	var/temperature = 300
	var/target_temperature = 300
	origin_tech = "combat=4;materials=4;powerstorage=3;magnets=2"

	ammo_type = list(/obj/item/ammo_casing/energy/temp)
	selfcharge = 1

	var/powercost = ""
	var/powercostcolor = ""

	var/emagged = 0			//ups the temperature cap from 500 to 1000, targets hit by beams over 500 Kelvin will burst into flames
	var/dat = ""

/obj/item/gun/energy/temperature/Initialize(mapload, ...)
	. = ..()
	update_icon()
	START_PROCESSING(SSobj, src)


/obj/item/gun/energy/temperature/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/energy/temperature/newshot()
	..()

/obj/item/gun/energy/temperature/attack_self(mob/living/user as mob)
	user.set_machine(src)
	update_dat()
	user << browse({"<meta charset="UTF-8"><TITLE>Конфигурация Температурного Пистолета</TITLE><HR>[dat]"}, "window=tempgun;size=510x120")
	onclose(user, "tempgun")

/obj/item/gun/energy/temperature/emag_act(mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, "<span class='caution'>Ты удваиваешь температурное ограничение пистолета! Цели, пораженные обжигающими лучами, вспыхнут пламенем!</span>")
		desc = "Пистолет, который изменяет температуру тела своих целей. Его температурный ограничитель был взломан."

/obj/item/gun/energy/temperature/Topic(href, href_list)
	if(..())
		return
	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["temp"])
		var/amount = text2num(href_list["temp"])
		if(amount > 0)
			target_temperature = min((500 + 500*emagged), target_temperature+amount)
		else
			target_temperature = max(0, target_temperature+amount)
	if(istype(loc, /mob))
		attack_self(loc)
	add_fingerprint(usr)
	return

/obj/item/gun/energy/temperature/process()
	..()
	var/obj/item/ammo_casing/energy/temp/T = ammo_type[select]
	T.temp = temperature
	switch(temperature)
		if(0 to 100)
			T.e_cost = 300
			powercost = "Высокое"
		if(100 to 250)
			T.e_cost = 200
			powercost = "Среднее"
		if(251 to 300)
			T.e_cost = 100
			powercost = "Низкое"
		if(301 to 400)
			T.e_cost = 200
			powercost = "Среднее"
		if(401 to 1000)
			T.e_cost = 300
			powercost = "Высокое"
	switch(powercost)
		if("Высокое")
			powercostcolor = "orange"
		if("Среднее")
			powercostcolor = "green"
		else
			powercostcolor = "blue"
	if(target_temperature != temperature)
		var/difference = abs(target_temperature - temperature)
		if(difference >= (10 + 40*emagged)) //so emagged temp guns adjust their temperature much more quickly
			if(target_temperature < temperature)
				temperature -= (10 + 40*emagged)
			else
				temperature += (10 + 40*emagged)
		else
			temperature = target_temperature
		update_icon()

		if(istype(loc, /mob/living/carbon))
			var/mob/living/carbon/M = loc
			if(src == M.machine)
				update_dat()
				M << browse("<TITLE>Конфигурация Температурного Пистолета</TITLE><HR>[dat]", "window=tempgun;size=510x102")
	return

/obj/item/gun/energy/temperature/proc/update_dat()
	dat = ""
	dat += "Текущая выходная температура: "
	if(temperature > 500)
		dat += "<FONT color=red><B>[temperature]</B> ([round(temperature-T0C)]&deg;C)</FONT>"
		dat += "<FONT color=red><B> ОБЖИГАЕТ!</B></FONT>"
	else if(temperature > (T0C + 50))
		dat += "<FONT color=red><B>[temperature]</B> ([round(temperature-T0C)]&deg;C)</FONT>"
	else if(temperature > (T0C - 50))
		dat += "<FONT color=black><B>[temperature]</B> ([round(temperature-T0C)]&deg;C)</FONT>"
	else
		dat += "<FONT color=blue><B>[temperature]</B> ([round(temperature-T0C)]&deg;C)</FONT>"
	dat += "<BR>"
	dat += "Целевая выходная температура: "	//might be string idiocy, but at least it's easy to read
	dat += "<A href='?src=[UID()];temp=-100'>-</A> "
	dat += "<A href='?src=[UID()];temp=-10'>-</A> "
	dat += "<A href='?src=[UID()];temp=-1'>-</A> "
	dat += "[target_temperature] "
	dat += "<A href='?src=[UID()];temp=1'>+</A> "
	dat += "<A href='?src=[UID()];temp=10'>+</A> "
	dat += "<A href='?src=[UID()];temp=100'>+</A>"
	dat += "<BR>"
	dat += "Энергозатратность: "
	dat += "<FONT color=[powercostcolor]><B>[powercost]</B></FONT>"

/obj/item/gun/energy/temperature/proc/update_temperature()
	switch(temperature)
		if(501 to INFINITY)
			item_state = "tempgun_8"
		if(400 to 500)
			item_state = "tempgun_7"
		if(360 to 400)
			item_state = "tempgun_6"
		if(335 to 360)
			item_state = "tempgun_5"
		if(295 to 335)
			item_state = "tempgun_4"
		if(260 to 295)
			item_state = "tempgun_3"
		if(200 to 260)
			item_state = "tempgun_2"
		if(120 to 260)
			item_state = "tempgun_1"
		if(-INFINITY to 120)
			item_state = "tempgun_0"
	icon_state = item_state

/obj/item/gun/energy/temperature/update_icon()
	overlays = 0
	update_temperature()
	update_user()
	update_charge()

/obj/item/gun/energy/temperature/proc/update_user()
	if(istype(loc,/mob/living/carbon))
		var/mob/living/carbon/M = loc
		M.update_inv_back()
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/gun/energy/temperature/proc/update_charge()
	var/charge = cell.charge
	switch(charge)
		if(900 to INFINITY)		overlays += "900"
		if(800 to 900)			overlays += "800"
		if(700 to 800)			overlays += "700"
		if(600 to 700)			overlays += "600"
		if(500 to 600)			overlays += "500"
		if(400 to 500)			overlays += "400"
		if(300 to 400)			overlays += "300"
		if(200 to 300)			overlays += "200"
		if(100 to 202)			overlays += "100"
		if(-INFINITY to 100)	overlays += "0"

// Mimic Gun //
/obj/item/gun/energy/mimicgun
	name = "имитирующее оружие"
	desc = "Оружие самообороны, которое истощает органические цели, ослабляя их до тех пор, пока они не разрушатся. Почему у него есть зубы?"
	icon_state = "disabler"
	ammo_type = list(/obj/item/ammo_casing/energy/mimic)
	clumsy_check = 0 //Admin spawn only, might as well let clowns use it.
	selfcharge = 1
	ammo_x_offset = 3
	var/mimic_type = /obj/item/gun/projectile/automatic/pistol //Setting this to the mimicgun type does exactly what you think it will.

/obj/item/gun/energy/mimicgun/newshot()
	var/obj/item/ammo_casing/energy/mimic/M = ammo_type[select]
	M.mimic_type = mimic_type
	..()

// Sibyl System's Dominator //
/obj/item/gun/energy/dominator
	name = "доминатор"
	desc = "Проприетарное высокотехнологичное оружие правоохранительной организации Sibyl System, произведённое специально для борьбы с преступностью."
	icon = 'icons/obj/guns/sibyl.dmi'
	icon_state = "dominator"
	item_state = null

	w_class = WEIGHT_CLASS_SMALL
	slot_flags = SLOT_BELT
	force = 10
	flags =  CONDUCT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	origin_tech = "combat=6;magnets=5"

	ammo_type = list(/obj/item/ammo_casing/energy/dominator/stun, /obj/item/ammo_casing/energy/dominator/paralyzer, /obj/item/ammo_casing/energy/dominator/eliminator, /obj/item/ammo_casing/energy/dominator/slaughter)
	var/sound_voice = list(null, 'sound/voice/dominator/nonlethal-paralyzer.ogg','sound/voice/dominator/lethal-eliminator.ogg','sound/voice/dominator/execution-slaughter.ogg')
	cell_type = /obj/item/stock_parts/cell/dominator
	can_charge = TRUE
	charge_sections = 3

	can_flashlight = TRUE
	flight_x_offset = 27
	flight_y_offset = 12

	var/is_equipped = FALSE
	var/is_sibylmod = TRUE

/obj/item/gun/energy/dominator/New()
	..()
	if(is_sibylmod)
		var/obj/item/sibyl_system_mod/M = new /obj/item/sibyl_system_mod
		M.install(src)

/obj/item/gun/energy/dominator/select_fire(mob/living/user)
	..()
	if(sibyl_mod)
		var/temp_select = select
		spawn(20)
			if(!isnull(sound_voice[select]) && select == temp_select && sibyl_mod.voice_is_enabled)
				user << sound(sound_voice[select], volume=50, wait=TRUE, channel=CHANNEL_SIBYL_SYSTEM)
	return

/obj/item/gun/energy/dominator/update_icon()
	if(isnull(cell))
		set_drop_icon()
		return

	overlays.Cut()
	var/ratio = CEILING((cell.charge / cell.maxcharge) * charge_sections, 1)
	var/obj/item/ammo_casing/energy/shot = ammo_type[select]
	var/shot_name = shot.alt_select_name
	var/iconState = initial(icon_state)

	if(cell.charge < shot.e_cost)
		icon_state = "empty"
		item_state = "[iconState]_empty"
	else
		item_state = "[iconState][shot_name]"
		if(!is_equipped && is_equipped != ismob(loc))
			spawn(1)
				for(var/i = 1, i <= ratio, i++)
					if(!ismob(loc))
						break
					icon_state = "[ammo_type[select].alt_select_name][i]"
					sleep(1)
		else if(is_equipped && is_equipped != ismob(loc))
			spawn(2)
				for(var/i = ratio, i >= 0, i--)
					if(ismob(loc))
						break
					if(i)
						icon_state = "[ammo_type[select].alt_select_name][i]"
					else
						set_drop_icon()
					sleep(1)
		else if(!is_equipped && is_equipped == ismob(loc))
			set_drop_icon()
		else
			icon_state = "[shot_name][ratio]"
	if(gun_light && can_flashlight)
		var/iconF = "flight"
		if(gun_light.on)
			iconF = "flight_on"
		overlays += image(icon = icon, icon_state = iconF, pixel_x = flight_x_offset, pixel_y = flight_y_offset)
	is_equipped = ismob(loc)
	return

/obj/item/gun/energy/dominator/equipped(mob/user)
	. = ..()
	update_icon()
	return .

/obj/item/gun/energy/dominator/dropped(mob/user)
	. = ..()
	update_icon()
	return .

/obj/item/gun/energy/dominator/proc/set_drop_icon()
	icon_state = initial(icon_state)
	if(sibyl_mod)
		if(sibyl_mod.lock)
			icon_state += "_lock"
		else
			icon_state += "_unlock"

/obj/item/gun/energy/dominator/no_sibyl
	is_sibylmod = FALSE
