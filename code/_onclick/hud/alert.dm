//A system to manage and display alerts on screen without needing you to do it yourself

//PUBLIC -  call these wherever you want


/mob/proc/throw_alert(category, type, severity, obj/new_master, override = FALSE, timeout_override, no_anim)

/*
 Proc to create or update an alert. Returns the alert if the alert is new or updated, 0 if it was thrown already
 category is a text string. Each mob may only have one alert per category; the previous one will be replaced
 path is a type path of the actual alert type to throw
 severity is an optional number that will be placed at the end of the icon_state for this alert
 For example, high pressure's icon_state is "highpressure" and can be serverity 1 or 2 to get "highpressure1" or "highpressure2"
 new_master is optional and sets the alert's icon state to "template" in the ui_style icons with the master as an overlay.
 Clicks are forwarded to master
 Override makes it so the alert is not replaced until cleared by a clear_alert with clear_override, and it's used for hallucinations.
 */

	if(!category)
		return

	var/obj/screen/alert/alert = LAZYACCESS(alerts, category)
	if(alert)
		if(alert.override_alerts)
			return 0
		if(new_master && new_master != alert.master)
			WARNING("[src] threw alert [category] with new_master [new_master] while already having that alert with master [alert.master]")
			clear_alert(category)
			return .()
		else if(alert.type != type)
			clear_alert(category)
			return .()
		else if(!severity || severity == alert.severity)
			if(alert.timeout)
				clear_alert(category)
				return .()
			else //no need to update
				return 0
	else
		alert = new type()
		alert.override_alerts = override
		if(override)
			alert.timeout = null

	if(new_master)
		var/old_layer = new_master.layer
		var/old_plane = new_master.plane
		new_master.layer = FLOAT_LAYER
		new_master.plane = FLOAT_PLANE
		alert.overlays += new_master
		new_master.layer = old_layer
		new_master.plane = old_plane
		alert.icon_state = "template" // We'll set the icon to the client's ui pref in reorganize_alerts()
		alert.master = new_master
	else
		alert.icon_state = "[initial(alert.icon_state)][severity]"
		alert.severity = severity

	LAZYSET(alerts, category, alert) // This also creates the list if it doesn't exist
	if(client && hud_used)
		hud_used.reorganize_alerts()

	if(!no_anim)
		alert.transform = matrix(32, 6, MATRIX_TRANSLATE)
		animate(alert, transform = matrix(), time = 2.5, easing = CUBIC_EASING)

	var/timeout = timeout_override || alert.timeout
	if(timeout)
		addtimer(CALLBACK(alert, /obj/screen/alert/.proc/do_timeout, src, category), timeout)
		alert.timeout = world.time + timeout - world.tick_lag

	return alert

// Proc to clear an existing alert.
/mob/proc/clear_alert(category, clear_override = FALSE)
	var/obj/screen/alert/alert = LAZYACCESS(alerts, category)
	if(!alert)
		return 0
	if(alert.override_alerts && !clear_override)
		return 0

	alerts -= category
	if(client && hud_used)
		hud_used.reorganize_alerts()
		client.screen -= alert
	qdel(alert)

/obj/screen/alert
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "default"
	name = "Тревога"
	desc = "Похоже, что-то пошло не так с этим предупреждением, поэтому сообщите об этой ошибке, пожалуйста."
	mouse_opacity = MOUSE_OPACITY_ICON
	var/timeout = 0 //If set to a number, this alert will clear itself after that many deciseconds
	var/severity = 0
	var/alerttooltipstyle = ""
	var/override_alerts = FALSE //If it is overriding other alerts of the same type

/obj/screen/alert/MouseEntered(location,control,params)
	openToolTip(usr, src, params, title = name, content = desc, theme = alerttooltipstyle)


/obj/screen/alert/MouseExited()
	closeToolTip(usr)

/obj/screen/alert/proc/do_timeout(mob/M, category)
	if(!M || !M.alerts)
		return

	if(timeout && M.alerts[category] == src && world.time >= timeout)
		M.clear_alert(category)

//Gas alerts
/obj/screen/alert/not_enough_oxy
	name = "Удушье (без O2)"
	desc = "Тебе не хватает кислорода! Подыши свежим воздухом, прежде чем отключиться! В коробке твоего рюкзаке есть кислородный баллон и дыхательная маска."
	icon_state = "not_enough_oxy"

