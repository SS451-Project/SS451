//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTHER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

// Supply Groups
#define SUPPLY_EMERGENCY 1
#define SUPPLY_SECURITY 2
#define SUPPLY_ENGINEER 3
#define SUPPLY_MEDICAL 4
#define SUPPLY_SCIENCE 5
#define SUPPLY_ORGANIC 6
#define SUPPLY_MATERIALS 7
#define SUPPLY_MISC 8
#define SUPPLY_VEND 9

GLOBAL_LIST_INIT(all_supply_groups, list(SUPPLY_EMERGENCY,SUPPLY_SECURITY,SUPPLY_ENGINEER,SUPPLY_MEDICAL,SUPPLY_SCIENCE,SUPPLY_ORGANIC,SUPPLY_MATERIALS,SUPPLY_MISC,SUPPLY_VEND))

/proc/get_supply_group_name(var/cat)
	switch(cat)
		if(SUPPLY_EMERGENCY)
			return "Emergency"
		if(SUPPLY_SECURITY)
			return "Security"
		if(SUPPLY_ENGINEER)
			return "Engineering"
		if(SUPPLY_MEDICAL)
			return "Medical"
		if(SUPPLY_SCIENCE)
			return "Science"
		if(SUPPLY_ORGANIC)
			return "Food and Livestock"
		if(SUPPLY_MATERIALS)
			return "Raw Materials"
		if(SUPPLY_MISC)
			return "Miscellaneous"
		if(SUPPLY_VEND)
			return "Vending"


/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/amount = null
	var/cost = null
	var/containertype = /obj/structure/closet/crate
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/group = SUPPLY_MISC
	var/list/announce_beacons = list() // Particular beacons that we'll notify the relevant department when we reach
	var/special = FALSE //Event/Station Goals/Admin enabled packs
	var/special_enabled = FALSE
	/// List of names for being done in TGUI
	var/list/ui_manifest = list()


/datum/supply_packs/New()
	manifest += "<ul>"
	for(var/path in contains)
		if(!path)	continue
		var/atom/movable/AM = path
		manifest += "<li>[initial(AM.name)]</li>"
		// Add the name to the UI manifest
		ui_manifest += "[initial(AM.name)]"
	manifest += "</ul>"



////// Use the sections to keep things tidy please /Malkevin

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Emergency ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/emergency	// Section header - use these to set default supply group and crate type for sections
	name = "HEADER"				// Use "HEADER" to denote section headers, this is needed for the supply computers to filter them
	containertype = /obj/structure/closet/crate/internals
	group = SUPPLY_EMERGENCY


/datum/supply_packs/emergency/evac
	name = "Ящик С Аварийным Оборудованием"
	contains = list(/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/floorbot,
					/mob/living/simple_animal/bot/medbot,
					/mob/living/simple_animal/bot/medbot,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/gas/oxygen,
					/obj/item/grenade/gas/oxygen)
	cost = 35
	containertype = /obj/structure/closet/crate/internals
	containername = "Ящик с аварийным оборудованием"
	group = SUPPLY_EMERGENCY

/datum/supply_packs/emergency/internals
	name = "Ящик С Дыхательными Аппаратами"
	contains = list(/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/tank/air,
					/obj/item/tank/air,
					/obj/item/tank/air)
	cost = 10
	containername = "Ящик с дыхательными аппаратами"

/datum/supply_packs/emergency/firefighting
	name = "Ящик С Противопожарным Оборудованием"
	contains = list(/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/suit/fire/firefighter,
					/obj/item/clothing/mask/gas,
					/obj/item/clothing/mask/gas,
					/obj/item/flashlight,
					/obj/item/flashlight,
					/obj/item/tank/oxygen/red,
					/obj/item/tank/oxygen/red,
					/obj/item/extinguisher,
					/obj/item/extinguisher,
					/obj/item/clothing/head/hardhat/red,
					/obj/item/clothing/head/hardhat/red)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Ящик с противопожарным оборудованием"

/datum/supply_packs/emergency/atmostank
	name = "Ящик С Противопожарным Рюкзаком-Контейнером"
	contains = list(/obj/item/watertank/atmos)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Ящик с противопожарным рюкзаком-контейнером"
	access = ACCESS_ATMOSPHERICS

/datum/supply_packs/emergency/weedcontrol
	name = "Ящик С Оборудованием Для Борьбы С Сорняками"
	contains = list(/obj/item/scythe,
					/obj/item/clothing/mask/gas,
					/obj/item/grenade/chem_grenade/antiweed,
					/obj/item/grenade/chem_grenade/antiweed)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/hydrosec
	containername = "Ящик с оборудованием для борьбы с сорняками"
	access = ACCESS_HYDROPONICS
	announce_beacons = list("Hydroponics" = list("Hydroponics"))

/datum/supply_packs/emergency/voxsupport
	name = "Набор Жизнеобеспечения Воксов"
	contains = list(/obj/item/clothing/mask/breath/vox,
					/obj/item/clothing/mask/breath/vox,
					/obj/item/tank/emergency_oxygen/vox,
					/obj/item/tank/emergency_oxygen/vox)
	cost = 50
	containertype = /obj/structure/closet/crate/medical
	containername = "Набор жизнеобеспечения воксов"

/datum/supply_packs/emergency/plasmamansupport
	name = "Набор Жизнеобеспечения Плазмаменов"
	contains = list(/obj/item/clothing/under/plasmaman,
					/obj/item/clothing/under/plasmaman,
					/obj/item/tank/plasma/plasmaman/belt/full,
					/obj/item/tank/plasma/plasmaman/belt/full,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/head/helmet/space/plasmaman,
					/obj/item/clothing/head/helmet/space/plasmaman)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Набор жизнеобеспечения плазмаменов"
	access = ACCESS_EVA

/datum/supply_packs/emergency/plasmamanextinguisher
	name = "Картриджи Для Огнетушителя Плазмаменов"
	contains = list(/obj/item/extinguisher_refill,
					/obj/item/extinguisher_refill,
					/obj/item/extinguisher_refill,
					/obj/item/extinguisher_refill)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Ящик картриджией для огнетушителя плазмаменов"
	access = ACCESS_CARGO

/datum/supply_packs/emergency/specialops
	name = "Ящик С Оборудованием Для Спец. Операций"
	contains = list(/obj/item/storage/box/emps,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/grenade/smokebomb,
					/obj/item/pen/sleepy,
					/obj/item/grenade/chem_grenade/incendiary)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Ящик с оборудованием для спец. операций"
	hidden = 1

/datum/supply_packs/emergency/syndicate
	name = "ERROR_NULL_ENTRY"
	contains = list(/obj/item/storage/box/syndicate)
	cost = 140
	containertype = /obj/structure/closet/crate
	containername = "Ящик"
	hidden = 1

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Security ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/security
	name = "HEADER"
	containertype = /obj/structure/closet/crate/secure/gear
	access = ACCESS_SECURITY
	group = SUPPLY_SECURITY
	announce_beacons = list("Security" = list("Head of Security's Desk", "Warden", "Security"))


/datum/supply_packs/security/supplies
	name = "Ящик Со Снаряжением Службы Безопасности"
	contains = list(/obj/item/storage/box/flashbangs,
					/obj/item/storage/box/teargas,
					/obj/item/storage/box/flashes,
					/obj/item/storage/box/handcuffs)
	cost = 10
	containername = "Ящик со снаряжением службы безопасности"

/datum/supply_packs/security/vending/security
	name = "Пополнение Запасов Автомата SecTech"
	cost = 15
	contains = list(/obj/item/vending_refill/security)
	containername = "Пополнение запасов автомата SecTech"

////// Armor: Basic

/datum/supply_packs/security/helmets
	name = "Ящик Со Шлемами"
	contains = list(/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/helmet,
					/obj/item/clothing/head/helmet)
	cost = 10
	containername = "Ящик со шлемами"

/datum/supply_packs/security/justiceinbound
	name = "Ящик С Набором Истинного Офицера"
	contains = list(/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/head/helmet/justice,
					/obj/item/clothing/mask/gas/sechailer,
					/obj/item/clothing/mask/gas/sechailer)
	cost = 60 //justice comes at a price. An expensive, noisy price.
	containername = "Ящик с набором истинного офицера"

/datum/supply_packs/security/armor
	name = "Ящик С Бронежилетами"
	contains = list(/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest,
					/obj/item/clothing/suit/armor/vest)
	cost = 10
	containername = "Ящик с бронежилетами"

////// Weapons: Basic

/datum/supply_packs/security/baton
	name = "Ящик С Оглушающими Дубинками"
	contains = list(/obj/item/melee/baton/loaded,
					/obj/item/melee/baton/loaded,
					/obj/item/melee/baton/loaded)
	cost = 10
	containername = "Ящик с оглушающими дубинками"

