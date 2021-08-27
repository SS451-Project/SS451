//ALCOHOL WOO
/datum/reagent/consumable/ethanol
	name = "Этанол" //Parent class for all alcoholic reagents.
	id = "ethanol"
	description = "Хорошо известный алкоголь с множеством применений."
	reagent_state = LIQUID
	nutriment_factor = 0 //So alcohol can fill you up! If they want to.
	color = "#404030" // rgb: 64, 64, 48
	var/dizzy_adj = 3
	var/alcohol_perc = 1 //percentage of ethanol in a beverage 0.0 - 1.0
	taste_description = "жидкое пламя"

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/M)
	M.AdjustDrunk(alcohol_perc)
	M.AdjustDizzy(dizzy_adj)
	return ..()

/datum/reagent/consumable/ethanol/reaction_obj(obj/O, volume)
	if(istype(O,/obj/item/paper))
		if(istype(O,/obj/item/paper/contract/infernal))
			O.visible_message("<span class='warning'>Раствор воспламеняется при контакте с [O].</span>")
		else
			var/obj/item/paper/paperaffected = O
			paperaffected.clearpaper()
			paperaffected.visible_message("<span class='notice'>Раствор выжигает чернила на бумаге.</span>")
	if(istype(O,/obj/item/book))
		if(volume >= 5)
			var/obj/item/book/affectedbook = O
			affectedbook.dat = null
			affectedbook.visible_message("<span class='notice'>Раствор растворяет чернила на книге.</span>")
		else
			O.visible_message("<span class='warning'>Этого было недостаточно...</span>")

/datum/reagent/consumable/ethanol/reaction_mob(mob/living/M, method=REAGENT_TOUCH, volume)//Splashing people with ethanol isn't quite as good as fuel.
	if(method == REAGENT_TOUCH)
		M.adjust_fire_stacks(volume / 15)


/datum/reagent/consumable/ethanol/beer
	name = "Пиво"
	id = "beer"
	description = "Алкогольный напиток, приготовленный из солодового зерна, хмеля, дрожжей и воды."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon ="beerglass"
	drink_name = "Бокал пива"
	drink_desc = "Пинта холодного пива"
	taste_description = "пиво"

/datum/reagent/consumable/ethanol/cider
	name = "Сидр"
	id = "cider"
	description = "Алкогольный напиток, полученный из яблок."
	color = "#174116"
	nutriment_factor = 1 * REAGENTS_METABOLISM
	alcohol_perc = 0.2
	drink_icon = "rewriter"
	drink_name = "Сидр"
	drink_desc = "Освежающий бокал традиционного сидра."
	taste_description = "сидр"

/datum/reagent/consumable/ethanol/whiskey
	name = "Виски"
	id = "whiskey"
	description = "Превосходный и хорошо выдержанный односолодовый виски. Ёпт."
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 4
	alcohol_perc = 0.4
	drink_icon = "whiskeyglass"
	drink_name = "Стакан виски"
	drink_desc = "Шелковистое, дымчатое виски внутри стакана придает напитку очень стильный вид."
	taste_description = "виски"

/datum/reagent/consumable/ethanol/specialwhiskey
	name = "Особая смесь виски"
	id = "specialwhiskey"
	description = "Как раз тогда, когда ты думал, что обычный станционный виски - это хорошо... Эта шелковистая, янтарная доброта должна прийти и все испортить."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	taste_description = "класс"

/datum/reagent/consumable/ethanol/gin
	name = "Джин"
	id = "gin"
	description = "Это джин. В космосе."
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 3
	alcohol_perc = 0.5
	drink_icon = "ginvodkaglass"
	drink_name = "Стакан джина"
	drink_desc = "Кристально чистый бокал джина 'Гриффитер'."
	taste_description = "джин"

/datum/reagent/consumable/ethanol/absinthe
	name = "Абсент"
	id = "absinthe"
	description = "Смотри, чтобы Зеленая Фея не пришла за тобой!"
	color = "#33EE00" // rgb: lots, ??, ??
	overdose_threshold = 30
	dizzy_adj = 5
	alcohol_perc = 0.7
	drink_icon = "absinthebottle"
	drink_name = "Стакан абсента"
	drink_desc = "Зеленая фея доберется до тебя!"
	taste_description = "ебучая боль"

//copy paste from LSD... shoot me
/datum/reagent/consumable/ethanol/absinthe/on_mob_life(mob/living/M)
	M.AdjustHallucinate(5)
	return ..()

/datum/reagent/consumable/ethanol/absinthe/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustToxLoss(1, FALSE)
	return list(0, update_flags)

/datum/reagent/consumable/ethanol/hooch
	name = "Самогон"
	id = "hooch"
	description = "Либо чья-то неудача в приготовлении коктейлей, либо попытка в производстве алкоголя. В любом случае, ты действительно хочешь это выпить?"
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 7
	alcohol_perc = 1
	drink_icon = "glass_brown2"
	drink_name = "Самогон"
	drink_desc = "Теперь ты действительно достиг дна... Твоя печень собрала свои вещи и ушла прошлой ночью."
	taste_description = "чистая покорность"

/datum/reagent/consumable/ethanol/hooch/on_mob_life(mob/living/carbon/M)
	if(M.mind && M.mind.assigned_role == "Assistant")
		M.heal_organ_damage(1, 1)
		. = 1
	return ..() || .

/datum/reagent/consumable/ethanol/rum
	name = "Ром"
	id = "rum"
	description = "Популярен среди моряков. Не очень популярен у остальных."
	color = "#664300" // rgb: 102, 67, 0
	overdose_threshold = 30
	alcohol_perc = 0.4
	dizzy_adj = 5
	drink_icon = "rumglass"
	drink_name = "Стакан рома"
	drink_desc = "Теперь ты хочешь помолиться о пиратском костюме, не так ли?"
	taste_description = "ром"

/datum/reagent/consumable/ethanol/rum/overdose_process(mob/living/M, severity)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.adjustToxLoss(1, FALSE)
	return list(0, update_flags)

/datum/reagent/consumable/ethanol/mojito
	name = "Мохито"
	id = "mojito"
	description = "Если он достаточно хорош для Spesscuba, то он достаточно хорош и для вас."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "mojito"
	drink_name = "Бокал Мохито"
	drink_desc = "Свежак из Spesscuba."
	taste_description = "мохито"