/obj/screen/alert/too_much_oxy
	name = "Удушье (O2)"
	desc = "В воздухе слишком много кислорода, а ты его вдыхаешь! Подыши свежим воздухом, прежде чем отключиться!"
	icon_state = "too_much_oxy"

/obj/screen/alert/not_enough_nitro
    name = "Удушье (без N)"
    desc = "Тебе не хватает азота! Подыши свежим воздухом, прежде чем отключиться!"
    icon_state = "not_enough_nitro"

/obj/screen/alert/too_much_nitro
    name = "Удушье (N)"
    desc = "В воздухе слишком много азота, а ты его вдыхаешь! Подыши свежим воздухом, прежде чем отключиться!"
    icon_state = "too_much_nitro"

/obj/screen/alert/not_enough_co2
	name = "Удушье (без CO2)"
	desc = "Ты получаешь недостаточно углекислого газа! Подыши свежим воздухом, прежде чем отключиться!"
	icon_state = "not_enough_co2"

/obj/screen/alert/too_much_co2
	name = "Удушье (CO2)"
	desc = "В воздухе слишком много углекислого газа, и ты вдыхаешь его! Подыши свежим воздухом, прежде чем отключиться!"
	icon_state = "too_much_co2"

/obj/screen/alert/not_enough_tox
	name = "Удушье (без плазмы)"
	desc = "Тебе не хватает плазмы! Подыши свежим воздухом, прежде чем отключиться!"
	icon_state = "not_enough_tox"

/obj/screen/alert/too_much_tox
	name = "Удушье (плазма)"
	desc = "В воздухе есть легковоспламеняющаяся, токсичная плазма, и ты вдыхаешь ее! Найди немного свежего воздуха. В коробке твоего рюкзаке есть кислородный баллон и дыхательная маска."
	icon_state = "too_much_tox"
//End gas alerts


/obj/screen/alert/fat
	name = "Ожирение"
	desc = "Ты сожрал слишком много, придурок. Побегай по станции и немного похудей."
	icon_state = "fat"

/obj/screen/alert/full
	name = "Сытый"
	desc = "Ты чувствуешь себя сытым и удовлетворенным, но не следует есть больше."
	icon_state = "full"

/obj/screen/alert/well_fed
	name = "Упитанный"
	desc = "Ты чувствуешь себя вполне удовлетворенным, но, можно съесть немного больше."
	icon_state = "well_fed"

/obj/screen/alert/fed
	name = "Накормлен"
	desc = "Ты чувствуешь умеренное удовлетворение, но немного больше еды не повредит."
	icon_state = "fed"

/obj/screen/alert/hungry
	name = "Голод"
	desc = "Прямо сейчас неплохо бы найти чего поесть."
	icon_state = "hungry"

/obj/screen/alert/starving
	name = "Изголодание"
	desc = "Ты сильно недоедаешь. Боли от голода превращают передвижение в рутинную работу."
	icon_state = "starving"

///Vampire "hunger"

/obj/screen/alert/fat/vampire
	name = "Ожирение"
	desc = "Ты выпил слишком много крови, придурок. Побегай по станции и немного похудей."
	icon_state = "v_fat"

/obj/screen/alert/full/vampire
	name = "Сытый"
	desc = "Ты чувствуешь себя сытым и удовлетворенным, но ты знаешь, что скоро будешь жаждать еще крови..."
	icon_state = "v_full"

/obj/screen/alert/well_fed/vampire
	name = "Упитанный"
	desc = "Ты чувствуешь себя вполне удовлетворенным, но тебе не помешало бы немного больше крови."
	icon_state = "v_well_fed"

/obj/screen/alert/fed/vampire
	name = "Накормлен"
	desc = "Ты чувствуешь умеренное удовлетворение, но немного больше крови не повредит."
	icon_state = "v_fed"

/obj/screen/alert/hungry/vampire
	name = "Голод"
	desc = "В настоящее время ты жаждешь крови."
	icon_state = "v_hungry"

/obj/screen/alert/starving/vampire
	name = "Изголодание"
	desc = "Ты сильно хочешь кровь. Боли от жажды превращают передвижение в рутинную работу."
	icon_state = "v_starving"

//End of Vampire "hunger"