/datum/supply_packs/security/laser
	name = "Ящик С Лазерными Карабинами"
	contains = list(/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser,
					/obj/item/gun/energy/laser)
	cost = 15
	containername = "Ящик с лазерными карабинами"

/datum/supply_packs/security/taser
	name = "Ящик С Тазерами"
	contains = list(/obj/item/gun/energy/gun/advtaser,
					/obj/item/gun/energy/gun/advtaser,
					/obj/item/gun/energy/gun/advtaser)
	cost = 15
	containername = "Ящик с тазерами"

/datum/supply_packs/security/disabler
	name = "Ящик С Дизейблерами"
	contains = list(/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler,
					/obj/item/gun/energy/disabler)
	cost = 10
	containername = "Ящик с Дизейблерами"

/datum/supply_packs/security/enforcer
	name = "Ящик С Энфорсерами"
	contains = list(/obj/item/storage/box/enforcer/security,
					/obj/item/storage/box/enforcer/security)
	cost = 40
	containername = "Ящик с Энфорсерами"

/datum/supply_packs/security/forensics
	name = "Ящик С Набором Детектива"
	contains = list(/obj/item/storage/box/evidence,
					/obj/item/camera,
					/obj/item/taperecorder,
					/obj/item/toy/crayon/white,
					/obj/item/clothing/head/det_hat,
					/obj/item/storage/box/swabs,
					/obj/item/storage/box/fingerprints,
					/obj/item/storage/briefcase/crimekit)
	cost = 20
	containername = "Ящик с набором детектива"

///// Armory stuff

/datum/supply_packs/security/armory
	name = "HEADER"
	containertype = /obj/structure/closet/crate/secure/weapon
	access = ACCESS_ARMORY
	announce_beacons = list("Security" = list("Warden", "Head of Security's Desk"))

///// Armor: Specialist

/datum/supply_packs/security/armory/riothelmets
	name = "Ящик Со Шлемами Для Противодействия Бунтам"
	contains = list(/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot,
					/obj/item/clothing/head/helmet/riot)
	cost = 15
	containername = "Ящик со шлемами для противодействия бунтам"

/datum/supply_packs/security/armory/riotarmor
	name = "Ящик С Бронёй Для Противодействия Бунтам"
	contains = list(/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot,
					/obj/item/clothing/suit/armor/riot)
	cost = 15
	containername = "Ящик с бронёй для противодействия бунтам"

/datum/supply_packs/security/armory/riotshields
	name = "Ящик С Щитами Для Противодействия Бунтам"
	contains = list(/obj/item/shield/riot,
					/obj/item/shield/riot,
					/obj/item/shield/riot)
	cost = 20
	containername = "Ящик с щитами для противодействия бунтам"

/datum/supply_packs/security/bullethelmets
	name = "Ящик С Пуленепробиваемыми Шлемами"
	contains = list(/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt,
					/obj/item/clothing/head/helmet/alt)
	cost = 10
	containername = "Ящик с тактическими шлемами"

/datum/supply_packs/security/armory/bulletarmor
	name = "Ящик С Пуленепробиваемыми Бронежилетами"
	contains = list(/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof,
					/obj/item/clothing/suit/armor/bulletproof)
	cost = 15
	containername = "Ящик с тактическими бронежилетами"

/datum/supply_packs/security/armory/webbing
	name = "Ящик С Тактическими Разгрузками"
	contains = list(/obj/item/storage/belt/security/webbing,
					/obj/item/storage/belt/security/webbing,
					/obj/item/storage/belt/security/webbing)
	cost = 15
	containername = "Ящик с тактическими рагрузками"

/datum/supply_packs/security/armory/swat
	name = "Ящик Со Снаряжением Спецподразделения SWAT"
	contains = list(/obj/item/clothing/head/helmet/swat,
					/obj/item/clothing/head/helmet/swat,
					/obj/item/clothing/suit/space/swat,
					/obj/item/clothing/suit/space/swat,
					/obj/item/kitchen/knife/combat,
					/obj/item/kitchen/knife/combat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/clothing/mask/gas/sechailer/swat,
					/obj/item/storage/belt/military/assault,
					/obj/item/storage/belt/military/assault)
	cost = 60
	containername = "Ящик для штурмовой брони"

/datum/supply_packs/security/armory/laserarmor
	name = "Ящик Для Абляционной Брони Против Лазерного Оружия"
	contains = list(/obj/item/clothing/suit/armor/laserproof,
					/obj/item/clothing/suit/armor/laserproof)		// Only two vests to keep costs down for balance
	cost = 20
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Ящик с абляционной броней"

/datum/supply_packs/security/armory/sibyl
	name = "Ящик С Системами Авторизации Пользователя Sibyl"
	contains = list(/obj/item/sibyl_system_mod,
					/obj/item/sibyl_system_mod,
					/obj/item/sibyl_system_mod)
	cost = 50														//По 15 за один блокиратор и 5 за ящик
	containername = "Ящик для принадлежностей Sibyl"

/////// Weapons: Specialist

/datum/supply_packs/security/armory/ballistic
	name = "Набор Служебных Дробовиков"
	contains = list(/obj/item/gun/projectile/shotgun/riot,
					/obj/item/gun/projectile/shotgun/riot,
					/obj/item/gun/projectile/shotgun/riot,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier)
	cost = 50
	containername = "Набор служебных дробовиков"

/datum/supply_packs/security/armory/ballisticauto
	name = "Ящик С Боевыми Дробовиками"
	contains = list(/obj/item/gun/projectile/shotgun/automatic/combat,
					/obj/item/gun/projectile/shotgun/automatic/combat,
					/obj/item/gun/projectile/shotgun/automatic/combat,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier,
					/obj/item/storage/belt/bandolier)
	cost = 80
	containername = "Ящик с боевыми дробовиками"

/datum/supply_packs/security/armory/buckshotammo
	name = "Ящик С Пачками Картечи 12g"
	contains = list(/obj/item/ammo_box/shotgun/buck,
					/obj/item/storage/box/buck,
					/obj/item/storage/box/buck,
					/obj/item/storage/box/buck,
					/obj/item/storage/box/buck,
					/obj/item/storage/box/buck)
	cost = 45
	containername = "Ящик с пачками картечи 12g"

/datum/supply_packs/security/armory/slugammo
	name = "Ящик С Пачками Пуль 12g"
	contains = list(/obj/item/ammo_box/shotgun,
					/obj/item/storage/box/slug,
					/obj/item/storage/box/slug,
					/obj/item/storage/box/slug,
					/obj/item/storage/box/slug,
					/obj/item/storage/box/slug)
	cost = 45
	containername = "Ящик с пачками пуль 12g"

/datum/supply_packs/security/armory/expenergy
	name = "Ящик С Энергетическими Карабинами"
	contains = list(/obj/item/gun/energy/gun,
					/obj/item/gun/energy/gun)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Ящик с энергетическими карабинами"

/datum/supply_packs/security/armory/epistol	// costs 3/5ths of the normal e-guns for 3/4ths the total ammo, making it cheaper to arm more people, but less convient for any one person
	name = "Ящик С Миниатюрными Энергетическими Пистолетами"
	contains = list(/obj/item/gun/energy/gun/mini,
					/obj/item/gun/energy/gun/mini,
					/obj/item/gun/energy/gun/mini)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Ящик с миниатюрными энергетическими пистолетами"

/datum/supply_packs/security/armory/eweapons
	name = "Ящик С Зажигательным Вооружением"
	contains = list(/obj/item/flamethrower/full,
					/obj/item/tank/plasma,
					/obj/item/tank/plasma,
					/obj/item/tank/plasma,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary,
					/obj/item/grenade/chem_grenade/incendiary)
	cost = 15	// its a fecking flamethrower and some plasma, why the shit did this cost so much before!?
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Ящик с зажигательным вооружением"
	access = ACCESS_HEADS

/datum/supply_packs/security/armory/wt550
	name = "Ящик С Карабинами WT-550"
	contains = list(/obj/item/gun/projectile/automatic/wt550,
					/obj/item/gun/projectile/automatic/wt550)
	cost = 35
	containername = "Ящик с автоматическими винтовками"

/datum/supply_packs/security/armory/wt550ammo
	name = "Ящик С Патронами Для Карабина WT-550"
	contains = list(/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9,
					/obj/item/ammo_box/magazine/wt550m9,)
	cost = 30
	containername = "Ящик с боезапасом к автоматическим винтовкам"

/////// Implants & etc

/datum/supply_packs/security/armory/mindshield
	name = "Ящик С Имплантом Mindshield"
	contains = list (/obj/item/storage/lockbox/mindshield)
	cost = 40
	containername = "Ящик с имплантом Mindshield"