/datum/reagent/consumable/ethanol/vodka
	name = "Водка"
	id = "vodka"
	description = "Напиток номер один и выбор топлива для Русских всего мира."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "ginvodkaglass"
	drink_name = "Стакан водки"
	drink_desc = "Стакан водки. Хуита."
	taste_description = "сука блять"

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/M)
	..()
	if(prob(50))
		M.radiation = max(0, M.radiation-1)

/datum/reagent/consumable/ethanol/sake
	name = "Сакэ"
	id = "sake"
	description = "Любимый напиток из аниме."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "sake"
	drink_name = "Стакан сакэ"
	drink_desc = "Стакан сакэ."
	taste_description = "сакэ"

/datum/reagent/consumable/ethanol/tequila
	name = "Текила"
	id = "tequila"
	description = "Крепкий и слегка ароматизированный мексиканский спирт. Чувствуешь жажду, хомбре?"
	color = "#A8B0B7" // rgb: 168, 176, 183
	alcohol_perc = 0.4
	drink_icon = "tequilaglass"
	drink_name = "Стакан текилы"
	drink_desc = "Теперь все, чего не хватает - это странных цветных оттенков!"
	taste_description = "текила"

/datum/reagent/consumable/ethanol/vermouth
	name = "Вермут"
	id = "vermouth"
	description = "Вы вдруг чувствуете страстное желание выпить мартини..."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "vermouthglass"
	drink_name = "Стакан вермута"
	drink_desc = "Ты удивляешься, почему ты вообще пьешь это так прямо."
	taste_description = "вермут"

/datum/reagent/consumable/ethanol/wine
	name = "Вино"
	id = "wine"
	description = "Алкогольный напиток премиум-класса, приготовленный из дистиллированного виноградного сока."
	color = "#7E4043" // rgb: 126, 64, 67
	dizzy_adj = 2
	alcohol_perc = 0.2
	drink_icon = "wineglass"
	drink_name = "Стакан вина"
	drink_desc = "Очень классно выглядящий напиток."
	taste_description = "вино"

/datum/reagent/consumable/ethanol/cognac
	name = "Коньяк"
	id = "cognac"
	description = "Сладкий и крепкий алкогольный напиток, приготовленный после многочисленных дистилляций и многолетнего созревания. Классный, как блуд."
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 4
	alcohol_perc = 0.4
	drink_icon = "cognacglass"
	drink_name = "Коньяк"
	drink_desc = "Черт, ты чувствуешь себя каким-то французским аристократом, просто держа это в руках."
	taste_description = "коньяк"

/datum/reagent/consumable/ethanol/suicider //otherwise known as "I want to get so smashed my liver gives out and I die from alcohol poisoning".
	name = "Suicider"
	id = "suicider"
	description = "Невероятно крепкий и мощный сорт сидра."
	color = "#CF3811"
	dizzy_adj = 20
	alcohol_perc = 1 //because that's a thing it's supposed to do, I guess
	drink_icon = "suicider"
	drink_name = "Suicider"
	drink_desc = "Теперь ты действительно достиг дна... Твоя печень собрала свои вещи и ушла прошлой ночью."
	taste_description = "приближающаяся смерть"

/datum/reagent/consumable/ethanol/ale
	name = "Эль"
	id = "ale"
	description = "Темный алкогольный напиток, приготовленный из солодового ячменя и дрожжей."
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.1
	drink_icon = "aleglass"
	drink_name = "Стакан эля"
	drink_desc = "Пинта ледяного восхитительного эля."
	taste_description = "эль"

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "Мощная смесь кофеина и алкоголя."
	reagent_state = LIQUID
	color = "#102000" // rgb: 16, 32, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	alcohol_perc = 0.3
	heart_rate_increase = 1
	drink_icon = "thirteen_loko_glass"
	drink_name = "Thirteen Loko"
	drink_desc = "Это бокал Тринадцатого Локо, он, похоже, самого высокого качества. Напиток, а не бокал"
	taste_description = "вечеринка"

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	M.AdjustDrowsy(-7)
	update_flags |= M.AdjustSleeping(-2, FALSE)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	return ..() | update_flags


/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////

/datum/reagent/consumable/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "Похоже, это пиво, смешанное с молоком. Отвратительно."
	reagent_state = LIQUID
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2 * REAGENTS_METABOLISM
	alcohol_perc = 0.2
	drink_icon = "glass_brown"
	drink_name = "Bilk"
	drink_desc = "Варево из молока и пива. Для тех алкоголиков, которые боятся остеопороза."
	taste_description = "билк"

/datum/reagent/consumable/ethanol/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Ядерное распространение никогда не было таким приятным на вкус."
	reagent_state = LIQUID
	color = "#666300" // rgb: 102, 99, 0
	alcohol_perc = 0.2
	drink_icon = "atomicbombglass"
	drink_name = "Atomic Bomb"
	drink_desc = "Nanotrasen не может нести юридическую ответственность за ваши действия после приема."
	taste_description = "долгий, огненный ожог"

/datum/reagent/consumable/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Создан для женщины, достаточно крепкий для мужчины."
	reagent_state = LIQUID
	color = "#666340" // rgb: 102, 99, 64
	alcohol_perc = 0.2
	drink_icon = "threemileislandglass"
	drink_name = "Three Mile Island Ice Tea"
	drink_desc = "Стакан этого напитка наверняка предотвратит расплавление."
	taste_description = "ползучая жара"

/datum/reagent/consumable/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100%-ный шнапс с корицей, приготовленный для девочек-подростков-алкоголиков на весенних каникулах."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "ginvodkaglass"
	drink_name = "Goldschlager"
	drink_desc = "100%-ное доказательств того, что девочки-подростки будут пить все, в чем есть золото."
	taste_description = "глубокое, пряное тепло"

/datum/reagent/consumable/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Текила с серебром, любимая алкоголичками на клубной сцене."
	reagent_state = LIQUID
	color = "#585840" // rgb: 88, 88, 64
	alcohol_perc = 0.4
	drink_icon = "patronglass"
	drink_name = "Patron"
	drink_desc = "Пьющий Патрон в баре, со всеми неполноценными дамами."
	taste_description = "подарок"