/obj/screen/alert/hot
	name = "Очень горячо"
	desc = "Ты чертовски горишь! Найдите где-нибудь место попрохладнее и снимите любую изолирующую одежду, например пожарный костюм."
	icon_state = "hot"

/obj/screen/alert/hot/robot
    desc = "Воздух вокруг тебя слишком горячий для гуманоидов. Будьте осторожны, чтобы не подвергать их воздействию этой среды."

/obj/screen/alert/cold
	name = "Очень холодно"
	desc = "Ты совсем замерз! Найдите место потеплее и снимите любую изолирующую одежду, например скафандр."
	icon_state = "cold"

/obj/screen/alert/cold/drask
    name = "Холод"
    desc = "Ты дышишь переохлажденным газом! Это стимулирует ваш метаболизм для регенерации поврежденных тканей."

/obj/screen/alert/cold/robot
    desc = "Воздух вокруг тебя слишком холодный для гуманоидов. Будь осторожен, чтобы не подвергать их воздействию этой среды."

/obj/screen/alert/lowpressure
	name = "Низкое давление"
	desc = "Воздух вокруг вас опасно разражен. Скафандр защитил бы тебя."
	icon_state = "lowpressure"

/obj/screen/alert/highpressure
	name = "Высокое давление"
	desc = "Воздух вокруг тебя опасно густой. Пожарный костюм защитил бы тебя."
	icon_state = "highpressure"

/obj/screen/alert/lightexposure
	name = "Воздействие света"
	desc = "Ты подвергаешься воздействию света."
	icon_state = "lightexposure"

/obj/screen/alert/nolight
	name = "Никакого света"
	desc = "Ты не подвергаешься воздействию какого-либо источника света."
	icon_state = "nolight"

/obj/screen/alert/blind
	name = "Слепота"
	desc = "Ты ничего не видишь! Это может быть вызвано генетическим дефектом, травмой глаза, нахождением в бессознательном состоянии, \
или что-то закрыло тебе глаза."
	icon_state = "blind"

/obj/screen/alert/high
	name = "Под кайфом"
	desc = "Чувааааак! Будь осторожен, чтобы стать зависимым... или типо того."
	icon_state = "high"

/obj/screen/alert/drunk
	name = "Пьяный"
	desc = "Весь алкоголь, который ты употребил, ухудшает речь, двигательные навыки и умственные способности."
	icon_state = "drunk"

/obj/screen/alert/embeddedobject
	name = "Застрявший объект"
	desc = "Что-то застряло в твоей плоти и вызывает сильное кровотечение. Со временем может и выпасть, но хирургия - самый безопасный способ. \
Если ты чувствуешь себя адекватно, щелкни по себе с интентом 'Помощь', чтобы вытащить объект."
	icon_state = "embeddedobject"

/obj/screen/alert/embeddedobject/Click()
	if(isliving(usr))
		var/mob/living/carbon/human/M = usr
		return M.help_shake_act(M)

/obj/screen/alert/asleep
	name = "Сон"
	desc = "Ты заснул. Подожди немного, и ты должен проснуться. Если только ты этого не сделаешь, учитывая, насколько ты беспомощен сейчас."
	icon_state = "asleep"

/obj/screen/alert/weightless
	name = "Невесомость"
	desc = "Гравитация перестала влиять на вас, и вы бесцельно парите вокруг. Вам понадобится что-нибудь большое и тяжелое, например \
стена или решетка, чтобы оттолкнуться, если вы хотите двигаться. Реактивный ранец обеспечивал бы свободный диапазон движения. Пара из \
магботов позволили бы вам нормально ходить по полу. За исключением этого, вы можете бросать вещи, использовать огнетушитель, \
или стреляйте из пистолета, чтобы передвигаться по 3-му закону движения Ньютона."
	icon_state = "weightless"

/obj/screen/alert/fire
	name = "В огне!"
	desc = "Ты горишь! Остановись, падай и катайся, чтобы потушить огонь или уйди в зону вакуума!"
	icon_state = "fire"

/obj/screen/alert/fire/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()


//ALIENS

/obj/screen/alert/alien_tox
	name = "Плазма"
	desc = "В воздухе есть воспламеняющаяся плазма. Если она загорится, ты поджаришься."
	icon_state = "alien_tox"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_fire
// This alert is temporarily gonna be thrown for all hot air but one day it will be used for literally being on fire
	name = "Слишком жарко"
	desc = "Здесь слишком жарко! Бегите в космос или, по крайней мере, подальше от пламени. Остановившись на траве - ты исцелишься."
	icon_state = "alien_fire"
	alerttooltipstyle = "alien"