/datum/supply_packs/security/armory/trackingimp
	name = "Ящик С Имплантами Tracking"
	contains = list (/obj/item/storage/box/trackimp)
	cost = 20
	containername = "Ящик с имплантами Tracking"

/datum/supply_packs/security/armory/chemimp
	name = "Ящик С Имплантами Chemical"
	contains = list (/obj/item/storage/box/chemimp)
	cost = 20
	containername = "Ящик с имплантами Chemical"

/datum/supply_packs/security/armory/exileimp
	name = "Ящик С Имплантами Exile"
	contains = list (/obj/item/storage/box/exileimp)
	cost = 30
	containername = "Ящик с имплантами Exile"

/datum/supply_packs/security/securitybarriers
	name = "Ящик С Развертываемыми Барьерами"
	contains = list(/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier,
					/obj/item/grenade/barrier)
	cost = 20
	containername = "Ящик с развертываемыми барьерами"

/datum/supply_packs/security/securityclothes
	name = "Ящик С Одеждой Службы Безопасности"
	contains = list(/obj/item/clothing/under/rank/security/corp,
					/obj/item/clothing/under/rank/security/corp,
					/obj/item/clothing/head/soft/sec/corp,
					/obj/item/clothing/head/soft/sec/corp,
					/obj/item/clothing/under/rank/warden/corp,
					/obj/item/clothing/head/beret/sec/warden,
					/obj/item/clothing/under/rank/head_of_security/corp,
					/obj/item/clothing/head/HoS/beret)
	cost = 30
	containername = "Ящик с одеждой службы безопасности"

/datum/supply_packs/security/officerpack // Starter pack for an officer. Contains everything in a locker but backpack (officer already start with one). Convenient way to equip new officer on highpop.
	name = "Ящик Со Снаряжением Офицера"
	contains = 	list(/obj/item/clothing/suit/armor/vest/security,
				/obj/item/radio/headset/headset_sec/alt,
				/obj/item/clothing/head/soft/sec,
				/obj/item/reagent_containers/spray/pepper,
				/obj/item/flash,
				/obj/item/grenade/flashbang,
				/obj/item/storage/belt/security/sec,
				/obj/item/holosign_creator/security,
				/obj/item/clothing/mask/gas/sechailer,
				/obj/item/clothing/glasses/hud/security/sunglasses,
				/obj/item/clothing/head/helmet,
				/obj/item/melee/baton/loaded,
				/obj/item/clothing/suit/armor/secjacket)
	cost = 30 // Convenience has a price and this pack is genuinely loaded
	containername = "Ящик со снаряжением офицера"



//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Engineering /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/engineering
	name = "HEADER"
	group = SUPPLY_ENGINEER
	announce_beacons = list("Engineering" = list("Engineering", "Chief Engineer's Desk"))
	containertype = /obj/structure/closet/crate/engineering


/datum/supply_packs/engineering/fueltank
	name = "Бак С Топливом"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "Бак с топливом"

/datum/supply_packs/engineering/tools		//the most robust crate
	name = "Набор Ящиков С Инструментами"
	contains = list(/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical,
					/obj/item/storage/toolbox/mechanical)
	cost = 10
	containername = "Набор ящиков с инструментами"

/datum/supply_packs/vending/engivend
	name = "Набор Пополнения  Автоматов EngiVend"
	cost = 15
	contains = list(/obj/item/vending_refill/engivend)
	containername = "Набор пополнения  автоматов EngiVend"

/datum/supply_packs/engineering/powergamermitts
	name = "Набор Изолирующих Перчаток"
	contains = list(/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow,
					/obj/item/clothing/gloves/color/yellow)
	cost = 20	//Made of pure-grade bullshittinium
	containername = "Набор изолирующих перчаток"
	containertype = /obj/structure/closet/crate/engineering/electrical

/datum/supply_packs/engineering/power
	name = "Набор Батареек Повышенной Емкости"
	contains = list(/obj/item/stock_parts/cell/high,		//Changed to an extra high powercell because normal cells are useless
					/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high)
	cost = 10
	containername = "Набор батареек повышенной емкости"
	containertype = /obj/structure/closet/crate/engineering/electrical

/datum/supply_packs/engineering/engiequipment
	name = "Набор Снаряжения Инженеров"
	contains = list(/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/storage/belt/utility,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/suit/storage/hazardvest,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/welding,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat,
					/obj/item/clothing/head/hardhat)
	cost = 10
	containername = "Набор снаряжения инженеров"

/datum/supply_packs/engineering/solar
	name = "Набор Для Сборки Солнечных Панелей"
	contains  = list(/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly,
					/obj/item/solar_assembly, // 21 Solar Assemblies. 1 Extra for the controller
					/obj/item/circuitboard/solar_control,
					/obj/item/tracker_electronics,
					/obj/item/paper/solar)
	cost = 20
	containername = "Набор для сборки солнечных панелей"
	containertype = /obj/structure/closet/crate/engineering/electrical

/datum/supply_packs/engineering/engine
	name = "Набор Эмиттеров"
	contains = list(/obj/machinery/power/emitter,
					/obj/machinery/power/emitter)
	cost = 10
	containername = "Набор эмиттеров"
	access = ACCESS_CE
	containertype = /obj/structure/closet/crate/secure/engineering

/datum/supply_packs/engineering/engine/field_gen
	name = "Набор Генераторов Защитного Поля"
	contains = list(/obj/machinery/field/generator,
					/obj/machinery/field/generator)
	cost = 10
	containername = "Набор генераторов защитного поля"

/datum/supply_packs/engineering/engine/sing_gen
	name = "Генератор Двигателя Сингулярности"
	contains = list(/obj/machinery/the_singularitygen)
	cost = 10
	containername = "Генератор двигателя Сингулярности"

/datum/supply_packs/engineering/engine/tesla
	name = "Генератор Двигателя Тесла"
	contains = list(/obj/machinery/the_singularitygen/tesla)
	cost = 10
	containername = "Генератор двигателя Тесла"

/datum/supply_packs/engineering/engine/coil
	name = "Катушка Теслы"
	contains = list(/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil,
					/obj/machinery/power/tesla_coil)
	cost = 10
	containername = "Катушка Теслы"

/datum/supply_packs/engineering/engine/grounding
	name = "Набор Заземлителей"
	contains = list(/obj/machinery/power/grounding_rod,
					/obj/machinery/power/grounding_rod)
	cost = 10
	containername = "Набор заземлителей"

/datum/supply_packs/engineering/engine/collector
	name = "Набор Радиационных Накопителей"
	contains = list(/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector,
					/obj/machinery/power/rad_collector)
	cost = 10
	containername = "Набор радиационных накопителей"

/datum/supply_packs/engineering/engine/PA
	name = "Набор Для Постройки Ускорителя Частиц"
	contains = list(/obj/structure/particle_accelerator/fuel_chamber,
					/obj/machinery/particle_accelerator/control_box,
					/obj/structure/particle_accelerator/particle_emitter/center,
					/obj/structure/particle_accelerator/particle_emitter/left,
					/obj/structure/particle_accelerator/particle_emitter/right,
					/obj/structure/particle_accelerator/power_box,
					/obj/structure/particle_accelerator/end_cap)
	cost = 25
	containername = "Набор для постройки Ускорителя Частиц"

/datum/supply_packs/engineering/engine/spacesuit
	name = "Костюм Для Выхода В Космос"
	contains = list(/obj/item/clothing/suit/space,
					/obj/item/clothing/suit/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/head/helmet/space,
					/obj/item/clothing/mask/breath,
					/obj/item/clothing/mask/breath)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Костюм для выхода в космос"
	access = ACCESS_EVA

/datum/supply_packs/engineering/inflatable
	name = "Набор Быстроразвертываемых Мембранных Конструкций"
	contains = list(/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable,
					/obj/item/storage/briefcase/inflatable)
	cost = 20
	containername = "Набор быстроразвертываемых мембранных конструкций"

/datum/supply_packs/engineering/engine/supermatter_shard
	name = "Осколок Суперматерии"
	contains = list(/obj/machinery/power/supermatter_shard)
	cost = 50 //So cargo thinks twice before killing themselves with it
	containertype = /obj/structure/closet/crate/secure/engineering
	containername = "Осколок суперматерии"
	access = ACCESS_CE

/datum/supply_packs/engineering/engine/teg
	name = "Набор Для Создания Термоэлектрогенератора"
	contains = list(
		/obj/machinery/power/generator,
		/obj/item/pipe/circulator,
		/obj/item/pipe/circulator)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/engineering
	containername = "Набор для создания Термоэлектрогенератора"
	access = ACCESS_CE
	announce_beacons = list("Engineering" = list("Chief Engineer's Desk", "Atmospherics"))

