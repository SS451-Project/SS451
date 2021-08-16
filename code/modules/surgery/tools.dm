/obj/item/retractor
	name = "ретрактор"
	desc = "Оттягивает разные штуки, но лучше не знать какие."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "retractor"
	materials = list(MAT_METAL=6000, MAT_GLASS=3000)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "materials=1;biotech=1"

/obj/item/retractor/augment
	desc = "Микромеханический манипулятор для вытягивания чего-то."
	w_class = WEIGHT_CLASS_TINY
	toolspeed = 0.5

/obj/item/hemostat
	name = "зажим"
	desc = "Ты думаешь, что где-то видел это раньше."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "hemostat"
	materials = list(MAT_METAL=5000, MAT_GLASS=2500)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("атакует", "прищемил")

/obj/item/hemostat/augment
	desc = "Крошечные сервоприводы приводят в действие пару клещей, чтобы остановить кровотечение."
	toolspeed = 0.5

/obj/item/cautery
	name = "термокаутер"
	desc = "Это останавливает кровотечение."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "cautery"
	materials = list(MAT_METAL=2500, MAT_GLASS=750)
	flags = CONDUCT
	w_class = WEIGHT_CLASS_TINY
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("подпалил")

/obj/item/cautery/augment
	desc = "Нагретый элемент, который прижигает раны."
	toolspeed = 0.5

/obj/item/surgicaldrill
	name = "хирургическая дрель"
	desc = "Ты можешь сверлить ею. Врубаешься?"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "drill"
	hitsound = 'sound/weapons/drill.ogg'
	materials = list(MAT_METAL=10000, MAT_GLASS=6000)
	flags = CONDUCT
	force = 15.0
	sharp = 1
	w_class = WEIGHT_CLASS_NORMAL
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("просверлил")

/obj/item/surgicaldrill/suicide_act(mob/user)
	to_chat(viewers(user), pick("<span class='suicide'>[user] нажимает на [src] в [user.p_their()] храме и активирует это! Похоже, что [user.p_theyre()] пытается покончить с собой.</span>",
						"<span class='suicide'>[user] нажимает на [src] в [user.p_their()] сундуке и активирует его! Похоже, что [user.p_theyre()] пытается покончить с собой.</span>"))
	return BRUTELOSS

/obj/item/surgicaldrill/augment
	desc = "Эффективная небольшая электрическая дрель, прилегающая к вашей руке, с притупленными краями, чтобы предотвратить повреждение тканей. Может пронзить небеса, а может и не пронзить."
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

/obj/item/scalpel
	name = "скальпель"
	desc = "Резать, резать и еще раз резать."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "scalpel"
	item_state = "scalpel"
	flags = CONDUCT
	force = 10.0
	sharp = 1
	w_class = WEIGHT_CLASS_TINY
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	materials = list(MAT_METAL=4000, MAT_GLASS=1000)
	origin_tech = "materials=1;biotech=1"
	attack_verb = list("атакует", "полоснул", "пырнул", "резанул", "порвал", "распорол", "нарезал", "сократил")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/scalpel/suicide_act(mob/user)
	to_chat(viewers(user), pick("<span class='suicide'>[user] разрезает [user.p_their()] запястье с помощью [src]! Похоже, что [user.p_theyre()] пытается покончить с собой.</span>",
						"<span class='suicide'>[user] разрезает [user.p_their()] горло с помощью [src]! Похоже, что [user.p_theyre()] пытается покончить с собой.</span>",
						"<span class='suicide'>[user] разрезает [user.p_their()] живот и раскрывает его с помощью [src]! Похоже, что [user.p_theyre()] делает сеппуку.</span>"))
	return BRUTELOSS


/obj/item/scalpel/augment
	desc = "Ультра-острое лезвие, прикрепленное непосредственно к вашей кости для дополнительной точности."
	toolspeed = 0.5

/*
 * Researchable Scalpels
 */
/obj/item/scalpel/laser //parent type
	name = "лазерный скальпель"
	desc = "Скальпель, дополненный направленным лазером."
	icon_state = "scalpel_laser1_on"
	damtype = "fire"
	hitsound = 'sound/weapons/sear.ogg'

/obj/item/scalpel/laser/laser1 //lasers also count as catuarys
	name = "лазерный скальпель"
	desc = "Скальпель, дополненный направленным лазером, для более точной резки без попадания крови в поле. Выглядит простым и может быть улучшено."
	icon_state = "scalpel_laser1_on"
	toolspeed = 0.8

/obj/item/scalpel/laser/laser2
	name = "лазерный скальпель"
	desc = "Скальпель, дополненный направленным лазером, для более точной резки без попадания крови в поле. Выглядит несколько продвинутым."
	icon_state = "scalpel_laser2_on"
	toolspeed = 0.6

/obj/item/scalpel/laser/laser3
	name = "лазерный скальпель"
	desc = "Скальпель, дополненный направленным лазером, для более точной резки без попадания крови в поле. Этот, похоже, является вершиной прецизионных энергетических приборов!"
	icon_state = "scalpel_laser3_on"
	toolspeed = 0.4

/obj/item/scalpel/laser/manager //super tool! Retractor/hemostat
	name = "система управления разрезами"
	desc = "Истинное продолжение тела хирурга, это чудо мгновенно и полностью подготавливает разрез, позволяющий немедленно приступить к терапевтическим этапам."
	icon_state = "scalpel_manager_on"
	toolspeed = 0.2

/obj/item/circular_saw
	name = "циркулярная пила"
	desc = "Для резки в тяжелых условиях."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "saw3"
	hitsound = 'sound/weapons/circsawhit.ogg'
	throwhitsound =  'sound/weapons/pierce.ogg'
	flags = CONDUCT
	force = 15.0
	sharp = 1
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	materials = list(MAT_METAL=10000, MAT_GLASS=6000)
	origin_tech = "biotech=1;combat=1"
	attack_verb = list("атакует", "полоснул", "подпилил", "сократил")

/obj/item/circular_saw/augment
	desc = "Маленькая, но очень быстро вращающаяся пила. Края притуплены, чтобы предотвратить случайные разрезы внутри пациента."
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 0.5

//misc, formerly from code/defines/weapons.dm
/obj/item/bonegel
	name = "костный гель"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	force = 0
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 1.0
	origin_tech = "materials=1;biotech=1"

/obj/item/bonegel/augment
	toolspeed = 0.5

/obj/item/FixOVein
	name = "FixOVein"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "fixovein"
	force = 0
	throwforce = 1.0
	origin_tech = "materials=1;biotech=1"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/FixOVein/augment
	toolspeed = 0.5

/obj/item/bonesetter
	name = "костный сеттер"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone setter"
	force = 8.0
	throwforce = 9.0
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	attack_verb = list("атакует", "попадает", "дубасит")
	origin_tech = "materials=1;biotech=1"

/obj/item/bonesetter/augment
	toolspeed = 0.5

/obj/item/surgical_drapes
	name = "хирургические шторы"
	desc = "Хирургические шторы марки Nanotrasen обеспечивают оптимальную безопасность и контроль за инфекцией."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "surgical_drapes"
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = "biotech=1"
	attack_verb = list("шлёпает")