/obj/screen/alert/alien_vulnerable
	name = "Конец матриархата"
	desc = "Ваша королева была убита, вы понесете наказание за перемещение и потерю разума. Новую королеву нельзя сделать, пока вы не восстановитесь."
	icon_state = "alien_noqueen"
	alerttooltipstyle = "alien"

//BLOBS

/obj/screen/alert/nofactory
	name = "Нет фабрики"
	desc = "У вас нет фабрики, и вы медленно умираете!"
	icon_state = "blobbernaut_nofactory"
	alerttooltipstyle = "blob"

//SILICONS

/obj/screen/alert/nocell
	name = "Missing Power Cell"
	desc = "Unit has no power cell. No modules available until a power cell is reinstalled. Robotics may provide assistance."
	icon_state = "nocell"

/obj/screen/alert/emptycell
	name = "Out of Power"
	desc = "Unit's power cell has no charge remaining. No modules available until power cell is recharged. \
Recharging stations are available in robotics, the dormitory bathrooms, and the AI satellite."
	icon_state = "emptycell"

/obj/screen/alert/lowcell
	name = "Low Charge"
	desc = "Unit's power cell is running low. Recharging stations are available in robotics, the dormitory bathrooms, and the AI satellite."
	icon_state = "lowcell"

//Diona Nymph
/obj/screen/alert/nymph
	name = "Gestalt merge"
	desc = "You have merged with a diona gestalt and are now part of it's biomass. You can still wiggle yourself free though."

/obj/screen/alert/nymph/Click()
	if(!usr || !usr.client)
		return
	if(isnymph(usr))
		var/mob/living/simple_animal/diona/D = usr
		return D.resist()

//Need to cover all use cases - emag, illegal upgrade module, malf AI hack, traitor cyborg
/obj/screen/alert/hacked
	name = "Hacked"
	desc = "Hazardous non-standard equipment detected. Please ensure any usage of this equipment is in line with unit's laws, if any."
	icon_state = "hacked"

/obj/screen/alert/locked
	name = "Locked Down"
	desc = "Unit has been remotely locked down. Usage of a Robotics Control Console like the one in the Research Director's \
office by your AI master or any qualified human may resolve this matter. Robotics may provide further assistance if necessary."
	icon_state = "locked"

/obj/screen/alert/newlaw
	name = "Law Update"
	desc = "Laws have potentially been uploaded to or removed from this unit. Please be aware of any changes \
so as to remain in compliance with the most up-to-date laws."
	icon_state = "newlaw"
	timeout = 300

/obj/screen/alert/hackingapc
	name = "Hacking APC"
	desc = "An Area Power Controller is being hacked. When the process is \
		complete, you will have exclusive control of it, and you will gain \
		additional processing time to unlock more malfunction abilities."
	icon_state = "hackingapc"
	timeout = 600
	var/atom/target = null

/obj/screen/alert/hackingapc/Destroy()
	target = null
	return ..()

/obj/screen/alert/hackingapc/Click()
	if(!usr || !usr.client)
		return
	if(!target)
		return
	var/mob/living/silicon/ai/AI = usr
	var/turf/T = get_turf(target)
	if(T)
		AI.eyeobj.setLoc(T)

//MECHS
/obj/screen/alert/low_mech_integrity
	name = "Mech Damaged"
	desc = "Mech integrity is low."
	icon_state = "low_mech_integrity"

/obj/screen/alert/mech_port_available
	name = "Connect to Port"
	desc = "Click here to connect to an air port and refill your oxygen!"
	icon_state = "mech_port"
	var/obj/machinery/atmospherics/unary/portables_connector/target = null

/obj/screen/alert/mech_port_available/Destroy()
	target = null
	return ..()

/obj/screen/alert/mech_port_available/Click()
	if(!usr || !usr.client)
		return
	if(!istype(usr.loc, /obj/mecha) || !target)
		return
	var/obj/mecha/M = usr.loc
	if(M.connect(target))
		to_chat(usr, "<span class='notice'>[M] connects to the port.</span>")
	else
		to_chat(usr, "<span class='notice'>[M] failed to connect to the port.</span>")