/datum/supply_packs/engineering/conveyor
	name = "Набор Создания Конвейерной Ленты"
	contains = list(/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_construct,
					/obj/item/conveyor_switch_construct,
					/obj/item/paper/conveyor)
	cost = 15
	containername = "Набор создания конвейерной ленты"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Medical /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/medical
	name = "HEADER"
	containertype = /obj/structure/closet/crate/medical
	group = SUPPLY_MEDICAL
	announce_beacons = list("Medbay" = list("Medbay", "Chief Medical Officer's Desk"), "Security" = list("Brig Medbay"))


/datum/supply_packs/medical/supplies
	name = "Набор Снабжения Медбея"
	contains = list(/obj/item/reagent_containers/glass/bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/charcoal,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/epinephrine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/morphine,
					/obj/item/reagent_containers/glass/bottle/toxin,
					/obj/item/reagent_containers/glass/bottle/toxin,
					/obj/item/reagent_containers/glass/beaker/large,
					/obj/item/reagent_containers/glass/beaker/large,
					/obj/item/stack/medical/bruise_pack,
					/obj/item/reagent_containers/iv_bag/salglu,
					/obj/item/storage/box/beakers,
					/obj/item/storage/box/syringes,
				    /obj/item/storage/box/bodybags,
				    /obj/item/storage/box/iv_bags,
				    /obj/item/vending_refill/medical)
	cost = 20
	containertype = /obj/structure/closet/crate/medical
	containername = "Набор снабжения медбея"

/datum/supply_packs/medical/firstaid
	name = "Набор Аптечек Первой Помощи"
	contains = list(/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/regular,
					/obj/item/storage/firstaid/regular)
	cost = 10
	containername = "Набор аптечек первой помощи"

/datum/supply_packs/medical/firstaidadv
	name = "Набор Продвинутых Аптечек Первой Помощи"
	contains = list(/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/adv,
					/obj/item/storage/firstaid/adv)
	cost = 10
	containername = "Набор продвинутых аптечек первой помощи"

/datum/supply_packs/medical/firstaidmachine
	name = "Набор Аптечек Для КПБ"
	contains = list(/obj/item/storage/firstaid/machine,
					/obj/item/storage/firstaid/machine,
					/obj/item/storage/firstaid/machine,
					/obj/item/storage/firstaid/machine)
	cost = 10
	containername = "Набор аптечек для КПБ"

/datum/supply_packs/medical/firstaibrute
	name = "Набор Аптечек Для Лечения Механических Повреждений"
	contains = list(/obj/item/storage/firstaid/brute,
					/obj/item/storage/firstaid/brute,
					/obj/item/storage/firstaid/brute)
	cost = 10
	containername = "Набор аптечек для лечения механических повреждений"

/datum/supply_packs/medical/firstaidburns
	name = "Набор Аптечек Для Лечения Физических Повреждений"
	contains = list(/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/fire,
					/obj/item/storage/firstaid/fire)
	cost = 10
	containername = "Набор аптечек для лечения физических повреждений"

/datum/supply_packs/medical/firstaidtoxins
	name = "Набор Аптечек Первой Помощи При Отравлении"
	contains = list(/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/toxin,
					/obj/item/storage/firstaid/toxin)
	cost = 10
	containername = "Набор аптечек первой помощи при отравлении"

/datum/supply_packs/medical/firstaidoxygen
	name = "Набор Аптечек Первой Помощи При Асфиксии"
	contains = list(/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/o2,
					/obj/item/storage/firstaid/o2)
	cost = 10
	containername = "Набор аптечек первой помощи при асфиксии"

/datum/supply_packs/medical/virus
	name = "Набор Различных Вирусов"
	contains = list(/obj/item/reagent_containers/glass/bottle/flu_virion,
					/obj/item/reagent_containers/glass/bottle/cold,
					/obj/item/reagent_containers/glass/bottle/epiglottis_virion,
					/obj/item/reagent_containers/glass/bottle/liver_enhance_virion,
					/obj/item/reagent_containers/glass/bottle/fake_gbs,
					/obj/item/reagent_containers/glass/bottle/magnitis,
					/obj/item/reagent_containers/glass/bottle/pierrot_throat,
					/obj/item/reagent_containers/glass/bottle/brainrot,
					/obj/item/reagent_containers/glass/bottle/hullucigen_virion,
					/obj/item/reagent_containers/glass/bottle/anxiety,
					/obj/item/reagent_containers/glass/bottle/beesease,
					/obj/item/storage/box/syringes,
					/obj/item/storage/box/beakers,
					/obj/item/reagent_containers/glass/bottle/mutagen)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Набор различных вирусов"
	access = ACCESS_CMO
	announce_beacons = list("Medbay" = list("Virology", "Chief Medical Officer's Desk"))

/datum/supply_packs/medical/vending
	name = "Набор Пополнения Запасов Наномедов"
	cost = 20
	contains = list(/obj/item/vending_refill/medical,
					/obj/item/vending_refill/wallmed)
	containername = "Набор пополнения запасов Наномедов"

/datum/supply_packs/medical/bloodpacks
	name = "Набор Пакетов С Различными Группами Крови"
	contains = list(/obj/item/reagent_containers/iv_bag,
					/obj/item/reagent_containers/iv_bag,
					/obj/item/reagent_containers/iv_bag/blood/APlus,
					/obj/item/reagent_containers/iv_bag/blood/AMinus,
					/obj/item/reagent_containers/iv_bag/blood/BPlus,
					/obj/item/reagent_containers/iv_bag/blood/BMinus,
					/obj/item/reagent_containers/iv_bag/blood/OPlus,
					/obj/item/reagent_containers/iv_bag/blood/OMinus)
	cost = 35
	containertype = /obj/structure/closet/crate/freezer
	containername = "Набор пакетов с различными группами крови"

/datum/supply_packs/medical/iv_drip
	name = "Стойка Для Капельницы"
	contains = list(/obj/machinery/iv_drip)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "Стойка для капельницы"
	access = ACCESS_MEDICAL

/datum/supply_packs/medical/surgery
	name = "Набор Хирурга"
	contains = list(/obj/item/cautery,
					/obj/item/surgicaldrill,
					/obj/item/clothing/mask/breath/medical,
					/obj/item/tank/anesthetic,
					/obj/item/FixOVein,
					/obj/item/hemostat,
					/obj/item/scalpel,
					/obj/item/bonegel,
					/obj/item/retractor,
					/obj/item/bonesetter,
					/obj/item/circular_saw)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "Набор хирурга"
	access = ACCESS_MEDICAL


//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Science /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/science
	name = "HEADER"
	group = SUPPLY_SCIENCE
	announce_beacons = list("Research Division" = list("Science", "Research Director's Desk"))
	containertype = /obj/structure/closet/crate/sci

/datum/supply_packs/science/robotics
	name = "Набор Снабжения Роботехников"
	contains = list(/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/storage/toolbox/electrical,
					/obj/item/storage/box/flashes,
					/obj/item/stock_parts/cell/high,
					/obj/item/stock_parts/cell/high)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/scisec
	containername = "Набор снабжения роботехников"
	access = ACCESS_ROBOTICS
	announce_beacons = list("Research Division" = list("Robotics", "Research Director's Desk"))


/datum/supply_packs/science/robotics/mecha_ripley
	name = "Платы Для Меха Рипли APLU"
	contains = list(/obj/item/book/manual/ripley_build_and_repair,
					/obj/item/circuitboard/mecha/ripley/main, //TEMPORARY due to lack of circuitboard printer
					/obj/item/circuitboard/mecha/ripley/peripherals) //TEMPORARY due to lack of circuitboard printer
	cost = 30
	containername = "Платы для меха Рипли APLU"

/datum/supply_packs/science/robotics/mecha_odysseus
	name = "Платы Для Медицинского Меха Одиссей"
	contains = list(/obj/item/circuitboard/mecha/odysseus/peripherals, //TEMPORARY due to lack of circuitboard printer
					/obj/item/circuitboard/mecha/odysseus/main) //TEMPORARY due to lack of circuitboard printer
	cost = 25
	containername = "Платы для медицинского меха Одиссей"

/datum/supply_packs/science/plasma
	name = "Набор Для Создания СВУ"
	contains = list(/obj/item/tank/plasma,
					/obj/item/tank/plasma,
					/obj/item/tank/plasma,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/igniter,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/prox_sensor,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer,
					/obj/item/assembly/timer)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/plasma
	containername = "Набор для создания СВУ"
	access = ACCESS_TOX_STORAGE
	group = SUPPLY_SCIENCE

/datum/supply_packs/science/shieldwalls
	name = "Набор Генераторов Силового Поля"
	contains = list(/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen,
					/obj/machinery/shieldwallgen)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/scisec
	containername = "Набор генераторов силового поля"
	access = ACCESS_TELEPORTER

