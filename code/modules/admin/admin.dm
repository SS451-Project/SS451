GLOBAL_VAR_INIT(BSACooldown, 0)
GLOBAL_VAR_INIT(nologevent, 0)

////////////////////////////////
/proc/message_admins(var/msg)
	msg = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[msg]</span></span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.prefs && !(C.prefs.toggles & PREFTOGGLE_CHAT_NO_ADMINLOGS))
				to_chat(C, msg)

/proc/msg_admin_attack(var/text, var/loglevel)
	if(!GLOB.nologevent)
		var/rendered = "<span class=\"admin\"><span class=\"prefix\">ATTACK:</span> <span class=\"message\">[text]</span></span>"
		for(var/client/C in GLOB.admins)
			if(R_ADMIN & C.holder.rights)
				if(C.prefs.atklog == ATKLOG_NONE)
					continue
				var/msg = rendered
				if(C.prefs.atklog <= loglevel)
					to_chat(C, msg)

/**
 * Sends a message to the staff able to see admin tickets
 * Arguments:
 * msg - The message being send
 * important - If the message is important. If TRUE it will ignore the CHAT_NO_TICKETLOGS preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_adminTicket(msg, important = FALSE)
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			if(important || (C.prefs && !(C.prefs.toggles & PREFTOGGLE_CHAT_NO_TICKETLOGS)))
				to_chat(C, msg)
			if(important)
				if(C.prefs?.sound & SOUND_ADMINHELP)
					SEND_SOUND(C, 'sound/effects/adminhelp.ogg')
				window_flash(C)

/**
 * Sends a message to the staff able to see mentor tickets
 * Arguments:
 * msg - The message being send
 * important - If the message is important. If TRUE it will ignore the CHAT_NO_TICKETLOGS preferences,
               send a sound and flash the window. Defaults to FALSE
 */
/proc/message_mentorTicket(msg, important = FALSE)
	for(var/client/C in GLOB.admins)
		if(check_rights(R_ADMIN | R_MENTOR | R_MOD, 0, C.mob))
			if(important || (C.prefs && !(C.prefs.toggles & PREFTOGGLE_CHAT_NO_TICKETLOGS)))
				to_chat(C, msg)
			if(important)
				if(C.prefs?.sound & SOUND_MENTORHELP)
					SEND_SOUND(C, 'sound/effects/adminhelp.ogg')
				window_flash(C)

