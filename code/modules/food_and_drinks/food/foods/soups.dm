
//////////////////////
//		Soups		//
//////////////////////

/obj/item/reagent_containers/food/snacks/meatballsoup
	name = "Суп с фрикадельками"
	desc = "У тебя есть шары, малыш, ШАРЫ!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"
	bitesize = 5
	list_reagents = list("nutriment" = 8, "water" = 5, "vitamin" = 4)
	tastes = list("фрикаделька" = 1)

/obj/item/reagent_containers/food/snacks/slimesoup
	name = "Суп из слизи"
	desc = "Если воды нет, вы можете заменить ее слезами."
	icon_state = "slimesoup"
	filling_color = "#C4DBA0"
	bitesize = 5
	list_reagents = list("nutriment" = 5, "slimejelly" = 5, "water" = 5, "vitamin" = 4)
	tastes = list("слизь" = 1)

/obj/item/reagent_containers/food/snacks/bloodsoup
	name = "Томатный суп"
	desc = "Пахнет медью."
	icon_state = "tomatosoup"
	filling_color = "#FF0000"
	bitesize = 5
	list_reagents = list("nutriment" = 2, "blood" = 10, "water" = 5, "vitamin" = 4)
	tastes = list("железо" = 1)

/obj/item/reagent_containers/food/snacks/clownstears
	name = "Клоунские слезы"
	desc = "Не очень смешно"
	icon_state = "clownstears"
	filling_color = "#C4FBFF"
	bitesize = 5
	list_reagents = list("nutriment" = 4, "banana" = 5, "water" = 5, "vitamin" = 8)
	tastes = list("плохая шутка" = 1)

/obj/item/reagent_containers/food/snacks/vegetablesoup
	name = "Овощной суп"
	desc = "Настоящая веганская еда." //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	bitesize = 5
	list_reagents = list("nutriment" = 8, "water" = 5, "vitamin" = 4)
	tastes = list("овощи" = 1)

/obj/item/reagent_containers/food/snacks/nettlesoup
	name = "Суп из крапивы"
	desc = "Подумать только, ботаник забил бы тебя до смерти одним из таких."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"
	bitesize = 5
	list_reagents = list("nutriment" = 8, "water" = 5, "vitamin" = 4)
	tastes = list("крапива" = 1)

/obj/item/reagent_containers/food/snacks/mysterysoup
	name = "Таинственный суп"
	desc = "Загадка в том, почему ты его не ешь?"
	icon_state = "mysterysoup"
	var/extra_reagent = null
	bitesize = 5
	list_reagents = list("nutriment" = 6)
	tastes = list("хаос" = 1)

/obj/item/reagent_containers/food/snacks/mysterysoup/New()
	..()
	extra_reagent = pick("capsaicin", "frostoil", "omnizine", "banana", "blood", "slimejelly", "toxin", "banana", "carbon", "oculine")
	reagents.add_reagent("[extra_reagent]", 5)

/obj/item/reagent_containers/food/snacks/wishsoup
	name = "Суп из желаний"
	desc = "Я бы хотел, чтобы это был суп."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"
	bitesize = 5
	list_reagents = list("water" = 10)
	tastes = list("желания" = 1)

/obj/item/reagent_containers/food/snacks/wishsoup/New()
	..()
	if(prob(25))
		desc = "Желание сбылось!" // hue
		reagents.add_reagent("nutriment", 9)
		reagents.add_reagent("vitamin", 1)

/obj/item/reagent_containers/food/snacks/tomatosoup
	name = "Томатный суп"
	desc = "Пить это - все равно что быть вампиром! Помидорным..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"
	bitesize = 5
	list_reagents = list("nutriment" = 5, "tomatojuice" = 10, "vitamin" = 3)
	tastes = list("помидоры" = 1)

/obj/item/reagent_containers/food/snacks/misosoup
	name = "Суп мисо"
	desc = "Лучший суп во вселенной! Ням!!!"
	icon_state = "misosoup"
	trash = /obj/item/trash/snack_bowl
	bitesize = 5
	list_reagents = list("nutriment" = 7, "vitamin" = 2)
	tastes = list("мисо" = 1)

/obj/item/reagent_containers/food/snacks/mushroomsoup
	name = "Суп шантрель"
	desc = "Вкусный и сытный грибной суп."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"
	bitesize = 5
	list_reagents = list("nutriment" = 8, "vitamin" = 4)
	tastes = list("грибы" = 1)

/obj/item/reagent_containers/food/snacks/beetsoup
	name = "Свекольный суп"
	desc = "Подожди, как там пишется?.."
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	bitesize = 5
	filling_color = "#FAC9FF"
	list_reagents = list("nutriment" = 7, "vitamin" = 2)
	tastes = list("свекла" = 1)

/obj/item/reagent_containers/food/snacks/beetsoup/New()
	..()
	name = pick("Борсш","Борщ","Борсщ","Боршщ","Борш","Порщ")


//////////////////////
//		Stews		//
//////////////////////

/obj/item/reagent_containers/food/snacks/stew
	name = "Рагу"
	desc = "Вкусное и тёплое рагу. Здоровый и сильный."
	icon_state = "stew"
	filling_color = "#9E673A"
	bitesize = 7
	list_reagents = list("nutriment" = 10, "oculine" = 5, "tomatojuice" = 5, "vitamin" = 5)
	tastes = list("помидор" = 1, "морковь" = 1)

/obj/item/reagent_containers/food/snacks/stewedsoymeat
	name = "Соевое рагу"
	desc = "Даже не вегетарианцам это ПОНРАВИТСЯ!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	list_reagents = list("nutriment" = 8)
	tastes = list("соя" = 1, "овощи" = 1)


//////////////////////
//		Chili		//
//////////////////////

/obj/item/reagent_containers/food/snacks/hotchili
	name = "Острый чили"
	desc = "Техасский Чили с пятью сигналами тревоги!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"
	bitesize = 5
	list_reagents = list("nutriment" = 5, "capsaicin" = 1, "tomatojuice" = 2, "vitamin" = 2)
	tastes = list("острый перец" = 1, "помидоры" = 1)

/obj/item/reagent_containers/food/snacks/coldchili
	name = "Холодный чили"
	desc = "Эта слякоть едва ли похожа на жидкость!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"
	trash = /obj/item/trash/snack_bowl
	bitesize = 5
	list_reagents = list("nutriment" = 5, "frostoil" = 1, "tomatojuice" = 2, "vitamin" = 2)
	tastes = list("помидор" = 1, "мята" = 1)