/datum/supply_packs/science/transfer_valves
	name = "Набор Труб С Регуляторами Давления"
	contains = list(/obj/item/transfer_valve,
					/obj/item/transfer_valve)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/scisec
	containername = "Набор труб с регуляторами давления"
	access = ACCESS_RD

/datum/supply_packs/science/prototype
	name = "Прототип Машины"
	contains = list(/obj/item/machineprototype)
	cost = 80
	containertype = /obj/structure/closet/crate/secure/scisec
	containername = "Прототип машины"
	access = ACCESS_RESEARCH

/datum/supply_packs/science/oil
    name = "Бак С Машинным Маслом"
    contains = list(/obj/structure/reagent_dispensers/oil,
					/obj/item/reagent_containers/food/drinks/oilcan)
    cost = 10
    containertype = /obj/structure/largecrate
    containername = "Бак с машинным маслом"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Organic /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/organic
	name = "HEADER"
	group = SUPPLY_ORGANIC
	containertype = /obj/structure/closet/crate/freezer


/datum/supply_packs/organic/food
	name = "Набор Еды"
	contains = list(/obj/item/reagent_containers/food/condiment/flour,
					/obj/item/reagent_containers/food/condiment/rice,
					/obj/item/reagent_containers/food/condiment/milk,
					/obj/item/reagent_containers/food/condiment/soymilk,
					/obj/item/reagent_containers/food/condiment/saltshaker,
					/obj/item/reagent_containers/food/condiment/peppermill,
					/obj/item/kitchen/rollingpin,
					/obj/item/storage/fancy/egg_box,
					/obj/item/mixing_bowl,
					/obj/item/mixing_bowl,
					/obj/item/reagent_containers/food/condiment/enzyme,
					/obj/item/reagent_containers/food/condiment/sugar,
					/obj/item/reagent_containers/food/snacks/meat/monkey,
					/obj/item/reagent_containers/food/snacks/grown/banana,
					/obj/item/reagent_containers/food/snacks/grown/banana,
					/obj/item/reagent_containers/food/snacks/grown/banana)
	cost = 10
	containername = "Набор еды"
	announce_beacons = list("Kitchen" = list("Kitchen"))

/datum/supply_packs/organic/pizza
	name = "Набор Из Различных Пицц"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable,
					/obj/item/pizzabox/hawaiian)
	cost = 60
	containername = "Набор из различных пицц"

/datum/supply_packs/organic/monkey
	name = "Ящик С Обезьянами"
	contains = list (/obj/item/storage/box/monkeycubes)
	cost = 20
	containername = "Ящик с обезьянами"

/datum/supply_packs/organic/farwa
	name = "Ящик С Фарвами"
	contains = list (/obj/item/storage/box/monkeycubes/farwacubes)
	cost = 20
	containername = "Ящик с фарвами"


/datum/supply_packs/organic/wolpin
	name = "Ящик С Вульпинами"
	contains = list (/obj/item/storage/box/monkeycubes/wolpincubes)
	cost = 20
	containername = "Ящик с вульпинами"


/datum/supply_packs/organic/skrell
	name = "Ящик С Неарами"
	contains = list (/obj/item/storage/box/monkeycubes/neaeracubes)
	cost = 20
	containername = "Ящик с неарами"

/datum/supply_packs/organic/stok
	name = "Ящик С Стоками"
	contains = list (/obj/item/storage/box/monkeycubes/stokcubes)
	cost = 20
	containername = "Ящик со стоками"

/datum/supply_packs/organic/party
	name = "Праздничный Набор Выпивки"
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/reagent_containers/food/drinks/shaker,
					/obj/item/reagent_containers/food/drinks/bottle/patron,
					/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
					/obj/item/reagent_containers/food/drinks/cans/ale,
					/obj/item/reagent_containers/food/drinks/cans/ale,
					/obj/item/reagent_containers/food/drinks/cans/beer,
					/obj/item/reagent_containers/food/drinks/cans/beer,
					/obj/item/reagent_containers/food/drinks/cans/beer,
					/obj/item/reagent_containers/food/drinks/cans/beer,
					/obj/item/grenade/confetti,
					/obj/item/grenade/confetti)
	cost = 20
	containername = "Праздничный набор выпивки"
	announce_beacons = list("Bar" = list("Bar"))

/datum/supply_packs/organic/bar
	name = "Стартовый Комплект Для Бара"
	contains = list(/obj/item/storage/box/drinkingglasses,
					/obj/item/circuitboard/chem_dispenser/soda,
					/obj/item/circuitboard/chem_dispenser/beer)
	cost = 20
	containername = "Стартовый комплект для бара"
	announce_beacons = list("Bar" = list("Bar"))

//////// livestock
/datum/supply_packs/organic/cow
	name = "Корова"
	cost = 30
	containertype = /obj/structure/closet/critter/cow
	containername = "Корова"

/datum/supply_packs/organic/pig
	name = "Свинья"
	cost = 25
	containertype = /obj/structure/closet/critter/pig
	containername = "Свинья"

/datum/supply_packs/organic/goat
	name = "Коза"
	cost = 25
	containertype = /obj/structure/closet/critter/goat
	containername = "Коза"

/datum/supply_packs/organic/chicken
	name = "Курица"
	cost = 20
	containertype = /obj/structure/closet/critter/chick
	containername = "Курица"

/datum/supply_packs/organic/turkey
	name = "Индейка"
	cost = 20
	containertype = /obj/structure/closet/critter/turkey
	containername = "Индейка"

/datum/supply_packs/organic/corgi
	name = "Корги"
	cost = 50
	containertype = /obj/structure/closet/critter/corgi
	contains = list(/obj/item/clothing/accessory/petcollar)
	containername = "Корги"

/datum/supply_packs/organic/cat
	name = "Кот"
	cost = 50 //Cats are worth as much as corgis.
	containertype = /obj/structure/closet/critter/cat
	contains = list(/obj/item/clothing/accessory/petcollar,
					/obj/item/toy/cattoy)
	containername = "Кота"

/datum/supply_packs/organic/pug
	name = "Мопс"
	cost = 50
	containertype = /obj/structure/closet/critter/pug
	contains = list(/obj/item/clothing/accessory/petcollar)
	containername = "Мопс"

/datum/supply_packs/organic/fox
	name = "Лиса"
	cost = 55 //Foxes are cool.
	containertype = /obj/structure/closet/critter/fox
	contains = list(/obj/item/clothing/accessory/petcollar)
	containername = "Лиса"

/datum/supply_packs/organic/butterfly
	name = "Бабочка"
	cost = 50
	containertype = /obj/structure/closet/critter/butterfly
	containername = "Бабочка"

/datum/supply_packs/organic/deer
	name = "Олень"
	cost = 56 //Deer are best.
	containertype = /obj/structure/closet/critter/deer
	containername = "Олень"

////// hippy gear

/datum/supply_packs/organic/hydroponics // -- Skie
	name = "Набор Снаряжения Ботаника"
	contains = list(/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/spray/plantbgone,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/reagent_containers/glass/bottle/ammonia,
					/obj/item/hatchet,
					/obj/item/cultivator,
					/obj/item/plant_analyzer,
					/obj/item/clothing/gloves/botanic_leather,
					/obj/item/clothing/suit/apron) // Updated with new things
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Набор снаряжения ботаника"
	announce_beacons = list("Hydroponics" = list("Hydroponics"))

/datum/supply_packs/organic/hydroponics/hydrotank
	name = "Рюкзак-Баллон Для Жидкостей С Распылителем"
	contains = list(/obj/item/watertank)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Рюкзак-баллон для жидкостей с распылителем"
	access = ACCESS_HYDROPONICS
	announce_beacons = list("Hydroponics" = list("Hydroponics"))

/datum/supply_packs/organic/hydroponics/seeds
	name = "Набор Различных Семян"
	contains = list(/obj/item/seeds/chili,
					/obj/item/seeds/cotton,
					/obj/item/seeds/berry,
					/obj/item/seeds/corn,
					/obj/item/seeds/eggplant,
					/obj/item/seeds/tomato,
					/obj/item/seeds/soya,
					/obj/item/seeds/wheat,
					/obj/item/seeds/wheat/rice,
					/obj/item/seeds/carrot,
					/obj/item/seeds/sunflower,
					/obj/item/seeds/chanter,
					/obj/item/seeds/potato,
					/obj/item/seeds/sugarcane)
	cost = 10
	containername = "Набор различных семян"

/datum/supply_packs/organic/vending/hydro_refills
	name = "Набор Пополнения  Автомата Ботаники"
	cost = 20
	containertype = /obj/structure/closet/crate
	contains = list(/obj/item/vending_refill/hydroseeds,
					/obj/item/vending_refill/hydronutrients)
	containername = "Набор пополнения  автомата ботаники"