/obj/screen/alert/mech_port_disconnect
	name = "Disconnect from Port"
	desc = "Click here to disconnect from your air port."
	icon_state = "mech_port_x"

/obj/screen/alert/mech_port_disconnect/Click()
	if(!usr || !usr.client)
		return
	if(!istype(usr.loc, /obj/mecha))
		return
	var/obj/mecha/M = usr.loc
	if(M.disconnect())
		to_chat(usr, "<span class='notice'>[M] disconnects from the port.</span>")
	else
		to_chat(usr, "<span class='notice'>[M] is not connected to a port at the moment.</span>")

/obj/screen/alert/mech_nocell
	name = "Missing Power Cell"
	desc = "Mech has no power cell."
	icon_state = "nocell"

/obj/screen/alert/mech_emptycell
	name = "Out of Power"
	desc = "Mech is out of power."
	icon_state = "emptycell"

/obj/screen/alert/mech_lowcell
	name = "Low Charge"
	desc = "Mech is running out of power."
	icon_state = "lowcell"

/obj/screen/alert/mech_maintenance
	name = "Maintenance Protocols"
	desc = "Maintenance protocols are currently in effect, most actions disabled."
	icon_state = "locked"

//GUARDIANS
/obj/screen/alert/cancharge
	name = "Charge Ready"
	desc = "You are ready to charge at a location!"
	icon_state = "guardian_charge"
	alerttooltipstyle = "parasite"

/obj/screen/alert/canstealth
	name = "Stealth Ready"
	desc = "You are ready to enter stealth!"
	icon_state = "guardian_canstealth"
	alerttooltipstyle = "parasite"

/obj/screen/alert/instealth
	name = "In Stealth"
	desc = "You are in stealth and your next attack will do bonus damage!"
	icon_state = "guardian_instealth"
	alerttooltipstyle = "parasite"


//GHOSTS
//TODO: expand this system to replace the pollCandidates/CheckAntagonist/"choose quickly"/etc Yes/No messages
/obj/screen/alert/notify_cloning
	name = "Revival"
	desc = "Someone is trying to revive you. Re-enter your corpse if you want to be revived!"
	icon_state = "template"
	timeout = 300

/obj/screen/alert/notify_cloning/Click()
	if(!usr || !usr.client)
		return
	var/mob/dead/observer/G = usr
	G.reenter_corpse()

/obj/screen/alert/notify_action
	name = "Body created"
	desc = "A body was created. You can enter it."
	icon_state = "template"
	timeout = 300
	var/atom/target = null
	var/action = NOTIFY_JUMP
	var/show_time_left = FALSE // If true you need to call START_PROCESSING manually
	var/image/time_left_overlay // The last image showing the time left
	var/datum/candidate_poll/poll // If set, on Click() it'll register the player as a candidate

/obj/screen/alert/notify_action/process()
	if(show_time_left)
		var/timeleft = timeout - world.time
		if(timeleft <= 0)
			return PROCESS_KILL

		if(time_left_overlay)
			overlays -= time_left_overlay

		var/obj/O = new
		O.maptext = "<span style='font-family: \"Small Fonts\"; font-weight: bold; font-size: 32px; color: [(timeleft <= 10 SECONDS) ? "red" : "white"];'>[CEILING(timeleft / 10, 1)]</span>"
		O.maptext_width = O.maptext_height = 128
		var/matrix/M = new
		M.Translate(4, 16)
		O.transform = M

		var/image/I = image(O)
		I.layer = FLOAT_LAYER
		I.plane = FLOAT_PLANE + 1
		overlays += I

		time_left_overlay = I
		qdel(O)
	..()

/obj/screen/alert/notify_action/Destroy()
	target = null
	return ..()

/obj/screen/alert/notify_action/Click()
	if(!usr || !usr.client)
		return
	var/mob/dead/observer/G = usr
	if(!istype(G))
		return

	if(poll)
		if(poll.sign_up(G))
			// Add a small overlay to indicate we've signed up
			display_signed_up()
	else if(target)
		switch(action)
			if(NOTIFY_ATTACK)
				target.attack_ghost(G)
			if(NOTIFY_JUMP)
				var/turf/T = get_turf(target)
				if(T && isturf(T))
					G.loc = T
			if(NOTIFY_FOLLOW)
				G.ManualFollow(target)

/obj/screen/alert/notify_action/Topic(href, href_list)
	if(href_list["signup"] && poll?.sign_up(usr))
		display_signed_up()