/datum/reagent/consumable/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "Классический, мягкий коктейль всех времен."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "gintonicglass"
	drink_name = "Gin and Tonic"
	drink_desc = "Мягкий, но все равно отличный коктейль. Пей, как настоящий англичанин."
	taste_description = "горькое лекарство"

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Ром, смешанный с колой. Viva la revolution."
	reagent_state = LIQUID
	color = "#3E1B00" // rgb: 62, 27, 0
	alcohol_perc = 0.2
	drink_icon = "cubalibreglass"
	drink_name = "Cuba Libre"
	drink_desc = "Классическая смесь рома и колы."
	taste_description = "освобождение"

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Виски, смешанный с колой. Удивительно освежающе."
	reagent_state = LIQUID
	color = "#3E1B00" // rgb: 62, 27, 0
	alcohol_perc = 0.3
	drink_icon = "whiskeycolaglass"
	drink_name = "Whiskey Cola"
	drink_desc = "Невинная на вид смесь колы и виски. Восхитительно."
	taste_description = "виски с колой"

/datum/reagent/consumable/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Вермут с джином. Не совсем так, как 007 понравилось, но все равно вкусно."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "martiniglass"
	drink_name = "Classic Martini"
	drink_desc = "Охуеть, бармен даже помешал его, а не встряхнул."
	taste_description = "класс"

/datum/reagent/consumable/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Водка с джином. Не совсем так, как 007 понравилось, но все равно вкусно."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "martiniglass"
	drink_name = "Vodka Martini"
	drink_desc ="Ублюдочная версия классического мартини. Все равно здорово."
	taste_description = "сорт и картофель"

/datum/reagent/consumable/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "Это просто, типа твое мнение, чувак..."
	reagent_state = LIQUID
	color = "#A68340" // rgb: 166, 131, 64
	alcohol_perc = 0.3
	drink_icon = "whiterussianglass"
	drink_name = "White Russian"
	drink_desc = "Белый Русский - очень приятный на вид напиток. Но это просто, типа твое мнение, чувак."
	taste_description = "очень сливочный алкоголь"

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Водка, смешанная с обычным апельсиновым соком. Результат на удивление вкусный."
	reagent_state = LIQUID
	color = "#A68310" // rgb: 166, 131, 16
	alcohol_perc = 0.3
	drink_icon = "screwdriverglass"
	drink_name = "Screwdriver"
	drink_desc = "Отвёртка - простая, но превосходная смесь водки и апельсинового сока. Как раз то, что нужно уставшему инженеру."
	taste_description = "непристойный секрет"

/datum/reagent/consumable/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Фу..."
	reagent_state = LIQUID
	color = "#A68310" // rgb: 166, 131, 16
	alcohol_perc = 0.2
	drink_icon = "booger"
	drink_name = "Booger"
	drink_desc = "Фу, 'Козявка'..."
	taste_description = "фруктовое месиво"

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "Странная, но приятная смесь из водки, томатного сока и лайма. Или, по крайней мере, ты ДУМАЕШЬ, что красное - это томатный сок."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "bloodymaryglass"
	drink_name = "Bloody Mary"
	drink_desc = "'Кровавая Мэри' - томатный сок, смешанный с водкой и небольшим количеством лайма. На вкус как жидкое убийство."
	taste_description = "помидоры с выпивкой"

/datum/reagent/consumable/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Ух ты, эта штука переменчивая!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.7 //ouch
	drink_icon = "gargleblasterglass"
	drink_name = "Pan-Galactic Gargle Blaster"
	drink_desc = "'Общегалактический бластер' делает... Эй, означает ли это, что Артур и Форд находятся на станции? Батюшки."
	taste_description = "42"

/datum/reagent/consumable/ethanol/flaming_homer
	name = "Flaming Moe"
	id = "flamingmoe"
	description = "По-видимому, это смесь различных спиртов, смешанных с лекарствами, отпускаемыми по рецепту. Он слегка поджарен..."
	reagent_state = LIQUID
	color = "#58447f" //rgb: 88, 66, 127
	alcohol_perc = 0.5
	drink_icon = "flamingmoeglass"
	drink_name = "Flaming Moe"
	drink_desc = "Счастье - это когда всего лишь 'Пылающий Мо!'"
	taste_description = "карамелизованная выпивка и сладкое, соленое лекарство"

/datum/reagent/consumable/ethanol/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "Странная, но приятная смесь из текилы и калуы."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "bravebullglass"
	drink_name = "Brave Bull"
	drink_desc = "'Храбрый бык' - текила и кофейный ликер, собранные вместе в аппетитную смесь. До дна!"
	taste_description = "сладкий алкоголь"

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "Tequila Sunrise"
	id = "tequilasunrise"
	description = "Текила и апельсиновый сок. Очень похоже на 'Отвертку', только мексиканскую~"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "tequilasunriseglass"
	drink_name = "Tequila Sunrise"
	drink_desc = "'Текила Санрайз' - теперь ты испытываешь ностальгию по восходам солнца на Терре... Отлично!"
	taste_description = "фруктовый алкоголь"

/datum/reagent/consumable/ethanol/toxins_special
	name = "Toxins Special"
	id = "toxinsspecial"
	description = "Эта штука ПЫЛАЕТ! ВЫЗЫВАЙ ЕБАНЫЙ ШАТТЛ!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "toxinsspecialglass"
	drink_name = "Toxins Special"
	drink_desc = "'Особые токсины' - эта штука в ОГНЕ!"
	taste_description = "ОГОНЬ"

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(mob/living/M)
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	return ..()

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Откажитесь пить это и приготовьтесь к ЗАКОНУ."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "beepskysmashglass"
	description = "Сливки, пропитанные виски, чего еще можно ожидать от ирландцев."
	drink_name = "Beepsky Smash"
	drink_desc = "'Разгромленный Бипски'- тяжелый, горячий и сильный. Прямо как Железный кулак ЗАКОНА."
	taste_description = "ЗАКОН"

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/M)
	var/update_flag = STATUS_UPDATE_NONE
	update_flag |= M.Stun(1, FALSE)
	return ..() | update_flag