/datum/supply_packs/organic/hydroponics/exoticseeds
	name = "Уникальные Семена Растений"
	contains = list(/obj/item/seeds/nettle,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/replicapod,
					/obj/item/seeds/nymph,
					/obj/item/seeds/nymph,
					/obj/item/seeds/nymph,
					/obj/item/seeds/plump,
					/obj/item/seeds/liberty,
					/obj/item/seeds/amanita,
					/obj/item/seeds/reishi,
					/obj/item/seeds/banana,
					/obj/item/seeds/bamboo,
					/obj/item/seeds/eggplant/eggy,
					/obj/item/seeds/random,
					/obj/item/seeds/random)
	cost = 15
	containername = "Уникальные семена растений"

/datum/supply_packs/organic/hydroponics/beekeeping_fullkit
	name = "Набор Пчеловода"
	contains = list(/obj/structure/beebox/unwrenched,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/honey_frame,
					/obj/item/queen_bee/bought,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/melee/flyswatter)
	cost = 15
	containername = "Набор пчеловода"

/datum/supply_packs/organic/hydroponics/beekeeping_suits
	name = "2 Набора Одежды Пчеловода"
	contains = list(/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit,
					/obj/item/clothing/head/beekeeper_head,
					/obj/item/clothing/suit/beekeeper_suit)
	cost = 10
	containername = "2 набора одежды пчеловода"

//Bottler
/datum/supply_packs/organic/bottler
	name = "Устройство Розлива"
	contains = list(/obj/machinery/bottler,
					/obj/item/wrench)
	cost = 35
	containername = "Устройство розлива"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Materials ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/materials
	name = "HEADER"
	group = SUPPLY_MATERIALS
	announce_beacons = list("Engineering" = list("Engineering", "Chief Engineer's Desk", "Atmospherics"))


/datum/supply_packs/materials/metal50
	name = "Набор Металла - 50х"
	contains = list(/obj/item/stack/sheet/metal)
	amount = 50
	cost = 10
	containername = "Набор металла - 50х"

/datum/supply_packs/materials/plasteel20
	name = "Набор Пластали - 20х"
	contains = list(/obj/item/stack/sheet/plasteel/lowplasma)
	amount = 20
	cost = 30
	containername = "Набор пластали - 20х"

/datum/supply_packs/materials/plasteel50
	name = "Набор Пластали - 50х"
	contains = list(/obj/item/stack/sheet/plasteel/lowplasma)
	amount = 50
	cost = 60
	containername = "Набор пластали - 50х"

/datum/supply_packs/materials/glass50
	name = "Набор Стекла - 50х"
	contains = list(/obj/item/stack/sheet/glass)
	amount = 50
	cost = 10
	containername = "Набор стекла - 50х"

/datum/supply_packs/materials/wood30
	name = "Набор Досок - 30х"
	contains = list(/obj/item/stack/sheet/wood)
	amount = 30
	cost = 15
	containername = "Набор досок - 30х"

/datum/supply_packs/materials/cardboard50
	name = "Набор Картона - 50х"
	contains = list(/obj/item/stack/sheet/cardboard)
	amount = 50
	cost = 10
	containername = "Набор картона - 50х"

/datum/supply_packs/materials/sandstone30
	name = "Набор Песчаника - 30х"
	contains = list(/obj/item/stack/sheet/mineral/sandstone)
	amount = 30
	cost = 20
	containername = "Набор песчаника - 30х"


/datum/supply_packs/materials/plastic30
	name = "Набор Пластика - 30х"
	contains = list(/obj/item/stack/sheet/plastic)
	amount = 30
	cost = 20
	containername = "Набор пластика - 30х"

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Miscellaneous ///////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/misc
	name = "HEADER"
	group = SUPPLY_MISC

/datum/supply_packs/misc/mule
	name = "МУЛЕбот"
	contains = list(/mob/living/simple_animal/bot/mulebot)
	cost = 20
	containertype = /obj/structure/largecrate/mule
	containername = "МУЛЕбот"

/datum/supply_packs/misc/watertank
	name = "Бак С Водой"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "Бак с водой"

/datum/supply_packs/misc/hightank
	name = "Большой Бак С Водой"
	contains = list(/obj/structure/reagent_dispensers/watertank/high)
	cost = 12
	containertype = /obj/structure/largecrate
	containername = "Большой бак с водой"

/datum/supply_packs/misc/lasertag
	name = "Набор Лазертага"
	contains = list(/obj/item/gun/energy/laser/tag/red,
					/obj/item/gun/energy/laser/tag/red,
					/obj/item/gun/energy/laser/tag/red,
					/obj/item/gun/energy/laser/tag/blue,
					/obj/item/gun/energy/laser/tag/blue,
					/obj/item/gun/energy/laser/tag/blue,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/redtag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/suit/bluetag,
					/obj/item/clothing/head/helmet/redtaghelm,
					/obj/item/clothing/head/helmet/bluetaghelm)
	cost = 15
	containername = "Набор лазертага"

/datum/supply_packs/misc/religious_supplies
	name = "Набор Священника"
	contains = list(/obj/item/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/reagent_containers/food/drinks/bottle/holywater,
					/obj/item/storage/bible/booze,
					/obj/item/storage/bible/booze,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/suit/hooded/chaplain_hoodie,
					/obj/item/clothing/under/burial,
					/obj/item/clothing/under/burial)
	cost = 40
	containername = "Набор священника"

/datum/supply_packs/misc/minerkit
	name = "Набор Шахтера"
	cost = 30
	access = ACCESS_QM
	contains = list(/obj/item/storage/backpack/duffel/mining_conscript)
	containertype = /obj/structure/closet/crate/secure
	containername = "Набор шахтера"


///////////// Paper Work

/datum/supply_packs/misc/paper
	name = "Набор Канцелярии Для Карго"
	contains = list(/obj/structure/filingcabinet/chestdrawer,
					/obj/item/camera_film,
					/obj/item/hand_labeler,
					/obj/item/hand_labeler_refill,
					/obj/item/hand_labeler_refill,
					/obj/item/stack/tape_roll,
					/obj/item/paper_bin,
					/obj/item/pen,
					/obj/item/pen/blue,
					/obj/item/pen/red,
					/obj/item/stamp/denied,
					/obj/item/stamp/granted,
					/obj/item/folder/blue,
					/obj/item/folder/red,
					/obj/item/folder/yellow,
					/obj/item/clipboard,
					/obj/item/clipboard)
	cost = 15
	containername = "Набор канцелярии для карго"

/datum/supply_packs/misc/book_crate
	name = "Набор Книг"
	contains = list(/obj/item/book/codex_gigas)
	cost = 15
	containername = "Набор книг"

/datum/supply_packs/misc/book_crate/New()
	contains += pick(subtypesof(/obj/item/book/manual))
	contains += pick(subtypesof(/obj/item/book/manual))
	contains += pick(subtypesof(/obj/item/book/manual))
	contains += pick(subtypesof(/obj/item/book/manual))
	..()

/datum/supply_packs/misc/tape
	name = "Скотч"
	contains = list(/obj/item/stack/tape_roll,
	/obj/item/stack/tape_roll,
	/obj/item/stack/tape_roll)
	cost = 10
	containername = "Скотч"
	containertype = /obj/structure/closet/crate/tape

/datum/supply_packs/misc/toner
	name = "Набор Катриджей"
	contains = list(/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner,
					/obj/item/toner)
	cost = 10
	containername = "Набор катриджей"

/datum/supply_packs/misc/artscrafts
	name = "Набор Для Украшения Станции"
	contains = list(/obj/item/storage/fancy/crayons,
	/obj/item/camera,
	/obj/item/camera_film,
	/obj/item/camera_film,
	/obj/item/storage/photo_album,
	/obj/item/stack/packageWrap,
	/obj/item/reagent_containers/glass/paint/red,
	/obj/item/reagent_containers/glass/paint/green,
	/obj/item/reagent_containers/glass/paint/blue,
	/obj/item/reagent_containers/glass/paint/yellow,
	/obj/item/reagent_containers/glass/paint/violet,
	/obj/item/reagent_containers/glass/paint/black,
	/obj/item/reagent_containers/glass/paint/white,
	/obj/item/reagent_containers/glass/paint/remover,
	/obj/item/poster/random_official,
	/obj/item/stack/wrapping_paper,
	/obj/item/stack/wrapping_paper,
	/obj/item/stack/wrapping_paper)
	cost = 10
	containername = "Набор для украшения станции"

/datum/supply_packs/misc/posters
	name = "Набор Постеров Корпорации"
	contains = list(/obj/item/poster/random_official,
					/obj/item/poster/random_official,
					/obj/item/poster/random_official,
					/obj/item/poster/random_official,
					/obj/item/poster/random_official)
	cost = 8
	containername = "Набор постеров корпорации"