/obj/screen/alert/notify_action/proc/display_signed_up()
	var/image/I = image('icons/mob/screen_gen.dmi', icon_state = "selector")
	I.layer = FLOAT_LAYER
	I.plane = FLOAT_PLANE + 2
	overlays += I

/obj/screen/alert/notify_action/proc/display_stacks(stacks = 1)
	if(stacks <= 1)
		return

	var/obj/O = new
	O.maptext = "<span style='font-family: \"Small Fonts\"; font-size: 32px; color: yellow;'>[stacks]x</span>"
	O.maptext_width = O.maptext_height = 128
	var/matrix/M = new
	M.Translate(4, 2)
	O.transform = M

	var/image/I = image(O)
	I.layer = FLOAT_LAYER
	I.plane = FLOAT_PLANE + 1
	overlays += I

	qdel(O)

/obj/screen/alert/notify_soulstone
	name = "Soul Stone"
	desc = "Someone is trying to capture your soul in a soul stone. Click to allow it."
	icon_state = "template"
	timeout = 10 SECONDS
	var/obj/item/soulstone/stone = null
	var/stoner = null

/obj/screen/alert/notify_soulstone/Click()
	if(!usr || !usr.client)
		return
	if(stone)
		if(alert(usr, "Do you want to be captured by [stoner]'s soul stone? This will destroy your corpse and make it \
		impossible for you to get back into the game as your regular character.",, "No", "Yes") ==  "Yes")
			stone.opt_in = TRUE

/obj/screen/alert/notify_soulstone/Destroy()
	stone = null
	return ..()


//OBJECT-BASED

/obj/screen/alert/restrained/buckled
	name = "Buckled"
	desc = "You've been buckled to something. Click the alert to unbuckle unless you're handcuffed."
	icon_state = "buckled"

/obj/screen/alert/restrained/handcuffed
	name = "Handcuffed"
	desc = "You're handcuffed and can't act. If anyone drags you, you won't be able to move. Click the alert to free yourself."

/obj/screen/alert/restrained/legcuffed
	name = "Legcuffed"
	desc = "You're legcuffed, which slows you down considerably. Click the alert to free yourself."

/obj/screen/alert/restrained/Click()
	if(isliving(usr))
		var/mob/living/L = usr
		return L.resist()

/obj/screen/alert/restrained/buckled/Click()
	var/mob/living/L = usr
	if(!istype(L) || !L.can_resist())
		return
	L.changeNext_move(CLICK_CD_RESIST)
	if(L.last_special <= world.time)
		return L.resist_buckle()

// PRIVATE = only edit, use, or override these if you're editing the system as a whole

// Re-render all alerts - also called in /datum/hud/show_hud() because it's needed there
/datum/hud/proc/reorganize_alerts()
	var/list/alerts = mymob.alerts
	if(!alerts)
		return FALSE
	var/icon_pref
	if(!hud_shown)
		for(var/i in 1 to alerts.len)
			mymob.client.screen -= alerts[alerts[i]]
		return TRUE
	for(var/i in 1 to alerts.len)
		var/obj/screen/alert/alert = alerts[alerts[i]]
		if(alert.icon_state == "template")
			if(!icon_pref)
				icon_pref = ui_style2icon(mymob.client.prefs.UI_style)
			alert.icon = icon_pref
		switch(i)
			if(1)
				. = ui_alert1
			if(2)
				. = ui_alert2
			if(3)
				. = ui_alert3
			if(4)
				. = ui_alert4
			if(5)
				. = ui_alert5 // Right now there's 5 slots
			else
				. = ""
		alert.screen_loc = .
		mymob.client.screen |= alert
	return TRUE

/mob
	var/list/alerts // lazy list. contains /obj/screen/alert only // On /mob so clientless mobs will throw alerts properly

/obj/screen/alert/Click(location, control, params)
	if(!usr || !usr.client)
		return
	var/paramslist = params2list(params)
	if(paramslist["shift"]) // screen objects don't do the normal Click() stuff so we'll cheat
		to_chat(usr, "<span class='boldnotice'>[name]</span> - <span class='info'>[desc]</span>")
		return
	if(master)
		return usr.client.Click(master, location, control, params)

/obj/screen/alert/Destroy()
	severity = 0
	master = null
	screen_loc = ""
	return ..()