/datum/reagent/consumable/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "irishcreamglass"
	drink_name = "Irish Cream"
	drink_desc = "Это сливки, смешанные с виски. Чего еще можно было ожидать от ирландцев?"
	taste_description = "сливочный спирт"

/datum/reagent/consumable/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Пиво и эль, собранные вместе в восхитительной смеси. Предназначено только для настоящих мужчин."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "manlydorfglass"
	drink_name = "The Manly Dorf"
	drink_desc = "Мужественная смесь, приготовленная из Эля и Пива. Предназначено только для настоящих мужчин."
	taste_description = "мужественность"

/datum/reagent/consumable/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "Винный шкаф, собранный в восхитительную смесь. Предназначен только для женщин-алкоголиков среднего возраста."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "longislandicedteaglass"
	drink_name = "Long Island Iced Tea"
	drink_desc = "Винный шкаф, собранный в восхитительную смесь. Предназначен только для женщин-алкоголиков среднего возраста."
	taste_description = "фруктовый алкоголь"

/datum/reagent/consumable/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "Теперь ты действительно достиг дна... Твоя печень собрала свои вещи и ушла прошлой ночью."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.8 //yeeehaw
	drink_icon = "glass_clear"
	drink_name = "Moonshine"
	drink_desc = "Теперь ты действительно достиг дна... Твоя печень собрала свои вещи и ушла прошлой ночью."
	taste_description = "запрет"

/datum/reagent/consumable/ethanol/b52
	name = "B-52"
	id = "b52"
	description = "'Калуа', 'Ирландские Сливки' и коньяк. Тебя порвёт."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "b52glass"
	drink_name = "B-52"
	drink_desc = "'Калуа', 'Ирландские Сливки' и коньяк. Тебя порвёт."
	taste_description = "разрушение"

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Кофе и алкоголь. Веселее, чем Мимозу пить по утрам."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "irishcoffeeglass"
	drink_name = "Irish Coffee"
	drink_desc = "Кофе и алкоголь. Веселее, чем Мимозу пить по утрам."
	taste_description = "кофе и выпивка"

/datum/reagent/consumable/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "'Маргарита' - на камнях с солью по краю. Арриба~!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "margaritaglass"
	drink_name = "Margarita"
	drink_desc = "'Маргарита' - на камнях с солью по краю. Арриба~!"
	taste_description = "маргаритки"

/datum/reagent/consumable/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "Для людей с непереносимостью лактозы. Все еще такой же классный, как 'Белый Русский'."
	reagent_state = LIQUID
	color = "#360000" // rgb: 54, 0, 0
	alcohol_perc = 0.4
	drink_icon = "blackrussianglass"
	drink_name = "Black Russian"
	drink_desc = "Для людей с непереносимостью лактозы. Все еще такой же классный, как 'Белый Русский'."
	taste_description = "сладкий алкоголь"

/datum/reagent/consumable/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "'Манхеттен' - любимый напиток детектива под прикрытием. Он никогда не мог переварить джин..."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "manhattanglass"
	drink_name = "Manhattan"
	drink_desc = "'Манхеттен' - любимый напиток детектива под прикрытием. Он никогда не мог переварить джин..."
	taste_description = "шумный город"

/datum/reagent/consumable/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "'Проект Манхеттен' - любимый напиток ученого, за обдумывание способов взорвать станцию."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "proj_manhattanglass"
	drink_name = "Manhattan Project"
	drink_desc = "'Проект Манхеттен' - любимый напиток ученого, за обдумывание способов взорвать станцию."
	taste_description = "апокалипсис"

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "Ультимативное освежение."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "whiskeysodaglass2"
	drink_name = "Whiskey Soda"
	drink_desc = "Ультимативное освежение."
	taste_description = "посредственность"