///////////// Janitor Supplies

/datum/supply_packs/misc/janitor
	name = "Набор Уборщика"
	contains = list(/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/reagent_containers/glass/bucket,
					/obj/item/mop,
					/obj/item/caution,
					/obj/item/caution,
					/obj/item/caution,
					/obj/item/storage/bag/trash,
					/obj/item/reagent_containers/spray/cleaner,
					/obj/item/reagent_containers/glass/rag,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner,
					/obj/item/grenade/chem_grenade/cleaner)
	cost = 10
	containername = "Набор уборщика"
	announce_beacons = list("Janitor" = list("Janitorial"))

/datum/supply_packs/misc/janitor/janicart
	name = "Тележка Уборщика И Галоши"
	contains = list(/obj/structure/janitorialcart,
					/obj/item/clothing/shoes/galoshes)
	cost = 10
	containertype = /obj/structure/largecrate
	containername = "Тележка уборщика и галоши"

/datum/supply_packs/misc/janitor/janitank
	name = "Рюкзак-Баллон Уборщика"
	contains = list(/obj/item/watertank/janitor)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Рюкзак-баллон уборщика"
	access = ACCESS_JANITOR

/datum/supply_packs/misc/janitor/lightbulbs
	name = "Набор Запасных Лампочек"
	contains = list(/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed,
					/obj/item/storage/box/lights/mixed)
	cost = 10
	containername = "Набор запасных лампочек"

/datum/supply_packs/misc/noslipfloor
	name = "Нескользящий Пол - 20х"
	contains = list(/obj/item/stack/tile/noslip/loaded)
	cost = 20
	containername = "Нескользящий пол - 20х"

///////////// Costumes

/datum/supply_packs/misc/costume
	name = "Набор Костюмов"
	contains = list(/obj/item/storage/backpack/clown,
					/obj/item/clothing/shoes/clown_shoes,
					/obj/item/clothing/mask/gas/clown_hat,
					/obj/item/clothing/under/rank/clown,
					/obj/item/bikehorn,
					/obj/item/storage/backpack/mime,
					/obj/item/clothing/under/mime,
					/obj/item/clothing/shoes/black,
					/obj/item/clothing/gloves/color/white,
					/obj/item/clothing/mask/gas/mime,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/suit/suspenders,
					/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
					/obj/item/reagent_containers/food/drinks/bottle/bottleofbanana
					)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Набор костюмов"
	access = ACCESS_THEATRE

/datum/supply_packs/misc/wizard
	name = "Набор Волшебника"
	contains = list(/obj/item/twohanded/staff,
					/obj/item/clothing/suit/wizrobe/fake,
					/obj/item/clothing/shoes/sandal,
					/obj/item/clothing/head/wizard/fake)
	cost = 20
	containername = "Набор волшебника"

/datum/supply_packs/misc/mafia
	name = "Набор Мафиозника"
	contains = list(/obj/item/clothing/suit/browntrenchcoat,
					/obj/item/clothing/suit/blacktrenchcoat,
					/obj/item/clothing/head/fedora/whitefedora,
					/obj/item/clothing/head/fedora/brownfedora,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/under/flappers,
					/obj/item/clothing/under/mafia,
					/obj/item/clothing/under/mafia/vest,
					/obj/item/clothing/under/mafia/white,
					/obj/item/clothing/under/mafia/sue,
					/obj/item/clothing/under/mafia/tan,
					/obj/item/gun/projectile/shotgun/toy/tommygun,
					/obj/item/gun/projectile/shotgun/toy/tommygun)
	cost = 15
	containername = "Набор Мафиозника"

/datum/supply_packs/misc/sunglasses
	name = "Солнцезащитные Очки"
	contains = list(/obj/item/clothing/glasses/sunglasses,
					/obj/item/clothing/glasses/sunglasses,
					/obj/item/clothing/glasses/sunglasses)
	cost = 30
	containername = "Солнцезащитные очки"
/datum/supply_packs/misc/randomised
	var/num_contained = 3 //number of items picked to be contained in a randomised crate
	contains = list(/obj/item/clothing/head/collectable/chef,
					/obj/item/clothing/head/collectable/paper,
					/obj/item/clothing/head/collectable/tophat,
					/obj/item/clothing/head/collectable/captain,
					/obj/item/clothing/head/collectable/beret,
					/obj/item/clothing/head/collectable/welding,
					/obj/item/clothing/head/collectable/flatcap,
					/obj/item/clothing/head/collectable/pirate,
					/obj/item/clothing/head/collectable/kitty,
					/obj/item/clothing/head/crown/fancy,
					/obj/item/clothing/head/collectable/rabbitears,
					/obj/item/clothing/head/collectable/wizard,
					/obj/item/clothing/head/collectable/hardhat,
					/obj/item/clothing/head/collectable/HoS,
					/obj/item/clothing/head/collectable/thunderdome,
					/obj/item/clothing/head/collectable/swat,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/police,
					/obj/item/clothing/head/collectable/slime,
					/obj/item/clothing/head/collectable/xenom,
					/obj/item/clothing/head/collectable/petehat)
	name = "Набор Случайных Коллекционных Головных Уборов"
	cost = 200
	containername = "Набор случайных коллекционных головных уборов от Bass.inc!"

/datum/supply_packs/misc/randomised/New()
	manifest += "Содержит любые [num_contained] из:"
	..()


/datum/supply_packs/misc/foamforce
	name = "Набор Игрушечных Ружей"
	contains = list(/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy,
					/obj/item/gun/projectile/shotgun/toy)
	cost = 10
	containername = "Набор игрушечных ружей"

/datum/supply_packs/misc/foamforce/bonus
	name = "Набор Игрушечных Пистолетов"
	contains = list(/obj/item/gun/projectile/automatic/toy/pistol,
					/obj/item/gun/projectile/automatic/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol,
					/obj/item/ammo_box/magazine/toy/pistol)
	cost = 40
	containername = "Набор игрушечных пистолетов"
	contraband = 1

/datum/supply_packs/misc/bigband
	name = "Набор Музыкальных Инструментов"
	contains = list(/obj/item/instrument/violin,
					/obj/item/instrument/guitar,
					/obj/item/instrument/eguitar,
					/obj/item/instrument/glockenspiel,
					/obj/item/instrument/accordion,
					/obj/item/instrument/saxophone,
					/obj/item/instrument/trombone,
					/obj/item/instrument/recorder,
					/obj/item/instrument/harmonica,
					/obj/item/instrument/xylophone,
					/obj/structure/piano)
	cost = 50
	containername = "Набор музыкальных инструментов"

/datum/supply_packs/misc/randomised/contraband
	num_contained = 5
	contains = list(/obj/item/storage/pill_bottle/random_drug_bottle,
					/obj/item/poster/random_contraband,
					/obj/item/storage/fancy/cigarettes/dromedaryco,
					/obj/item/storage/fancy/cigarettes/cigpack_shadyjims)
	name = "Ящик Контрабанды"
	cost = 30
	containername = "Ящик"	//let's keep it subtle, eh?
	contraband = 1

/datum/supply_packs/misc/formalwear //This is a very classy crate.
	name = "Набор Униформы И Одежды"
	contains = list(/obj/item/clothing/under/blacktango,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/assistantformal,
					/obj/item/clothing/under/lawyer/bluesuit,
					/obj/item/clothing/suit/storage/lawyer/bluejacket,
					/obj/item/clothing/under/lawyer/purpsuit,
					/obj/item/clothing/suit/storage/lawyer/purpjacket,
					/obj/item/clothing/under/lawyer/black,
					/obj/item/clothing/suit/storage/lawyer/blackjacket,
					/obj/item/clothing/accessory/waistcoat,
					/obj/item/clothing/accessory/blue,
					/obj/item/clothing/accessory/red,
					/obj/item/clothing/accessory/black,
					/obj/item/clothing/head/bowlerhat,
					/obj/item/clothing/head/fedora,
					/obj/item/clothing/head/flatcap,
					/obj/item/clothing/head/beret,
					/obj/item/clothing/head/that,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/shoes/laceup,
					/obj/item/clothing/under/suit_jacket/charcoal,
					/obj/item/clothing/under/suit_jacket/navy,
					/obj/item/clothing/under/suit_jacket/burgundy,
					/obj/item/clothing/under/suit_jacket/checkered,
					/obj/item/clothing/under/suit_jacket/tan,
					/obj/item/lipstick/random)
	cost = 30 //Lots of very expensive items. You gotta pay up to look good!
	containername = "Набор униформы и одежды"