/proc/admin_ban_mobsearch(var/mob/M, var/ckey_to_find, var/mob/admin_to_notify)
	if(!M || !M.ckey)
		if(ckey_to_find)
			for(var/mob/O in GLOB.mob_list)
				if(O.ckey && O.ckey == ckey_to_find)
					if(admin_to_notify)
						to_chat(admin_to_notify, "<span class='warning'>admin_ban_mobsearch: Player [ckey_to_find] is now in mob [O]. Pulling data from new mob.</span>")
						return O
			if(admin_to_notify)
				to_chat(admin_to_notify, "<span class='warning'>admin_ban_mobsearch: Player [ckey_to_find] does not seem to have any mob, anywhere. This is probably an error.</span>")
		else if(admin_to_notify)
			to_chat(admin_to_notify, "<span class='warning'>admin_ban_mobsearch: No mob or ckey detected.</span>")
	return M

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/datum/admins/proc/show_player_panel(var/mob/M in GLOB.mob_list)
	set category = null
	set name = "Панель игрока"
	set desc="Edit player (respawn, ban, heal, etc)"

	if(!M)
		to_chat(usr, "Похоже, вы выбираете моба, которого больше не существует.")
		return

	if(!check_rights(R_ADMIN|R_MOD))
		return

	var/body = {"<html><meta charset="UTF-8"><head><title>Настройки для [M.key]</title></head>"}
	body += "<body>Настройки для <b>[M]</b>"
	if(M.client)
		body += " - Ckey: <b>[M.client]</b> "
		if(check_rights(R_PERMISSIONS, 0))
			body += "\[<A href='?_src_=holder;editrights=rank;ckey=[M.ckey]'>[M.client.holder ? M.client.holder.rank : "Player"]</A>\] "
		else
			body += "\[[M.client.holder ? M.client.holder.rank : "Player"]\] "
		body += "\[<A href='?_src_=holder;getplaytimewindow=[M.UID()]'>" + M.client.get_exp_type(EXP_TYPE_CREW) + " за [EXP_TYPE_CREW]</a>\]"
		body += "<br>Дата регистрации учетной записи BYOND: [M.client.byondacc_date || "ОШИБКА"] [M.client.byondacc_age <= config.byond_account_age_threshold ? "<b>" : ""]([M.client.byondacc_age] дней назад)[M.client.byondacc_age <= config.byond_account_age_threshold ? "</b>" : ""]"
		body += "<br>Поиск в базе данных глобального бана: [config.centcom_ban_db_url ? "<a href='?_src_=holder;open_ccbdb=[M.client.ckey]'>Просмотреть</a>" : "<i>Отключено</i>"]"

		body += "<br>"

	if(isnewplayer(M))
		body += " <B>Еще не вступил в игру</B> "
	else
		body += " \[<A href='?_src_=holder;revive=[M.UID()]'>Вылечить</A>\] "


	body += "<br><br>\[ "
	body += "<a href='?_src_=holder;open_logging_view=[M.UID()];'>ЛОГИ</a> - "
	body += "<a href='?_src_=vars;Vars=[M.UID()]'>VV</a> - "
	body += "[ADMIN_TP(M,"TP")] - "
	if(M.client)
		body += "<a href='?src=[usr.UID()];priv_msg=[M.client.ckey]'>PM</a> - "
		body += "[ADMIN_SM(M,"SM")] - "
	if(ishuman(M) && M.mind)
		body += "<a href='?_src_=holder;HeadsetMessage=[M.UID()]'>HM</a> -"
	body += "[admin_jump_link(M)]\] </b><br>"
	body += "<b>Тип моба:</b> [M.type]<br>"
	if(M.client)
		if(M.client.prefs.discord_id)
			if(length(M.client.prefs.discord_id) < 32)
				body += "<b>Discord:</b>  <@[M.client.prefs.discord_id]>  <b>[M.client.prefs.discord_name]</b><br>"
			else
				body += "<b>Discord: Привязка не завершена!</b><br>"
		if(M.client.related_accounts_cid.len)
			body += "<b>Связанные учетные записи по CID:</b> [jointext(M.client.related_accounts_cid, " - ")]<br>"
		if(M.client.related_accounts_ip.len)
			body += "<b>Связанные учетные записи по IP:</b> [jointext(M.client.related_accounts_ip, " - ")]<br><br>"

	if(M.ckey)
		body += "<A href='?_src_=holder;boot2=[M.UID()]'>Кик</A> | "
		body += "<A href='?_src_=holder;warn=[M.ckey]'>Варн</A> | "
		body += "<A href='?_src_=holder;newban=[M.UID()];dbbanaddckey=[M.ckey]'>Бан</A> | "
		body += "<A href='?_src_=holder;jobban2=[M.UID()];dbbanaddckey=[M.ckey]'>Джоббан</A> | "
		body += "<A href='?_src_=holder;appearanceban=[M.UID()];dbbanaddckey=[M.ckey]'>Бан На Появление</A> | "
		body += "<A href='?_src_=holder;randomizename=[M.UID()]'>Случайное Имя</A> | "
		body += "<A href='?_src_=holder;shownoteckey=[M.ckey]'>Заметки</A> | "
		body += "<A href='?_src_=holder;geoip=[M.UID()]'>GeoIP</A> | "
		if(config.forum_playerinfo_url)
			body += "<A href='?_src_=holder;webtools=[M.ckey]'>WebInfo</A> | "
	if(M.client)
		if(check_watchlist(M.client.ckey))
			body += "<A href='?_src_=holder;watchremove=[M.ckey]'>Убрать Из Watchlist</A> | "
			body += "<A href='?_src_=holder;watchedit=[M.ckey]'>Изменить Причину Watchlist</A> "
		else
			body += "<A href='?_src_=holder;watchadd=[M.ckey]'>Добавить В Watchlist</A> "

		body += "| <A href='?_src_=holder;sendtoprison=[M.UID()]'>Тюрьма</A> | "
		body += "\ <A href='?_src_=holder;sendbacktolobby=[M.UID()]'>Отправить Обратно В Лобби</A> | "
		body += "\ <A href='?_src_=holder;eraseflavortext=[M.UID()]'>Стереть Текст Описания</A> | "
		body += "\ <A href='?_src_=holder;userandomname=[M.UID()]'>Использовать Случайное Имя</A> | "
		var/muted = M.client.prefs.muted
		body += {"<br><b>Мут: </b>
			\[<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_IC]'><font color='[(muted & MUTE_IC)?"red":"#6685f5"]'>IC</font></a> |
			<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_OOC]'><font color='[(muted & MUTE_OOC)?"red":"#6685f5"]'>OOC</font></a> |
			<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_PRAY]'><font color='[(muted & MUTE_PRAY)?"red":"#6685f5"]'>Молиться</font></a> |
			<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_ADMINHELP]'><font color='[(muted & MUTE_ADMINHELP)?"red":"#6685f5"]'>ADMINHELP</font></a> |
			<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_DEADCHAT]'><font color='[(muted & MUTE_DEADCHAT)?"red":"#6685f5"]'>Чат за мёртвых</font></a>\]
			(<A href='?_src_=holder;mute=[M.UID()];mute_type=[MUTE_ALL]'><font color='[(muted & MUTE_ALL)?"red":"#6685f5"]'>ВСЁ</font></a>)
		"}

	var/jumptoeye = ""
	if(isAI(M))
		var/mob/living/silicon/ai/A = M
		if(A.client && A.eyeobj) // No point following clientless AI eyes
			jumptoeye = " <b>(<A href='?_src_=holder;jumpto=[A.eyeobj.UID()]'>Следить</A>)</b>"
	body += {"<br><br>
		<A href='?_src_=holder;jumpto=[M.UID()]'><b>Прыжок: К Нему</b></A>[jumptoeye] |
		<A href='?_src_=holder;getmob=[M.UID()]'>Его К Себе</A> |
		<A href='?_src_=holder;sendmob=[M.UID()]'>Отправить В</A>
		<br><br>
		[check_rights(R_ADMIN,0) ? "[ADMIN_TP(M,"Панель предателей")] | " : "" ]
		<A href='?_src_=holder;narrateto=[M.UID()]'>Сказать (может не заметить сообщение)</A> |
		[ADMIN_SM(M,"Послание (Ты слышишь голос в голове...)")]
	"}

	if(check_rights(R_EVENT, 0))
		body += {" | <A href='?_src_=holder;Bless=[M.UID()]'>Благословить</A> | <A href='?_src_=holder;Smite=[M.UID()]'>Покарать</A>"}

	if(isLivingSSD(M))
		if(istype(M.loc, /obj/machinery/cryopod))
			body += {" | <A href='?_src_=holder;cryossd=[M.UID()]'>Де-Спавнуть</A> "}
		else
			body += {" | <A href='?_src_=holder;cryossd=[M.UID()]'>Отправить В Крио</A> "}

	if(M.client)
		if(!isnewplayer(M))
			body += "<br><br>"
			body += "<b>Превращение:</b>"
			body += "<br>"

			//Monkey
			if(issmall(M))
				body += "<B>Обезьяна</B> | "
			else
				body += "<A href='?_src_=holder;monkeyone=[M.UID()]'>Обезьяна</A> | "

			//Corgi
			if(iscorgi(M))
				body += "<B>Корги</B> | "
			else
				body += "<A href='?_src_=holder;corgione=[M.UID()]'>Корги</A> | "

			//AI / Cyborg
			if(isAI(M))
				body += "<B>Уже ИИ</B> "
			else if(ishuman(M))
				body += {"<A href='?_src_=holder;makeai=[M.UID()]'>Сделать ИИ</A> |
					<A href='?_src_=holder;makerobot=[M.UID()]'>Сделать Роботом</A> |
					<A href='?_src_=holder;makealien=[M.UID()]'>Сделать Чужим</A> |
					<A href='?_src_=holder;makeslime=[M.UID()]'>Сделать Слаймом</A> |
					<A href='?_src_=holder;makesuper=[M.UID()]'>Сделать Супергероем</A>
				"}

			//Simple Animals
			if(isanimal(M))
				body += "<A href='?_src_=holder;makeanimal=[M.UID()]'>Другое Животное</A> | "
			else
				body += "<A href='?_src_=holder;makeanimal=[M.UID()]'>Животное</A> | "

			if(istype(M, /mob/dead/observer))
				body += "<A href='?_src_=holder;incarn_ghost=[M.UID()]'>Реинкарнировать</a> | "
				body += {"<A href='?_src_=holder;togglerespawnability=[M.UID()]'>Вкл Способность Респавна</A> | "}

			if(ispAI(M))
				body += "<B>Уже пИИ</B> "
			else
				body += "<A href='?_src_=holder;makePAI=[M.UID()]'>Сделать пИИ</A> | "

			// DNA2 - Admin Hax
			if(M.dna && iscarbon(M))
				body += "<br><br>"
				body += "<b>Блоки ДНК:</b><br><table border='0'><tr><th>&nbsp;</th><th>1</th><th>2</th><th>3</th><th>4</th><th>5</th>"
				var/bname
				for(var/block=1;block<=DNA_SE_LENGTH;block++)
					if(((block-1)%5)==0)
						body += "</tr><tr><th>[block-1]</th>"
					bname = GLOB.assigned_blocks[block]
					body += "<td>"
					if(bname)
						var/bstate=M.dna.GetSEState(block)
						var/bcolor="[(bstate)?"#006600":"#ff0000"]"
						body += "<A href='?_src_=holder;togmutate=[M.UID()];block=[block]' style='color:[bcolor];'>[bname]</A><sub>[block]</sub>"
					else
						body += "[block]"
					body+="</td>"
				body += "</tr></table>"

			body += {"<br><br>
				<b>Рудиментарная трансформация:</b><font size=2><br>Эти преобразования только создают новый тип моба и копируют его. Они не учитывают MMIS и аналогичные специфические для мобов вещи. Кнопки в разделе 'Превращение' предпочтительнее, если это возможно.</font><br>
				<A href='?_src_=holder;simplemake=observer;mob=[M.UID()]'>Наблюдатель</A> |
				\[ Инопланетные: <A href='?_src_=holder;simplemake=drone;mob=[M.UID()]'>Дрон</A>,
				<A href='?_src_=holder;simplemake=hunter;mob=[M.UID()]'>Чужой</A>,
				<A href='?_src_=holder;simplemake=queen;mob=[M.UID()]'>Королева</A>,
				<A href='?_src_=holder;simplemake=sentinel;mob=[M.UID()]'>Страж</A>,
				<A href='?_src_=holder;simplemake=larva;mob=[M.UID()]'>Ларва</A> \]
				<A href='?_src_=holder;simplemake=human;mob=[M.UID()]'>Человек</A>
				\[ слайм: <A href='?_src_=holder;simplemake=slime;mob=[M.UID()]'>Малыш</A>,
				<A href='?_src_=holder;simplemake=adultslime;mob=[M.UID()]'>Взрослый</A> \]
				<A href='?_src_=holder;simplemake=monkey;mob=[M.UID()]'>Обезьяна</A> |
				<A href='?_src_=holder;simplemake=robot;mob=[M.UID()]'>Киборг</A> |
				<A href='?_src_=holder;simplemake=cat;mob=[M.UID()]'>Кот</A> |
				<A href='?_src_=holder;simplemake=runtime;mob=[M.UID()]'>Runtime (кот)</A> |
				<A href='?_src_=holder;simplemake=corgi;mob=[M.UID()]'>Корги</A> |
				<A href='?_src_=holder;simplemake=ian;mob=[M.UID()]'>Иан (корги)</A> |
				<A href='?_src_=holder;simplemake=crab;mob=[M.UID()]'>Краб</A> |
				<A href='?_src_=holder;simplemake=coffee;mob=[M.UID()]'>Билли К. (краб)</A> |
				\[ Конструкты: <A href='?_src_=holder;simplemake=constructarmoured;mob=[M.UID()]'>Джаггернаут</A> ,
				<A href='?_src_=holder;simplemake=constructbuilder;mob=[M.UID()]'>Ремесленник</A> ,
				<A href='?_src_=holder;simplemake=constructwraith;mob=[M.UID()]'>Фантом</A> \]
				<A href='?_src_=holder;simplemake=shade;mob=[M.UID()]'>Тень</A>
			"}

	if(M.client)
		body += {"<br><br>
			<b>Другие действия:</b>
			<br>
			<A href='?_src_=holder;forcespeech=[M.UID()]'>Forcesay</A> |
			<A href='?_src_=holder;aroomwarp=[M.UID()]'>Admin Room</A> |
			<A href='?_src_=holder;tdome1=[M.UID()]'>Thunderdome 1</A> |
			<A href='?_src_=holder;tdome2=[M.UID()]'>Thunderdome 2</A> |
			<A href='?_src_=holder;tdomeadmin=[M.UID()]'>Thunderdome Admin</A> |
			<A href='?_src_=holder;tdomeobserve=[M.UID()]'>Thunderdome Observer</A> |
			<A href='?_src_=holder;contractor_stop=[M.UID()]'>Остановить Тюремное Заключение Синдиката</A> |
			<A href='?_src_=holder;contractor_start=[M.UID()]'>Начать Тюремное Заключение Синдиката</A> |
			<A href='?_src_=holder;contractor_release=[M.UID()]'>Вытащить Из Заключения Синдиката</A> |
		"}

	body += {"<br>
		</body></html>
	"}

	usr << browse(body, "window=adminplayeropts;size=550x615")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Player Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/player_info/var/author // admin who authored the information
/datum/player_info/var/rank //rank of admin who made the notes
/datum/player_info/var/content // text content of the information
/datum/player_info/var/timestamp // Because this is bloody annoying

#define PLAYER_NOTES_ENTRIES_PER_PAGE 50
/datum/admins/proc/PlayerNotes()
	set category = "Admin"
	set name = "Заметки игроков"

	if(!check_rights(R_ADMIN|R_MOD))
		return

	show_note()

/datum/admins/proc/show_player_notes(var/key as text)
	set category = "Admin"
	set name = "Показать заметки"

	if(!check_rights(R_ADMIN|R_MOD))
		return

	show_note(key)

/datum/admins/proc/vpn_whitelist()
	set category = "Admin"
	set name = "VPN Ckey Whitelist"
	if(!check_rights(R_BAN))
		return
	var/key = stripped_input(usr, "Введите ckey для добавления/удаления или оставьте пустым для отмены:", "VPN Whitelist добавить/удалить", max_length=32)
	if(key)
		vpn_whitelist_panel(key)

/datum/admins/proc/Jobbans()
	if(!check_rights(R_BAN))
		return

	var/dat = {"<meta charset="UTF-8"><B>Джоббаны!</B><HR><table>"}
	for(var/t in GLOB.jobban_keylist)
		var/r = t
		if( findtext(r,"##") )
			r = copytext( r, 1, findtext(r,"##") )//removes the description
		dat += text("<tr><td>[t] (<A href='?src=[UID()];removejobban=[r]'>разбанить</A>)</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=400x400")

/datum/admins/proc/Game()
	if(!check_rights(R_ADMIN))
		return

	var/dat = {"<meta charset="UTF-8">
		<center><B>Игровая панель</B></center><hr>\n
		<A href='?src=[UID()];c_mode=1'>Изменение Режима Игры</A><br>
		"}
	if(GLOB.master_mode == "secret")
		dat += "<A href='?src=[UID()];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += {"
		<BR>
		<A href='?src=[UID()];create_object=1'>Создать объект</A><br>
		<A href='?src=[UID()];quick_create_object=1'>Быстрое создание объекта</A><br>
		<A href='?src=[UID()];create_turf=1'>Создать пол</A><br>
		<A href='?src=[UID()];create_mob=1'>Создать моба</A><br>
		"}

	usr << browse(dat, "window=admin2;size=210x280")
	return

/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/datum/admins/proc/restart()
	set category = "Server"
	set name = "Перезапуск"
	set desc = "Перезапустить сервер."

	if(!check_rights(R_SERVER))
		return

	// Give an extra popup if they are rebooting a live server
	var/is_live_server = TRUE
	if(usr.client.is_connecting_from_localhost())
		is_live_server = FALSE

	var/list/options = list("Простой Перезапуск", "Жёсткий Перезапуск")
	if(world.TgsAvailable()) // TGS lets you kill the process entirely
		options += "Завершить процесс (Убить и перезапустить DD)"

	var/result = input(usr, "Выберите метод перезагрузки", "Перезагрузка мира", options[1]) as null|anything in options

	if(is_live_server)
		if(alert(usr, "ВНИМАНИЕ: ЭТО ЖИВОЙ СЕРВЕР, А НЕ ЛОКАЛЬНЫЙ ТЕСТОВЫЙ СЕРВЕР. ВЫ ВСЕ ЕЩЕ ХОТИТЕ ПЕРЕЗАПУСТИТЬ?","Этот сервер живой","Перезапуск","Отменить") != "Перезапуск")
			return FALSE

	if(result)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Reboot World") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		var/init_by = "Инициировано [usr.client.holder.fakekey ? "Admin" : usr.key]."
		switch(result)

			if("Простой Перезапуск")
				var/delay = input("Какая задержка должна быть до перезапуска (в секундах)?", "Задержка перезапуска", 5) as num|null
				if(!delay)
					return FALSE


				// These are pasted each time so that they dont false send if reboot is cancelled
				message_admins("[key_name_admin(usr)] инициировал перезапуск сервера типа [result]")
				log_admin("[key_name(usr)] инициировал перезапуск сервера типа [result]")
				SSticker.delay_end = FALSE // We arent delayed anymore
				SSticker.reboot_helper(init_by, "admin reboot - by [usr.key] [usr.client.holder.fakekey ? "(stealth)" : ""]", delay * 10)

			if("Жёсткий Перезапуск")
				message_admins("[key_name_admin(usr)] инициировал перезапуск сервера типа [result]")
				log_admin("[key_name(usr)] инициировал перезапуск сервера типа [result]")
				world.Reboot(fast_track = TRUE)

			if("Завершить процесс (Убить и перезапустить DD)")
				message_admins("[key_name_admin(usr)] инициировал перезапуск сервера типа [result]")
				log_admin("[key_name(usr)] инициировал перезапуск сервера типа [result]")
				world.TgsEndProcess() // Just nuke the entire process if we are royally fucked

/datum/admins/proc/end_round()
	set category = "Server"
	set name = "Завершить раунд"
	set desc = "Мгновенно завершает раунд и выводит табло, как будто умирает тенеморф или маг."
	if(!check_rights(R_SERVER))
		return
	var/input = sanitize(copytext(input(usr, "What text should players see announcing the round end? Input nothing to cancel.", "Specify Announcement Text", "Shift Has Ended!"), 1, MAX_MESSAGE_LEN))

	if(!input)
		return
	if(SSticker.force_ending)
		return
	message_admins("[key_name_admin(usr)] has admin ended the round with message: '[input]'")
	log_admin("[key_name(usr)] has admin ended the round with message: '[input]'")
	SSticker.force_ending = TRUE
	to_chat(world, "<span class='warning'><big><b>[input]</b></big></span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "End Round") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	SSticker.mode_result = "admin ended"

/datum/admins/proc/announce()
	set category = "Admin"
	set name = "Объявление"
	set desc = "Объявите о своих пожеланиях всему серверу"

	if(!check_rights(R_ADMIN))
		return

	var/message = input("Сообщение для глобального объявления:", "Админ Объявление", null, null) as message|null
	if(message)
		if(!check_rights(R_SERVER,0))
			message = adminscrub(message,500)
		message = replacetext(message, "\n", "<br>") // required since we're putting it in a <p> tag
		to_chat(world, "<span class='notice'><b>[usr.client.holder.fakekey ? "Administrator" : usr.key] Объявляет:</b><p style='text-indent: 50px'>[message]</p></span>")
		log_admin("Announce: [key_name(usr)] : [message]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Announce") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Глобально переключает возможность пользоваться OOC чатом"
	set name="Переключить OOC"

	if(!check_rights(R_ADMIN))
		return

	toggle_ooc()
	log_and_message_admins("[key_name(usr)] переключил OOC.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle OOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Глобально переключает возможность пользоваться локальным OOC чатом"
	set name="Переключить LOOC"

	if(!check_rights(R_ADMIN))
		return

	config.looc_allowed = !(config.looc_allowed)
	if(config.looc_allowed)
		to_chat(world, "<B>Локальный OOC был глобально включен!</B>")
	else
		to_chat(world, "<B>Локальный OOC был глобально отключен!</B>")
	log_and_message_admins("[key_name(usr)] переключил LOOC.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle LOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Переключает возможность пользоваться SAY чатом для мёртвых игроков."
	set name="SAY за мёртвых"

	if(!check_rights(R_ADMIN))
		return

	config.dsay_allowed = !(config.dsay_allowed)
	if(config.dsay_allowed)
		to_chat(world, "<B>'SAY за мёртвых' был глобально включен!</B>")
	else
		to_chat(world, "<B>'SAY за мёртвых' был глобально отключен!</B>")
	log_admin("[key_name(usr)] переключил Deadchat.")
	message_admins("[key_name_admin(usr)] переключил Deadchat.", 1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Deadchat") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Переключает возможность пользоваться OOC чатом для мёртвых игроков."
	set name="OOC за мёртвых"

	if(!check_rights(R_ADMIN))
		return

	config.dooc_allowed = !( config.dooc_allowed )
	if(config.dooc_allowed)
		to_chat(world, "<B>'OOC за мёртвых' был глобально включен!</B>")
	else
		to_chat(world, "<B>'OOC за мёртвых' был глобально отключен!</B>")
	log_admin("[key_name(usr)] переключил Dead OOC.")
	message_admins("[key_name_admin(usr)] переключил Dead OOC.", 1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Dead OOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglevotedead()
	set category = "Server"
	set desc="Переключает возможность голосовать для мёртвых игроков."
	set name="Голоса за мёртвых"

	if(!check_rights(R_ADMIN))
		return

	config.vote_no_dead = !( config.vote_no_dead )
	if(!config.vote_no_dead)
		to_chat(world, "<B>Мертвое голосование было глобально включено!</B>")
	else
		to_chat(world, "<B>Мертвое голосование было глобально отключено!</B>")
	log_admin("[key_name(usr)] переключил Dead Vote.")
	message_admins("[key_name_admin(usr)] переключил Dead Vote.", 1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Dead Vote") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleemoji()
	set category = "Server"
	set desc = "Позволяет переключить возможность отправить эмодзи в OOC :clap:"
	set name = "Эмодзи в OOC"

	if(!check_rights(R_ADMIN))
		return

	config.disable_ooc_emoji = !(config.disable_ooc_emoji)
	log_admin("[key_name(usr)] переключил эмодзи в OOC.")
	message_admins("[key_name_admin(usr)] переключил эмодзи в OOC.", 1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle OOC Emoji")

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Начните раунд ПРЯМО СЕЙЧАС"
	set name="Начать прямо сейчас"

	if(!check_rights(R_SERVER))
		return

	if(!SSticker)
		alert("Не удается запустить игру, так как она не настроена.")
		return

	if(config.start_now_confirmation)
		if(alert(usr, "Это живой сервер. Вы уверены, что хотите начать прямо сейчас?", "Начало игры", "Да", "Нет") != "Да")
			return

	if(SSticker.current_state == GAME_STATE_PREGAME || SSticker.current_state == GAME_STATE_STARTUP)
		SSticker.force_start = TRUE
		log_admin("[usr.key] начал игру принудительно.")
		var/msg = ""
		if(SSticker.current_state == GAME_STATE_STARTUP)
			msg = " (Сервер все еще поднимается, раунд начнется как можно скорее.)"
		message_admins("<span class='darkmblue'>[usr.key] начал игру принудительно.[msg]</span>")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Start Game") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return 1
	else
		to_chat(usr, "<font color='red'>Ошибка: Начать прямо сейчас: Игра уже началась.</font>")
		return

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="Игроки не смогут вступить в игру, если раунд будет идти"
	set name="Переключить вход новых игроков"

	if(!check_rights(R_SERVER))
		return

	GLOB.enter_allowed = !( GLOB.enter_allowed )
	if(!( GLOB.enter_allowed ))
		to_chat(world, "<B>Новые игроки больше не смогут входить в игру.</B>")
	else
		to_chat(world, "<B>Теперь в игру могут вступить новые игроки.</B>")
	log_admin("[key_name(usr)] переключил вход в игру для игроков.")
	message_admins("[key_name_admin(usr)] переключил вход в игру для игроков.", 1)
	world.update_status()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Entering") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Event"
	set desc="Игроки не смогут быть ИИ"
	set name="Переключить ИИ"

	if(!check_rights(R_EVENT))
		return

	config.allow_ai = !( config.allow_ai )
	if(!( config.allow_ai ))
		to_chat(world, "<B>ИИ больше нельзя выбирать как профессию.</B>")
	else
		to_chat(world, "<B>ИИ теперь можно выбирать как профессию.</B>")
	message_admins("[key_name_admin(usr)] разрешил выбирать ИИ.")
	log_admin("[key_name(usr)] разрешил выбирать ИИ.")
	world.update_status()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle AI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Переключите возможность возрождения игроков."
	set name="Переключить респавн"

	if(!check_rights(R_SERVER))
		return

	GLOB.abandon_allowed = !( GLOB.abandon_allowed )
	if(GLOB.abandon_allowed)
		to_chat(world, "<B>Теперь вы можете возродиться.</B>")
	else
		to_chat(world, "<B>Вы больше не можете возрождаться :(</B>")
	message_admins("[key_name_admin(usr)] переключил респавн на [GLOB.abandon_allowed ? "Вкл" : "Выкл"].", 1)
	log_admin("[key_name(usr)] переключил респаун на [GLOB.abandon_allowed ? "Вкл" : "Выкл"].")
	world.update_status()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Respawn") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Задержка начала/окончания игры"
	set name="Задержка"

	if(!check_rights(R_SERVER))
		return

	if(!SSticker || SSticker.current_state != GAME_STATE_PREGAME)
		SSticker.delay_end = !SSticker.delay_end
		log_admin("[key_name(usr)] [SSticker.delay_end ? "отложил окончание раунда" : "перевёл конец раунда в норму"].")
		message_admins("[key_name(usr)] [SSticker.delay_end ? "отложил окончание раунда" : "перевёл конец раунда в норму"].", 1)
		if(SSticker.delay_end)
			SSticker.real_reboot_time = 0 // Immediately show the "Admin delayed round end" message
		return //alert("Round end delayed", null, null, null, null, null)
	if(SSticker.ticker_going)
		SSticker.ticker_going = FALSE
		SSticker.delay_end = TRUE
		to_chat(world, "<b>Начало игры было отложено администратором, ожидайте.</b>")
		log_admin("[key_name(usr)] задержал начало игры.")
	else
		SSticker.ticker_going = TRUE
		to_chat(world, "<b>Игра скоро начнется.</b>")
		log_admin("[key_name(usr)] убрал задержку начала игры.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Delay") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M as mob) // returns 1 for specail characters and 2 for heroes of gamemode
	if(!SSticker || !SSticker.mode)
		return 0
	if(!istype(M))
		return 0
	if((M.mind in SSticker.mode.head_revolutionaries) || (M.mind in SSticker.mode.revolutionaries))
		if(SSticker.mode.config_tag == "revolution")
			return 2
		return 1
	if(M.mind in SSticker.mode.cult)
		if(SSticker.mode.config_tag == "cult")
			return 2
		return 1
	if(M.mind in SSticker.mode.syndicates)
		if(SSticker.mode.config_tag == "nuclear")
			return 2
		return 1
	if(M.mind in SSticker.mode.wizards)
		if(SSticker.mode.config_tag == "wizard")
			return 2
		return 1
	if(M.mind in SSticker.mode.changelings)
		if(SSticker.mode.config_tag == "changeling")
			return 2
		return 1
	if(M.mind in SSticker.mode.abductors)
		if(SSticker.mode.config_tag == "abduction")
			return 2
		return 1
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.emagged)
			return 1
	if(M.mind&&M.mind.special_role)//If they have a mind and special role, they are some type of traitor or antagonist.
		return 1

	return 0

/datum/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc = "(atom path) Spawn an atom"
	set name = "Spawn"

	if(!check_rights(R_SPAWN))
		return

	var/list/types = typesof(/atom)
	var/list/matches = new()

	for(var/path in types)
		if(findtext("[path]", object))
			matches += path

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
		if(!chosen)
			return

	if(ispath(chosen,/turf))
		var/turf/T = get_turf(usr.loc)
		T.ChangeTurf(chosen)
	else
		var/atom/A = new chosen(usr.loc)
		A.admin_spawned = TRUE

	message_admins("[key_name_admin(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Spawn Atom") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/show_traitor_panel(var/mob/M in GLOB.mob_list)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if(!check_rights(R_ADMIN|R_MOD))
		return

	if(!istype(M))
		to_chat(usr, "This can only be used on instances of type /mob")
		return
	if(!M.mind)
		to_chat(usr, "This mob has no mind!")
		return

	M.mind.edit_memory()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Show Traitor Panel") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle Guests"

	if(!check_rights(R_SERVER))
		return

	GLOB.guests_allowed = !( GLOB.guests_allowed )
	if(!( GLOB.guests_allowed ))
		to_chat(world, "<B>Guests may no longer enter the game.</B>")
	else
		to_chat(world, "<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [GLOB.guests_allowed ? "" : "dis"]allowed.")
	message_admins("<span class='notice'>[key_name_admin(usr)] toggled guests game entering [GLOB.guests_allowed ? "" : "dis"]allowed.</span>", 1)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Guests") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/output_ai_laws()
	var/ai_number = 0
	for(var/mob/living/silicon/S in GLOB.mob_list)
		ai_number++
		if(isAI(S))
			to_chat(usr, "<b>AI [key_name(S, TRUE)]'s laws:</b>")
		else if(isrobot(S))
			var/mob/living/silicon/robot/R = S
			to_chat(usr, "<b>CYBORG [key_name(S, TRUE)]'s [R.connected_ai?"(Slaved to: [R.connected_ai])":"(Independent)"] laws:</b>")
		else if(ispAI(S))
			var/mob/living/silicon/pai/P = S
			to_chat(usr, "<b>pAI [key_name(S, TRUE)]'s laws:</b>")
			to_chat(usr, "[P.pai_law0]")
			if(P.pai_laws)
				to_chat(usr, "[P.pai_laws]")
			continue // Skip showing normal silicon laws for pAIs - they don't have any
		else
			to_chat(usr, "<b>SILICON [key_name(S, TRUE)]'s laws:</b>")

		if(S.laws == null)
			to_chat(usr, "[key_name(S, TRUE)]'s laws are null. Contact a coder.")
		else
			S.laws.show_laws(usr)
	if(!ai_number)
		to_chat(usr, "<b>No AI's located.</b>")//Just so you know the thing is actually working and not just ignoring you.


	log_admin("[key_name(usr)] checked the AI laws")
	message_admins("[key_name_admin(usr)] checked the AI laws")

/client/proc/update_mob_sprite(mob/living/carbon/human/H as mob)
	set name = "Update Mob Sprite"
	set desc = "Should fix any mob sprite update errors."
	set category = null

	if(!check_rights(R_ADMIN))
		return

	if(istype(H))
		H.regenerate_icons()

//
//
//ALL DONE
//*********************************************************************************************************

GLOBAL_VAR_INIT(gamma_ship_location, 1) // 0 = station , 1 = space

/proc/move_gamma_ship()
	var/area/fromArea
	var/area/toArea
	if(GLOB.gamma_ship_location == 1)
		fromArea = locate(/area/shuttle/gamma/space)
		toArea = locate(/area/shuttle/gamma/station)
	else
		fromArea = locate(/area/shuttle/gamma/station)
		toArea = locate(/area/shuttle/gamma/space)
	fromArea.move_contents_to(toArea)

	for(var/obj/machinery/mech_bay_recharge_port/P in toArea)
		P.update_recharge_turf()

	if(GLOB.gamma_ship_location)
		GLOB.gamma_ship_location = 0
	else
		GLOB.gamma_ship_location = 1
	return

/proc/formatJumpTo(var/location,var/where="")
	var/turf/loc
	if(istype(location,/turf/))
		loc = location
	else
		loc = get_turf(location)
	if(where=="")
		where=formatLocation(loc)
	return "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[loc.x];Y=[loc.y];Z=[loc.z]'>[where]</a>"

/proc/formatLocation(var/location)
	var/turf/loc
	if(istype(location,/turf/))
		loc = location
	else
		loc = get_turf(location)
	var/area/A = get_area(location)
	return "[A.name] - [loc.x],[loc.y],[loc.z]"

/proc/formatPlayerPanel(var/mob/U,var/text="PP")
	return "[ADMIN_PP(U,"[text]")]"

//Kicks all the clients currently in the lobby. The second parameter (kick_only_afk) determins if an is_afk() check is ran, or if all clients are kicked
//defaults to kicking everyone (afk + non afk clients in the lobby)
//returns a list of ckeys of the kicked clients
/proc/kick_clients_in_lobby(message, kick_only_afk = 0)
	var/list/kicked_client_names = list()
	for(var/client/C in GLOB.clients)
		if(isnewplayer(C.mob))
			if(kick_only_afk && !C.is_afk())	//Ignore clients who are not afk
				continue
			if(message)
				to_chat(C, message)
			kicked_client_names.Add("[C.ckey]")
			qdel(C)
	return kicked_client_names

//returns 1 to let the dragdrop code know we are trapping this event
//returns 0 if we don't plan to trap the event
/datum/admins/proc/cmd_ghost_drag(var/mob/dead/observer/frommob, var/tothing)
	if(!istype(frommob))
		return //extra sanity check to make sure only observers are shoved into things

	//same as assume-direct-control perm requirements.
	if(!check_rights(R_VAREDIT,0)) //no varedit, check if they have r_admin and r_debug
		if(!check_rights(R_ADMIN|R_DEBUG,0)) //if they don't have r_admin and r_debug, return
			return 0 //otherwise, if they have no varedit, but do have r_admin and r_debug, execute the rest of the code

	if(!frommob.ckey)
		return 0

	if(istype(tothing, /obj/item))
		var/mob/living/toitem = tothing

		var/ask = alert("Are you sure you want to allow [frommob.name]([frommob.key]) to possess [toitem.name]?", "Place ghost in control of item?", "Yes", "No")
		if(ask != "Yes")
			return 1

		if(!frommob || !toitem) //make sure the mobs don't go away while we waited for a response
			return 1

		var/mob/living/simple_animal/possessed_object/tomob = new(toitem)

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name].</span>")
		log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag")

		tomob.ckey = frommob.ckey
		qdel(frommob)


	if(isliving(tothing))
		var/mob/living/tomob = tothing

		var/question = ""
		if(tomob.ckey)
			question = "This mob already has a user ([tomob.key]) in control of it! "
		question += "Are you sure you want to place [frommob.name]([frommob.key]) in control of [tomob.name]?"

		var/ask = alert(question, "Place ghost in control of mob?", "Yes", "No")
		if(ask != "Yes")
			return 1

		if(!frommob || !tomob) //make sure the mobs don't go away while we waited for a response
			return 1

		if(tomob.client) //no need to ghostize if there is no client
			tomob.ghostize(0)

		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has put [frommob.ckey] in control of [tomob.name].</span>")
		log_admin("[key_name(usr)] stuffed [frommob.ckey] into [tomob.name].")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Ghost Drag")

		tomob.ckey = frommob.ckey
		qdel(frommob)

		return 1

// Returns a list of the number of admins in various categories
// result[1] is the number of staff that match the rank mask and are active
// result[2] is the number of staff that do not match the rank mask
// result[3] is the number of staff that match the rank mask and are inactive
/proc/staff_countup(rank_mask = R_BAN)
	var/list/result = list(0, 0, 0)
	for(var/client/X in GLOB.admins)
		if(rank_mask && !check_rights_for(X, rank_mask))
			result[2]++
			continue
		if(X.holder.fakekey)
			result[2]++
			continue
		if(X.is_afk())
			result[3]++
			continue
		result[1]++
	return result