/datum/reagent/consumable/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ультимативное освежение."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "antifreeze"
	drink_name = "Anti-freeze"
	drink_desc = "Ультимативное освежение."
	taste_description = "неудачный жизненный выбор"

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/M)
	if(M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	return ..()

/datum/reagent/consumable/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Босиком и беременная."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "b&p"
	drink_name = "Barefoot"
	drink_desc = "'Босиком' и беременная."
	taste_description = "беременность"

/datum/reagent/consumable/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "Прохладительный напиток."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "snowwhite"
	drink_name = "Snow White"
	drink_desc = "Прохладительный напиток."
	taste_description = "отравленное яблоко"

/datum/reagent/consumable/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "ААААААХ!!!!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 10
	alcohol_perc = 0.4
	drink_icon = "demonsblood"
	drink_name = "Demons Blood"
	drink_desc = "'Кровь Демонов' - От одного взгляда на эту штуку волосы у тебя на затылке встают дыбом."
	taste_description = "<span class='warning'>зло</span>"

/datum/reagent/consumable/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "Для тех случаев, когда джина с тоником недостаточно по-русски."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 4
	alcohol_perc = 0.3
	drink_icon = "vodkatonicglass"
	drink_name = "Vodka and Tonic"
	drink_desc = "Для тех случаев, когда джина с тоником недостаточно по-русски."
	taste_description = "горькое лекарство"

/datum/reagent/consumable/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Освежающе лимонный, восхитительно сухой."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	dizzy_adj = 4
	alcohol_perc = 0.4
	drink_icon = "ginfizzglass"
	drink_name = "Gin Fizz"
	drink_desc = "Освежающе лимонный, восхитительно сухой."
	taste_description = "шипучий алкоголь"

/datum/reagent/consumable/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Тропический коктейль."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "bahama_mama"
	drink_name = "Bahama Mama"
	drink_desc = "Тропический коктейль."
	taste_description = "ХОНК"

/datum/reagent/consumable/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "Напиток из голубого космоса!"
	reagent_state = LIQUID
	color = "#2E6671" // rgb: 46, 102, 113
	dizzy_adj = 15
	alcohol_perc = 0.7
	drink_icon = "singulo"
	drink_name = "Singulo"
	drink_desc = "'Сингуло' - напиток из голубого космоса!"
	taste_description = "бесконечность"

/datum/reagent/consumable/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "Пряная водка! Может быть, немного жарковато для маленьких ребят!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "sbitenglass"
	drink_name = "Sbiten"
	drink_desc = "Пряная смесь водки и специй. Очень жарко."
	taste_description = "успокаивающее тепло"

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/M)
	if(M.bodytemperature < 360)
		M.bodytemperature = min(360, M.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	return ..()

/datum/reagent/consumable/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "'Поцелуй Дьявола' - жуткое время!"
	reagent_state = LIQUID
	color = "#A68310" // rgb: 166, 131, 16
	alcohol_perc = 0.3
	drink_icon = "devilskiss"
	drink_name = "Devils Kiss"
	drink_desc = "'Поцелуй Дьявола' - жуткое время!"
	taste_description = "озорство"

/datum/reagent/consumable/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "Настоящий напиток викингов! Даже несмотря на то, что у него странный красный цвет."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "red_meadglass"
	drink_name = "Red Mead"
	drink_desc = "Настоящий напиток викингов! Даже несмотря на то, что у него странный красный цвет."
	taste_description = "кровь"

/datum/reagent/consumable/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "Напиток викингов, причем дешевый."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	nutriment_factor = 1 * REAGENTS_METABOLISM
	alcohol_perc = 0.2
	drink_icon = "meadglass"
	drink_name = "Mead"
	drink_desc = "Напиток викингов, причем дешевый."
	taste_description = "мёд"

/datum/reagent/consumable/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "Пиво, которое настолько холодное, что воздух вокруг него замерзает."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "iced_beerglass"
	drink_name = "Iced Beer"
	drink_desc = "Пиво, которое настолько холодное, что воздух вокруг него замерзает."
	taste_description = "холодное пиво"

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/M)
	if(M.bodytemperature > 270)
		M.bodytemperature = max(270, M.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	return ..()

/datum/reagent/consumable/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Разбавленный ром, Nanotrasen одобряет!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "grogglass"
	drink_name = "Grog"
	drink_desc = "Разбавленный ром, Nanotrasen одобряет!"
	taste_description = "сильно разбавленный ром"

/datum/reagent/consumable/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "Очень, очень, очень хорошо."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "aloe"
	drink_name = "Aloe"
	drink_desc = "Очень, очень, очень хорошо."
	taste_description = "здоровая кожа"

/datum/reagent/consumable/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "Приятный, странно названный напиток."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.4
	drink_icon = "andalusia"
	drink_name = "Andalusia"
	drink_desc = "Приятный, странно названный напиток."
	taste_description = "сладкий алкаголь"

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "Напиток, приготовленный из ваших союзников."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "alliescocktail"
	drink_name = "Allies cocktail"
	drink_desc = "Напиток, приготовленный из ваших союзников."
	taste_description = "победа"

/datum/reagent/consumable/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "Напиток от Nanotrasen. Сделанный из живых инопланетян."
	reagent_state = LIQUID
	color = "#365000" // rgb: 54, 80, 0
	alcohol_perc = 0.3
	drink_icon = "acidspitglass"
	drink_name = "Acid Spit"
	drink_desc = "Напиток от Nanotrasen. Сделанный из живых инопланетян."
	taste_description = "БОЛЬ"

/datum/reagent/consumable/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Официальный напиток Империума."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.3
	drink_icon = "amasecglass"
	drink_name = "Amasec"
	drink_desc = "Всегда под рукой перед БОЕМ!!!"
	taste_description = "дубинка"

/datum/reagent/consumable/ethanol/neurotoxin
	name = "Neuro-toxin"
	id = "neurotoxin"
	description = "Сильный нейротоксин, который приводит субъекта в состояние, подобное смерти."
	reagent_state = LIQUID
	color = "#2E2E61" // rgb: 46, 46, 97
	dizzy_adj = 6
	alcohol_perc = 0.7
	heart_rate_decrease = 1
	drink_icon = "neurotoxinglass"
	drink_name = "Neurotoxin"
	drink_desc = "Напиток, который гарантированно сведет вас с ума."
	taste_description = "повреждение моээЭЭЭзга"

/datum/reagent/consumable/ethanol/neurotoxin/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	if(current_cycle >= 13)
		update_flags |= M.Weaken(3, FALSE)
	if(current_cycle >= 55)
		update_flags |= M.Druggy(55, FALSE)
	if(current_cycle >= 200)
		update_flags |= M.adjustToxLoss(2, FALSE)
	return ..() | update_flags

/datum/reagent/consumable/ethanol/hippies_delight
	name = "Hippie's Delight"
	id = "hippiesdelight"
	description = "Ты просто не понимаешь, чувааааак."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	drink_icon = "hippiesdelightglass"
	drink_name = "Hippie's Delight"
	drink_desc = "Напиток, которым наслаждались люди в 1960-х годах."
	taste_description = "цвета"

/datum/reagent/consumable/ethanol/hippies_delight/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	update_flags |= M.Druggy(50, FALSE)
	switch(current_cycle)
		if(1 to 5)
			M.Stuttering(1)
			M.Dizzy(10)
			if(prob(10))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.Stuttering(1)
			M.Jitter(20)
			M.Dizzy(20)
			update_flags |= M.Druggy(45, FALSE)
			if(prob(20))
				M.emote(pick("twitch","giggle"))
		if(10 to INFINITY)
			M.Stuttering(1)
			M.Jitter(40)
			M.Dizzy(40)
			update_flags |= M.Druggy(60, FALSE)
			if(prob(30))
				M.emote(pick("twitch","giggle"))
	return ..() | update_flags

/datum/reagent/consumable/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "Жалящий напиток."
	reagent_state = LIQUID
	color = "#2E6671" // rgb: 46, 102, 113
	alcohol_perc = 0.7
	dizzy_adj = 5
	drink_icon = "changelingsting"
	drink_name = "Changeling Sting"
	drink_desc = "Жалящий напиток."
	taste_description = "крошечный укол"

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Ммм, на вкус как шоколадный торт..."
	reagent_state = LIQUID
	color = "#2E6671" // rgb: 46, 102, 113
	alcohol_perc = 0.3
	dizzy_adj = 5
	drink_icon = "irishcarbomb"
	drink_name = "Irish Car Bomb"
	drink_desc = "Ирландская бомба в машине."
	taste_description = "проблемы"

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Бомба Синдиката"
	reagent_state = LIQUID
	color = "#2E6671" // rgb: 46, 102, 113
	alcohol_perc = 0.2
	drink_icon = "syndicatebomb"
	drink_name = "Syndicate Bomb"
	drink_desc = "Бомба Синдиката"
	taste_description = "предложение о работе"

/datum/reagent/consumable/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "Сюрприз в том, что он зеленый!"
	reagent_state = LIQUID
	color = "#2E6671" // rgb: 46, 102, 113
	alcohol_perc = 0.2
	drink_icon = "erikasurprise"
	name = "Erika Surprise"
	drink_desc = "Сюрприз в том, что он зеленый!"
	taste_description = "разочарование"

/datum/reagent/consumable/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Только для опытных. Тебе кажется, что ты видишь песок, плавающий в стекле."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	alcohol_perc = 0.5
	dizzy_adj = 10
	drink_icon = "driestmartiniglass"
	drink_name = "Driest Martini"
	drink_desc = "Только для опытных. Тебе кажется, что ты видишь песок, плавающий в стекле."
	taste_description = "пыль и пепел"

/datum/reagent/consumable/ethanol/driestmartini/on_mob_life(mob/living/M)
	if(current_cycle >= 55 && current_cycle < 115)
		M.AdjustStuttering(10)
	return ..()

/datum/reagent/consumable/ethanol/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "Широко известный мексиканский ликер со вкусом кофе. В производстве с 1936 года!"
	color = "#664300" // rgb: 102, 67, 0
	alcohol_perc = 0.2
	drink_icon = "kahluaglass"
	drink_name = "Glass of RR coffee Liquor"
	drink_desc = "DAMN, THIS THING LOOKS ROBUST"
	taste_description = "кофе и алкоголь"

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	M.AdjustDizzy(-5)
	M.AdjustDrowsy(-3)
	update_flags |= (M.AdjustSleeping(-2) ? STATUS_UPDATE_STAT : STATUS_UPDATE_NONE)
	M.Jitter(5)
	return ..() | update_flags

/datum/reagent/ginsonic
	name = "Gin and sonic"
	id = "ginsonic"
	description = "НУЖНО БЫСТРО ВЗБОДРИТЬСЯ, НО АЛКОГОЛЬ СЛИШКОМ МЕДЛЕННЫЙ"
	reagent_state = LIQUID
	color = "#1111CF"
	drink_icon = "ginsonic"
	drink_name = "Gin and Sonic"
	drink_desc = "Напиток с чрезвычайно высокой силой тока. Абсолютно не для истинного англичанина."
	taste_description = "СКОРОСТЬ"

/datum/reagent/ginsonic/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	M.AdjustDrowsy(-5)
	if(prob(25))
		update_flags |= M.AdjustParalysis(-1, FALSE)
		update_flags |= M.AdjustStunned(-1, FALSE)
		update_flags |= M.AdjustWeakened(-1, FALSE)
	if(prob(8))
		M.reagents.add_reagent("methamphetamine",1.2)
		var/sonic_message = pick("Gotta go fast!", "Time to speed, keed!", "I feel a need for speed!", "Let's juice.", "Juice time.", "Way Past Cool!")
		if(prob(50))
			M.say("[sonic_message]")
		else
			to_chat(M, "<span class='notice'>[sonic_message ]</span>")
	return ..() | update_flags

/datum/reagent/consumable/ethanol/applejack
	name = "Applejack"
	id = "applejack"
	description = "Высококонцентрированный алкогольный напиток, приготовленный путем многократного замораживания сидра и удаления льда."
	color = "#997A00"
	alcohol_perc = 0.4
	drink_icon = "cognacglass"
	drink_name = "Applejack"
	drink_desc = "Когда сидр недостаточно крепкий, его нужно взбить."
	taste_description = "крепкий сидр"

/datum/reagent/consumable/ethanol/jackrose
	name = "Jack Rose"
	id = "jackrose"
	description = "Классический коктейль, вышедший из моды, но никогда не выходивший из моды."
	color = "#664300"
	alcohol_perc = 0.4
	drink_icon = "patronglass"
	drink_name = "Jack Rose"
	drink_desc = "Выпивая это, вы чувствуете себя так, словно находитесь в баре роскошного отеля 1920-х годов."
	taste_description = "стиль"

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "Drunken Blumpkin"
	id = "drunkenblumpkin"
	description = "Странная смесь виски и тыквенного сока."
	color = "#1EA0FF" // rgb: 102, 67, 0
	alcohol_perc = 0.5
	drink_icon = "drunkenblumpkin"
	drink_name = "Drunken Blumpkin"
	drink_desc = "Странная смесь виски и тыквенного сока."
	taste_description = "странности"

/datum/reagent/consumable/ethanol/eggnog
	name = "Eggnog"
	id = "eggnog"
	description = "За то, что наслаждаешься самым чудесным временем года."
	color = "#fcfdc6" // rgb: 252, 253, 198
	nutriment_factor = 2 * REAGENTS_METABOLISM
	alcohol_perc = 0.1
	drink_icon = "glass_yellow"
	drink_name = "Eggnog"
	drink_desc = "За то, что наслаждаешься самым чудесным временем года."
	taste_description = "рождественский дух"

/datum/reagent/consumable/ethanol/dragons_breath //inaccessible to players, but here for admin shennanigans
	name = "Dragon's Breath"
	id = "dragonsbreath"
	description = "Обладание этим веществом, вероятно, нарушает Женевскую конвенцию."
	reagent_state = LIQUID
	color = "#DC0000"
	alcohol_perc = 1
	can_synth = FALSE
	taste_description = "<span class='userdanger'>ЖИДКАЯ СМЕРТЬ НАХУЙ, БОЖЕ, КАКОГО ХУЯ</span>"

/datum/reagent/consumable/ethanol/dragons_breath/reaction_mob(mob/living/M, method=REAGENT_TOUCH, volume)
	if(method == REAGENT_INGEST && prob(20))
		if(M.on_fire)
			M.adjust_fire_stacks(6)

/datum/reagent/consumable/ethanol/dragons_breath/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	if(M.reagents.has_reagent("milk"))
		to_chat(M, "<span class='notice'>Молоко останавливает жжение. Аааах.</span>")
		M.reagents.del_reagent("milk")
		M.reagents.del_reagent("dragonsbreath")
		return
	if(prob(8))
		to_chat(M, "<span class='userdanger'>О боже! О БОЖЕ!!</span>")
	if(prob(50))
		to_chat(M, "<span class='danger'>У тебя ужасно горит горло!</span>")
		M.emote(pick("scream","cry","choke","gasp"))
		update_flags |= M.Stun(1, FALSE)
	if(prob(8))
		to_chat(M, "<span class='danger'>Почему?! ПОЧЕМУ?!</span>")
	if(prob(8))
		to_chat(M, "<span class='danger'>ААААААААА!</span>")
	if(prob(2 * volume))
		to_chat(M, "<span class='userdanger'>О БОЖЕ, БЛЯТЬ ПОЖАЛУЙСТА, НЕТ!!</b></span>")
		if(M.on_fire)
			M.adjust_fire_stacks(20)
		if(prob(50))
			to_chat(M, "<span class='userdanger'>ГОРИТ!!!!</span>")
			M.visible_message("<span class='danger'>[M] сгорает в огне!</span>")
			M.dust()
			return
	return ..() | update_flags

// ROBOT ALCOHOL PAST THIS POINT
// WOOO!

/datum/reagent/consumable/ethanol/synthanol
	name = "Синтанол"
	id = "synthanol"
	description = "Жидкая жидкость с проводящими свойствами. Его воздействие на синтетику аналогично воздействию алкоголя на органические вещества."
	reagent_state = LIQUID
	color = "#1BB1FF"
	process_flags = ORGANIC | SYNTHETIC
	alcohol_perc = 0.5
	drink_icon = "synthanolglass"
	drink_name = "Стакан Синтанола"
	drink_desc = "Эквивалент алкоголя для синтетических членов экипажа. Они сочли бы это ужасным, если бы у них тоже были вкусовые рецепторы."
	taste_description = "моторное масло"

/datum/reagent/consumable/ethanol/synthanol/on_mob_life(mob/living/M)
	metabolization_rate = REAGENTS_METABOLISM
	if(!(M.dna.species.reagent_tag & PROCESS_SYN))
		metabolization_rate += 3.6 //gets removed from organics very fast
		if(prob(25))
			metabolization_rate += 15
			M.fakevomit()
	return ..()

/datum/reagent/consumable/ethanol/synthanol/reaction_mob(mob/living/M, method=REAGENT_TOUCH, volume)
	if(M.dna.species.reagent_tag & PROCESS_SYN)
		return
	if(method == REAGENT_INGEST)
		to_chat(M, pick("<span class = 'danger'>Отвратительно!</span>", "<span class = 'danger'>ПХЕ!</span>"))

/datum/reagent/consumable/ethanol/synthanol/robottears
	name = "Robot Tears"
	id = "robottears"
	description = "Маслянистое вещество, которое КПБ технически мог бы считать 'напитком'."
	reagent_state = LIQUID
	color = "#363636"
	alcohol_perc = 0.25
	drink_icon = "robottearsglass"
	drink_name = "Robot Tears"
	drink_desc = "Ни один робот не пострадал при приготовлении этого напитка."
	taste_description = "экзистенциальная тоска"

/datum/reagent/consumable/ethanol/synthanol/trinary
	name = "Trinary"
	id = "trinary"
	description = "Фруктовый напиток, предназначенный только для синтетики, однако это работает."
	reagent_state = LIQUID
	color = "#adb21f"
	alcohol_perc = 0.2
	drink_icon = "trinaryglass"
	drink_name = "Trinary"
	drink_desc = "Красочный напиток, приготовленный для синтетических членов экипажа. Не похоже, чтобы это было хорошо на вкус."
	taste_description = "статический модем"

/datum/reagent/consumable/ethanol/synthanol/servo
	name = "Servo"
	id = "servo"
	description = "Напиток, содержащий некоторые органические ингредиенты, но предназначенный только для синтетики."
	reagent_state = LIQUID
	color = "#5b3210"
	alcohol_perc = 0.25
	drink_icon = "servoglass"
	drink_name = "Servo"
	drink_desc = "Напиток на основе шоколада, приготовленный для КПБ. Не уверен, что кто-нибудь действительно пробовал этот рецепт."
	taste_description = "моторное масло и какао"

/datum/reagent/consumable/ethanol/synthanol/uplink
	name = "Uplink"
	id = "uplink"
	description = "Мощная смесь спирта и синтанола. Будет работать только на синтетике."
	reagent_state = LIQUID
	color = "#e7ae04"
	alcohol_perc = 0.15
	drink_icon = "uplinkglass"
	drink_name = "Uplink"
	drink_desc = "Изысканная смесь лучших ликеров и синтанола. Предназначен только для синтетики."
	taste_description = "GUI в visual basic"

/datum/reagent/consumable/ethanol/synthanol/synthnsoda
	name = "Synth 'n Soda"
	id = "synthnsoda"
	description = "Классический напиток, адаптированный под вкусы робота."
	reagent_state = LIQUID
	color = "#7204e7"
	alcohol_perc = 0.25
	drink_icon = "synthnsodaglass"
	drink_name = "Synth 'n Soda"
	drink_desc = "Классический напиток, измененный в соответствии со вкусами робота. Плохая идея пить, если ты сделан из углерода."
	taste_description = "шипучее моторное масло"

/datum/reagent/consumable/ethanol/synthanol/synthignon
	name = "Synthignon"
	id = "synthignon"
	description = "Кто-то смешал вино и алкоголь для роботов. Надеюсь, ты гордишься собой."
	reagent_state = LIQUID
	color = "#d004e7"
	alcohol_perc = 0.25
	drink_icon = "synthignonglass"
	drink_name = "Synthignon"
	drink_desc = "Кто-то смешал хорошее вино и роботизированную выпивку. Романтично, но ужасно."
	taste_description = "модное моторное масло"

/datum/reagent/consumable/ethanol/fruit_wine
	name = "Fruit Wine"
	id = "fruit_wine"
	description = "Вино, приготовленное из выращенных растений."
	color = "#FFFFFF"
	alcohol_perc = 0.35
	taste_description = "плохой код"
	can_synth = FALSE
	var/list/names = list("null == фрутов" = 1) //Names of the fruits used. Associative list where name is key, value is the percentage of that fruit.
	var/list/tastes = list("bad coding" = 1) //List of tastes. See above.

/datum/reagent/consumable/ethanol/fruit_wine/on_new(list/data)
	names = data["names"]
	tastes = data["tastes"]
	alcohol_perc = data["alcohol_perc"]
	color = data["color"]
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/on_merge(list/data, amount)
	var/diff = (amount/volume)
	if(diff < 1)
		color = BlendRGB(color, data["color"], diff/2) //The percentage difference over two, so that they take average if equal.
	else
		color = BlendRGB(color, data["color"], (1/diff)/2) //Adjust so it's always blending properly.
	var/oldvolume = volume-amount

	var/list/cachednames = data["names"]
	for(var/name in names | cachednames)
		names[name] = ((names[name] * oldvolume) + (cachednames[name] * amount)) / volume

	var/list/cachedtastes = data["tastes"]
	for(var/taste in tastes | cachedtastes)
		tastes[taste] = ((tastes[taste] * oldvolume) + (cachedtastes[taste] * amount)) / volume

	alcohol_perc *= oldvolume
	var/newzepwr = data["alcohol_perc"] * amount
	alcohol_perc += newzepwr
	alcohol_perc /= volume //Blending alcohol percentage to volume.
	generate_data_info(data)

/datum/reagent/consumable/ethanol/fruit_wine/proc/generate_data_info(list/data)
	var/minimum_percent = 0.15 //Percentages measured between 0 and 1.
	var/list/primary_tastes = list()
	var/list/secondary_tastes = list()
	drink_name = "Стакан [name]"
	drink_desc = description
	for(var/taste in tastes)
		switch(tastes[taste])
			if(minimum_percent*2 to INFINITY)
				primary_tastes += taste
			if(minimum_percent to minimum_percent*2)
				secondary_tastes += taste

	var/minimum_name_percent = 0.35
	name = ""
	var/list/names_in_order = sortTim(names, /proc/cmp_numeric_dsc, TRUE)
	var/named = FALSE
	for(var/fruit_name in names)
		if(names[fruit_name] >= minimum_name_percent)
			name += "[fruit_name] "
			named = TRUE
	if(named)
		name += "вино"
	else
		name = "смешанное [names_in_order[1]] вино"

	var/alcohol_description
	switch(alcohol_perc)
		if(1.2 to INFINITY)
			alcohol_description = "самоубийственно крепкое"
		if(0.9 to 1.2)
			alcohol_description = "довольно крепкое"
		if(0.7 to 0.9)
			alcohol_description = "крепкое"
		if(0.4 to 0.7)
			alcohol_description = "богатое"
		if(0.2 to 0.4)
			alcohol_description = "мягкое"
		if(0 to 0.2)
			alcohol_description = "сладкое"
		else
			alcohol_description = "водянистое" //How the hell did you get negative boozepwr?

	var/list/fruits = list()
	if(names_in_order.len <= 3)
		fruits = names_in_order
	else
		for(var/i in 1 to 3)
			fruits += names_in_order[i]
		fruits += "другие растения"
	var/fruit_list = english_list(fruits)
	description = "[alcohol_description] вино, сваренное из [fruit_list]."

	var/flavor = ""
	if(!primary_tastes.len)
		primary_tastes = list("[alcohol_description] алкаголь")
	flavor += english_list(primary_tastes)
	if(secondary_tastes.len)
		flavor += ", с привкусом, как "
		flavor += english_list(secondary_tastes)
	taste_description = flavor
	if(holder.my_atom)
		holder.my_atom.on_reagent_change()

/datum/reagent/consumable/ethanol/bacchus_blessing //An EXTREMELY powerful drink. Smashed in seconds, dead in minutes.
	name = "Bacchus' Blessing"
	id = "bacchus_blessing"
	description = "Неидентифицируемая смесь. Неизмеримо высокое содержание алкоголя."
	color = rgb(51, 19, 3) //Sickly brown
	dizzy_adj = 21
	alcohol_perc = 3 //I warned you
	drink_icon = "bacchusblessing"
	drink_name = "Bacchus' Blessing"
	drink_desc = "Вы не думали, что жидкость может быть такой отвратительной. Ты уверен насчет этого...?"
	taste_description = "кирпичная стена"

/datum/reagent/consumable/ethanol/fernet
	name = "Fernet"
	id = "fernet"
	description = "Невероятно горький травяной ликер, используемый в качестве дижестива."
	color = "#1B2E24" // rgb: 27, 46, 36
	alcohol_perc = 0.5
	drink_icon = "fernetpuro"
	drink_name = "Чистый Fernet"
	drink_desc = "Почему ты пьешь этот чистый... Чего?"
	taste_description = "полнейшая горечь"
	var/remove_nutrition = 2

/datum/reagent/consumable/ethanol/fernet/on_mob_life(mob/living/M)
	var/update_flags = STATUS_UPDATE_NONE
	if(!M.nutrition)
		switch(rand(1, 3))
			if(1)
				to_chat(M, "<span class='warning'>Ты чувствуешь голод...</span>")
			if(2)
				update_flags |= M.adjustToxLoss(1, FALSE)
				to_chat(M, "<span class='warning'>Твой желудок болезненно урчит!</span>")
	else
		if(prob(60))
			M.adjust_nutrition(-remove_nutrition)
			M.overeatduration = 0
	return ..() | update_flags

/datum/reagent/consumable/ethanol/fernet/fernet_cola
	name = "Fernet Cola"
	id = "fernet_cola"
	description = "Очень популярный и горько-сладкий дижестив, идеально подходящий после обильной трапезы. По традиции, лучше всего подавать на отпиленной бутылке колы."
	color = "#390600" // rgb: 57, 6, 0
	alcohol_perc = 0.2
	drink_icon = "fernetcola"
	drink_name = "Fernet cola"
	drink_desc = "Отпиленная бутылка колы, наполненная Фернет-колой. Вы можете услышать музыку куартето, доносящуюся изнутри."
	taste_description = "рай для низшего класса"
	remove_nutrition = 1
