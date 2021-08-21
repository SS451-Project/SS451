/////////////////////////////////////////////
//Guest pass ////////////////////////////////
/////////////////////////////////////////////
/obj/item/card/id/guest
	name = "Гостевой пропуск"
	desc = "Обеспечивает временный доступ к отделам станций."
	icon_state = "guest"

	var/temp_access = list() //to prevent agent cards stealing access as permanent
	var/expiration_time = 0
	var/reason = "НЕ УКАЗАНО"

/obj/item/card/id/guest/GetAccess()
	if(world.time > expiration_time)
		return access
	else
		return temp_access

/obj/item/card/id/guest/examine(mob/user)
	. = ..()
	if(world.time < expiration_time)
		. += "<span class='notice'>Срок действия этого пропуска истекает через [station_time_timestamp("hh:mm:ss", expiration_time)].</span>"
	else
		. += "<span class='warning'>Срок его действия истек уже как [station_time_timestamp("hh:mm:ss", expiration_time)].</span>"
	. += "<span class='notice'>Он предоставляет доступ к следующим отделам:</span>"
	for(var/A in temp_access)
		. += "<span class='notice'>[get_access_desc(A)].</span>"
	. += "<span class='notice'>Причина выдачи: [reason].</span>"

/////////////////////////////////////////////
//Guest pass terminal////////////////////////
/////////////////////////////////////////////

/obj/machinery/computer/guestpass
	name = "Терминал гостевого пропуска"
	icon_state = "guest"
	icon_screen = "pass"
	icon_keyboard = null
	density = 0


	var/obj/item/card/id/giver
	var/list/accesses = list()
	var/giv_name = "НЕ УКАЗАНО"
	var/reason = "НЕ УКАЗАНО"
	var/duration = 5

	var/list/internal_log = list()
	var/mode = 0  // 0 - making pass, 1 - viewing logs

/obj/machinery/computer/guestpass/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/card/id))
		if(!giver)
			if(user.drop_item())
				I.forceMove(src)
				giver = I
				updateUsrDialog()
		else
			to_chat(user, "<span class='warning'>Внутри уже есть ID-карта.</span>")
		return
	return ..()

/obj/machinery/computer/guestpass/proc/get_changeable_accesses()
	return giver.access

/obj/machinery/computer/guestpass/attack_ai(mob/user)
	return attack_hand(user)


/obj/machinery/computer/guestpass/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.set_machine(src)
	var/dat = {"<meta charset="UTF-8">"}

	if(mode == 1) //Logs
		dat += "<h3>Журнал действий</h3><br>"
		for(var/entry in internal_log)
			dat += "[entry]<br><hr>"
		dat += "<a href='?src=[UID()];action=print'>Печать</a><br>"
		dat += "<a href='?src=[UID()];mode=0'>Назад</a><br>"
	else
		dat += "<h3>Терминал гостевого пропуска #[uid]</h3><br>"
		dat += "<a href='?src=[UID()];mode=1'>Просмотр журнала действий</a><br><br>"
		dat += "Используемая ID-карта: <a href='?src=[UID()];action=id'>[giver]</a><br>"
		dat += "Выдано: <a href='?src=[UID()];choice=giv_name'>[giv_name]</a><br>"
		dat += "Причина: <a href='?src=[UID()];choice=reason'>[reason]</a><br>"
		dat += "Продолжительность (минуты): <a href='?src=[UID()];choice=duration'>[duration] m</a><br>"
		dat += "Доступ в:<br>"
		if(giver && giver.access)
			for(var/A in get_changeable_accesses())
				var/area = get_access_desc(A)
				if(A in accesses)
					area = "<b>[area]</b>"
				dat += "<a href='?src=[UID()];choice=access;access=[A]'>[area]</a><br>"
		dat += "<br><a href='?src=[UID()];action=issue'>Выдать пропуск</a><br>"

	var/datum/browser/popup = new(user, "guestpass", name, 400, 520)
	popup.set_content(dat)
	popup.open(0)
	onclose(user, "guestpass")


/obj/machinery/computer/guestpass/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if(href_list["mode"])
		mode = text2num(href_list["mode"])

	if(href_list["choice"])
		switch(href_list["choice"])
			if("giv_name")
				var/nam = strip_html_simple(input("Пропуск выдается на человека...", "Имя", giv_name) as text|null)
				if(nam)
					giv_name = nam
			if("reason")
				var/reas = strip_html_simple(input("Причина, по которой выдается пропуск", "Причина", reason) as text|null)
				if(reas)
					reason = reas
			if("duration")
				var/dur = input("Продолжительность (в минутах), в течение которой действителен пропуск (до 30 минут).", "Продолжительность") as num|null
				if(dur)
					if(dur > 0 && dur <= 30)
						duration = dur
					else
						to_chat(usr, "<span class='warning'>Недопустимая продолжительность.</span>")
			if("access")
				var/A = text2num(href_list["access"])
				if(A in accesses)
					accesses.Remove(A)
				else
					if(giver && giver.access && (A in get_changeable_accesses()))
						accesses.Add(A)
	if(href_list["action"])
		switch(href_list["action"])
			if("id")
				if(giver)
					if(ishuman(usr))
						giver.loc = usr.loc
						if(!usr.get_active_hand())
							usr.put_in_hands(giver)
						giver = null
					else
						giver.loc = src.loc
						giver = null
					accesses.Cut()
				else
					var/obj/item/I = usr.get_active_hand()
					if(istype(I, /obj/item/card/id))
						usr.drop_item()
						I.loc = src
						giver = I
				updateUsrDialog()

			if("print")
				var/dat = "<h3>Журнал активности терминала гостевого пропуска #[uid]</h3><br>"
				for(var/entry in internal_log)
					dat += "[entry]<br><hr>"
//				to_chat(usr, "Printing the log, standby...")
				//sleep(50)
				var/obj/item/paper/P = new/obj/item/paper( loc )
				playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, 1)
				P.name = "activity log"
				P.info = dat

			if("issue")
				if(giver)
					var/number = add_zero("[rand(0,9999)]", 4)
					var/entry = "\[[station_time()]\] Доступ #[number] выдан [giver.registered_name] ([giver.assignment]) для [giv_name]. Причина: [reason]. Предоставляется доступ к следующим зонам: "
					for(var/i=1 to accesses.len)
						var/A = accesses[i]
						if(A)
							var/area = get_access_desc(A)
							entry += "[i > 1 ? ", [area]" : "[area]"]"
					entry += ". Истекает через [station_time(world.time + duration*10*60)]."
					internal_log.Add(entry)

					var/obj/item/card/id/guest/pass = new(src.loc)
					pass.temp_access = accesses.Copy()
					pass.registered_name = giv_name
					pass.expiration_time = world.time + duration*10*60
					pass.reason = reason
					pass.name = "Гостевой пропуск #[number]"
				else
					to_chat(usr, "<span class='warning'>Невозможно выдать пропуск без ID-карты.</span>")
	updateUsrDialog()
	return

/obj/machinery/computer/guestpass/hop
	name = "Терминал гостевого пропуска Главы Персонала"

/obj/machinery/computer/guestpass/hop/get_changeable_accesses()
	. = ..()
	if(. && (ACCESS_CHANGE_IDS in .))
		return get_all_accesses()