/datum/supply_packs/misc/teamcolors		//For team sports like space polo
	name = "Набор Для Отдыха На Пляже"
	// 4 red jerseys, 4 blue jerseys, and 1 beach ball
	contains = list(/obj/item/clothing/under/color/red/jersey,
					/obj/item/clothing/under/color/red/jersey,
					/obj/item/clothing/under/color/red/jersey,
					/obj/item/clothing/under/color/red/jersey,
					/obj/item/clothing/under/color/blue/jersey,
					/obj/item/clothing/under/color/blue/jersey,
					/obj/item/clothing/under/color/blue/jersey,
					/obj/item/clothing/under/color/blue/jersey,
					/obj/item/beach_ball)
	cost = 15
	containername = "Набор для отдыха на пляже"

/datum/supply_packs/misc/polo			//For space polo! Or horsehead Quiditch
	name = "Набор Для Развлечения"
	// 6 brooms, 6 horse masks for the brooms, and 1 beach ball
	contains = list(/obj/item/twohanded/staff/broom,
					/obj/item/twohanded/staff/broom,
					/obj/item/twohanded/staff/broom,
					/obj/item/twohanded/staff/broom,
					/obj/item/twohanded/staff/broom,
					/obj/item/twohanded/staff/broom,
					/obj/item/clothing/mask/horsehead,
					/obj/item/clothing/mask/horsehead,
					/obj/item/clothing/mask/horsehead,
					/obj/item/clothing/mask/horsehead,
					/obj/item/clothing/mask/horsehead,
					/obj/item/clothing/mask/horsehead,
					/obj/item/beach_ball)
	cost = 20
	containername = "Набор для развлечения"

/datum/supply_packs/misc/boxing			//For non log spamming cargo brawls!
	name = "Набор Перчаток Для Бокса"
	// 4 boxing gloves
	contains = list(/obj/item/clothing/gloves/boxing/blue,
					/obj/item/clothing/gloves/boxing/green,
					/obj/item/clothing/gloves/boxing/yellow,
					/obj/item/clothing/gloves/boxing)
	cost = 15
	containername = "Набор перчаток для бокса"

///////////// Station Goals

/datum/supply_packs/misc/station_goal
	name = "Empty Station Goal Crate"
	cost = 10
	special = TRUE
	containername = "empty station goal crate"
	containertype = /obj/structure/closet/crate/engineering

/datum/supply_packs/misc/station_goal/bsa
	name = "Платы Bluespace Артиллерии"
	cost = 150
	contains = list(/obj/item/circuitboard/machine/bsa/front,
					/obj/item/circuitboard/machine/bsa/middle,
					/obj/item/circuitboard/machine/bsa/back,
					/obj/item/circuitboard/computer/bsa_control
					)
	containername = "Платы Bluespace артиллерии"


/datum/supply_packs/misc/station_goal/bluespace_tap
	name = "Платы Bluespace Сборщика"
	cost = 150
	contains = list(
					/obj/item/circuitboard/machine/bluespace_tap,
					/obj/item/paper/bluespace_tap
					)
	containername = "Платы Bluespace сборщика"

/datum/supply_packs/misc/station_goal/dna_vault
	name = "Плата Для Постройки ДНК Хранилища"
	cost = 120
	contains = list(
					/obj/item/circuitboard/machine/dna_vault
					)
	containername = "Плата для постройки ДНК хранилища"

/datum/supply_packs/misc/station_goal/dna_probes
	name = "Сборщики ДНК"
	cost = 30
	contains = list(/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe,
					/obj/item/dna_probe
					)
	containername = "Сборщики ДНК"

/datum/supply_packs/misc/station_goal/shield_sat
	name = "Набор Щитов От Метеоров"
	cost = 30
	contains = list(
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield,
					/obj/machinery/satellite/meteor_shield
					)
	containername = "Набор щитов от метеоров"

/datum/supply_packs/misc/station_goal/shield_sat_control
	name = "Консоль Управления Метеоритными Щитами"
	cost = 50
	contains = list(
					/obj/item/circuitboard/computer/sat_control
					)
	containername = "Консоль управления метеоритными щитами"

///////////// Bathroom Fixtures

/datum/supply_packs/misc/toilet
	name = "Набор Для Уборной"
	cost = 10
	contains = list(
					/obj/item/bathroom_parts,
					/obj/item/bathroom_parts/urinal
					)
	containername = "Набор для уборной"

/datum/supply_packs/misc/hygiene
	name = "Набор Для Гигиены"
	cost = 10
	contains = list(
					/obj/item/bathroom_parts/sink,
					/obj/item/mounted/shower
					)
	containername = "Набор для гигиены"

/datum/supply_packs/misc/snow_machine
	name = "Ящик Снегоуборочной Машины"
	cost = 20
	contains = list(
					/obj/machinery/snow_machine
					)
	special = TRUE

//////////////////////////////////////////////////////////////////////////////
//////////////////////////// Vending /////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

/datum/supply_packs/vending
	name = "HEADER"
	group = SUPPLY_VEND

/datum/supply_packs/vending/autodrobe
	name = "Набор Пополнения Автоматов Autodrobe"
	contains = list(/obj/item/vending_refill/autodrobe)
	cost = 15
	containername = "Набор пополнения автоматов Autodrobe"

/datum/supply_packs/vending/clothes
	name = "Набор Пополнения Автоматов ClothesMate"
	contains = list(/obj/item/vending_refill/clothing)
	cost = 15
	containername = "Набор пополнения автоматов ClothesMate"

/datum/supply_packs/vending/suit
	name = "Костюм Лорда"
	contains = list(/obj/item/vending_refill/suitdispenser)
	cost = 15
	containername = "Костюм лорда"

/datum/supply_packs/vending/hat
	name = "Набор Пополнения Автоматов Hatlord"
	contains = list(/obj/item/vending_refill/hatdispenser)
	cost = 15
	containername = "Набор пополнения автоматов Hatlord"

/datum/supply_packs/vending/shoes
	name = "Набор Пополнения Автоматов Shoelord"
	contains = list(/obj/item/vending_refill/shoedispenser)
	cost = 15
	containername = "Набор пополнения автоматов Shoelord"

/datum/supply_packs/vending/pets
	name = "Набор Пополнения Автоматов CritterCare"
	contains = list(/obj/item/vending_refill/crittercare)
	cost = 15
	containername = "Набор пополнения автоматов CritterCare"

/datum/supply_packs/vending/bartending
	name = "Набор Пополнения Автоматов Booze-o-mat И Coffee"
	cost = 20
	contains = list(/obj/item/vending_refill/boozeomat,
					/obj/item/vending_refill/coffee)
	containername = "Набор пополнения автоматов Booze-o-mat и Coffee"
	announce_beacons = list("Bar" = list("Bar"))

/datum/supply_packs/vending/cigarette
	name = "Набор Пополнения Автоматов Cigarette"
	contains = list(/obj/item/vending_refill/cigarette)
	cost = 15
	containername = "Набор пополнения автоматов Cigarette"
	containertype = /obj/structure/closet/crate

/datum/supply_packs/vending/dinnerware
	name = "Набор Пополнения Автоматов Chef's Dinnerware"
	cost = 10
	contains = list(/obj/item/vending_refill/dinnerware)
	containername = "Набор пополнения автоматов Chef's Dinnerware"

/datum/supply_packs/vending/imported
	name = "Набор Пополнения Автоматов Robotech"
	cost = 40
	contains = list(/obj/item/vending_refill/sustenance,
					/obj/item/vending_refill/robotics,
					/obj/item/vending_refill/sovietsoda,
					/obj/item/vending_refill/engineering)
	containername = "Набор пополнения автоматов Robotech"

/datum/supply_packs/vending/ptech
	name = "Набор Пополнения Автоматов PTech"
	cost = 15
	contains = list(/obj/item/vending_refill/cart)
	containername = "Набор пополнения автоматов PTech"

/datum/supply_packs/vending/snack
	name = "Набор Пополнения Автоматов Getmore Chocolate"
	contains = list(/obj/item/vending_refill/snack)
	cost = 15
	containername = "Набор пополнения автоматов Getmore Chocolate"

/datum/supply_packs/vending/cola
	name = "Набор Пополнения Автоматов Robust Softdrinks"
	contains = list(/obj/item/vending_refill/cola)
	cost = 15
	containername = "Набор пополнения автоматов Robust Softdrinks"

/datum/supply_packs/vending/vendomat
	name = "Набор Пополнения Автоматов Vendomat"
	cost = 10
	contains = list(/obj/item/vending_refill/assist)
	containername = "Набор пополнения автоматов Vendomat"

/datum/supply_packs/vending/chinese
	name = "Набор Пополнения Автоматов MrChangs"
	contains = list(/obj/item/vending_refill/chinese)
	cost = 15
	containername = "Набор пополнения автоматов MrChangs"
