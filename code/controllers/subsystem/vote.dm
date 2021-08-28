SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	offline_implications = "Голосование (шаттл конца раунда) больше не будет функционировать. Рекомендуется вызвать шаттл вручную."

	var/initiator = null
	var/started_time = null
	var/time_remaining = 0
	var/mode = null
	var/question = null
	var/list/choices = list()
	var/list/voted = list()
	var/list/voting = list()
	var/list/current_votes = list()
	var/list/round_voters = list()
	var/auto_muted = 0

/datum/controller/subsystem/vote/fire()
	if(mode)
		// No more change mode votes after the game has started.
		if(mode == "gamemode" && SSticker.current_state >= GAME_STATE_SETTING_UP)
			to_chat(world, "<b>Голосование прервано из-за начала игры.</b>")
			reset()
			return

		// Calculate how much time is remaining by comparing current time, to time of vote start,
		// plus vote duration
		time_remaining = round((started_time + config.vote_period - world.time)/10)

		if(time_remaining < 0)
			result()
			for(var/client/C in voting)
				if(C)
					C << browse(null,"window=vote")
			reset()
		else
			for(var/client/C in voting)
				update_panel(C)
				CHECK_TICK

/datum/controller/subsystem/vote/proc/autotransfer()
	initiate_vote("crew_transfer","the server")

/datum/controller/subsystem/vote/proc/reset()
	initiator = null
	time_remaining = 0
	mode = null
	question = null
	choices.Cut()
	voted.Cut()
	voting.Cut()
	current_votes.Cut()

	if(auto_muted && !config.ooc_allowed && !(config.auto_toggle_ooc_during_round && SSticker.current_state == GAME_STATE_PLAYING))
		auto_muted = 0
		config.ooc_allowed = !( config.ooc_allowed )
		to_chat(world, "<b>Канал OOC был автоматически включен в связи с окончанием голосования.</b>")
		log_admin("OOC был переключен автоматически в связи с окончанием голосования.")
		message_admins("OOC был переключен автоматически в связи с окончанием голосования.")


/datum/controller/subsystem/vote/proc/get_result()
	var/greatest_votes = 0
	var/total_votes = 0
	var/list/sorted_choices = list()
	var/sorted_highest
	var/sorted_votes = -1
	//get the highest number of votes, while also sorting the list
	while(choices.len)
		// This is a very inefficient sorting method, but that's okay
		for(var/option in choices)
			var/votes = choices[option]
			if(sorted_votes < votes)
				sorted_highest = option
				sorted_votes = votes
			if(votes > greatest_votes)
				greatest_votes = votes
		sorted_votes = -1
		total_votes += choices[sorted_highest]
		sorted_choices[sorted_highest] = choices[sorted_highest] || 0
		choices -= sorted_highest
	choices = sorted_choices
	//default-vote for everyone who didn't vote
	if(!config.vote_no_default && choices.len)
		var/non_voters = (GLOB.clients.len - total_votes)
		if(non_voters > 0)
			if(mode == "restart")
				choices["Продолжить игру"] += non_voters
				if(choices["Продолжить игру"] >= greatest_votes)
					greatest_votes = choices["Продолжить игру"]
			else if(mode == "gamemode")
				if(GLOB.master_mode in choices)
					choices[GLOB.master_mode] += non_voters
					if(choices[GLOB.master_mode] >= greatest_votes)
						greatest_votes = choices[GLOB.master_mode]
			else if(mode == "crew_transfer")
				var/factor = 0.5
				switch(world.time / (10 * 60)) // minutes
					if(0 to 60)
						factor = 0.5
					if(61 to 120)
						factor = 0.8
					if(121 to 240)
						factor = 1
					if(241 to 300)
						factor = 1.2
					else
						factor = 1.4
				choices["Инициировать трансфер экипажа"] = round(choices["Инициировать трансфер экипажа"] * factor)
				to_chat(world, "<font color='purple'>Фактор трансфера экипажа: [factor]</font>")
				greatest_votes = max(choices["Инициировать трансфер экипажа"], choices["Продолжить раунд"])


	//get all options with that many votes and return them in a list
	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(winners.len > 1)
			if(mode != "gamemode" || SSticker.hide_mode == 0) // Here we are making sure we don't announce potential game modes
				text = "<b>Голосование вничью между:</b>\n"
				for(var/option in winners)
					text += "\t[option]\n"
		. = pick(winners)

		for(var/key in current_votes)
			if(choices[current_votes[key]] == .)
				round_voters += key // Keep track of who voted for the winning round.
		if(mode == "gamemode" && (. == "extended" || SSticker.hide_mode == 0)) // Announce Extended gamemode, but not other gamemodes
			text += "<b>Результаты голосования: [.] ([choices[.]] голос/а)</b>"
		else
			if(mode == "custom")
				// Completely replace text to show all results in custom votes
				text = "<b><span style='text-decoration: underline;'>[question]</span></b>\n"
				for(var/option in winners)
					text += "\t<b>[option]: [choices[option]] голос/а</b>\n"
				for(var/option in (choices-winners))
					text += "\t[option]: [choices[option]] голос/а\n"
			else if(mode != "gamemode")
				text += "<b>Результаты голосования: [.] ([choices[.]] голос/а)</b>"
			else
				text += "<b>Голосование окончено.</b>" // What will be shown if it is a gamemode vote that isn't extended

	else
		text += "<b>Результат голосования: Безрезультатно - нет голосов!</b>"
	log_vote(text)
	to_chat(world, "<font color='purple'>[text]</font>")
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = 0
	if(.)
		switch(mode)
			if("restart")
				if(. == "Перезапуск раунда")
					restart = 1
			if("gamemode")
				if(GLOB.master_mode != .)
					world.save_mode(.)
					if(SSticker && SSticker.mode)
						restart = 1
					else
						GLOB.master_mode = .
				if(!SSticker.ticker_going)
					SSticker.ticker_going = TRUE
					to_chat(world, "<font color='red'><b>Раунд скоро начнется.</b></font>")
			if("crew_transfer")
				if(. == "Инициировать трансфер экипажа")
					init_shift_change(null, 1)


	if(restart)
		SSticker.reboot_helper("Голосование на перезапуск прошло успешно.", "restart vote")

	return .

/datum/controller/subsystem/vote/proc/submit_vote(var/ckey, var/vote)
	if(mode)
		if(config.vote_no_dead && (usr.stat == DEAD || istype((usr), /mob/living/simple_animal)) && !usr.client.holder)
			return 0
		if(current_votes[ckey])
			choices[choices[current_votes[ckey]]]--
		if(vote && 1<=vote && vote<=choices.len)
			voted += usr.ckey
			choices[choices[vote]]++	//check this
			current_votes[ckey] = vote
			return vote
	return 0

/datum/controller/subsystem/vote/proc/initiate_vote(var/vote_type, var/initiator_key)
	if(!mode)
		if(started_time != null && !check_rights(R_ADMIN))
			var/next_allowed_time = (started_time + config.vote_delay)
			if(next_allowed_time > world.time)
				return 0

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Перезапуск раунда","Продолжить игру")
			if("gamemode")
				if(SSticker.current_state >= 2)
					return 0
				choices.Add(config.votable_modes)
			if("crew_transfer")
				if(check_rights(R_ADMIN|R_MOD))
					if(SSticker.current_state <= 2)
						return 0
					question = "Закончить смену?"
					choices.Add("Инициировать трансфер экипажа", "Продолжить раунд")
				else
					if(SSticker.current_state <= 2)
						return 0
					question = "Закончить смену?"
					choices.Add("Инициировать трансфер экипажа", "Продолжить раунд")
			if("custom")
				question = html_encode(input(usr,"За что голосовать?") as text|null)
				if(!question)	return 0
				for(var/i=1,i<=10,i++)
					var/option = capitalize(html_encode(input(usr,"Пожалуйста, введите опцию или нажмите 'Cancel', чтобы отменить") as text|null))
					if(!option || mode || !usr.client)	break
					choices.Add(option)
			else
				return 0
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[initiator] начал голосование [capitalize(mode)]."
		if(mode == "custom")
			text += "\n[question]"
			if(usr)
				log_admin("[key_name(usr)] начал голосование [capitalize(mode)] - ([question]).")
		else if(usr)
			log_admin("[key_name(usr)] начал голосование [capitalize(mode)].")

		log_vote(text)
		to_chat(world, {"<font color='purple'><b>[text]</b>
			<a href='?src=[UID()];vote=open'>Нажмите здесь, чтобы разместить свой голос.</a>
			У вас есть [config.vote_period/10] секунд на голос.</font>"})
		switch(vote_type)
			if("crew_transfer")
				world << sound('sound/ambience/alarm4.ogg', volume = 50)
			if("gamemode")
				world << sound('sound/ambience/alarm4.ogg', volume = 50)
			if("custom")
				world << sound('sound/ambience/alarm4.ogg', volume = 50)
		if(mode == "gamemode" && SSticker.ticker_going)
			SSticker.ticker_going = FALSE
			to_chat(world, "<font color='red'><b>Начало раунда было отложено.</b></font>")
		if(mode == "crew_transfer" && config.ooc_allowed)
			auto_muted = 1
			config.ooc_allowed = !( config.ooc_allowed )
			to_chat(world, "<b>Канал OOC был автоматически отключен из-за голосования по переводу экипажа.</b>")
			log_admin("OOC был переключен автоматически из-за голосования crew_transfer.")
			message_admins("OOC был отключен автоматически.")
		if(mode == "gamemode" && config.ooc_allowed)
			auto_muted = 1
			config.ooc_allowed = !( config.ooc_allowed )
			to_chat(world, "<b>Канал OOC был автоматически отключен из-за голосования о режиме игры.</b>")
			log_admin("OOC был переключен автоматически из-за голосования о режиме игры.")
			message_admins("OOC был отключен автоматически.")
		if(mode == "custom" && config.ooc_allowed)
			auto_muted = 1
			config.ooc_allowed = !( config.ooc_allowed )
			to_chat(world, "<b>Канал OOC был автоматически отключен из-за пользовательского голосования.</b>")
			log_admin("OOC был переключен автоматически из-за пользовательского голосования.")
			message_admins("OOC был отключен автоматически.")

		time_remaining = round(config.vote_period/10)
		return 1
	return 0

/datum/controller/subsystem/vote/proc/browse_to(var/client/C)
	if(!C)
		return
	var/admin = check_rights(R_ADMIN, 0, user = C.mob)
	voting |= C

	var/dat = {"<script>
		function update_vote_div(new_content) {
			var votediv = document.getElementById("vote_div");
			if(votediv) {
				votediv.innerHTML = new_content;
			}
		}
		</script>"}
	if(mode)
		dat += "<div id='vote_div'>[vote_html(C)]</div><hr>"
		if(admin)
			dat += "(<a href='?src=[UID()];vote=cancel'>Отменить голосование</a>) "
	else
		dat += "<div id='vote_div'><h2>Начать голосование:</h2><hr><ul><li>"
		//restart
		if(admin || config.allow_vote_restart)
			dat += "<a href='?src=[UID()];vote=restart'>Перезапуск</a>"
		else
			dat += "<font color='grey'>Перезапуск (Недоступно)</font>"
		dat += "</li><li>"
		if(admin || config.allow_vote_restart)
			dat += "<a href='?src=[UID()];vote=crew_transfer'>Перевод Экипажа</a>"
		else
			dat += "<font color='grey'>Перевод Экипажа (Недоступно)</font>"
		if(admin)
			dat += "\t(<a href='?src=[UID()];vote=toggle_restart'>[config.allow_vote_restart?"Разрешить":"Запретить"]</a>)"
		dat += "</li><li>"
		//gamemode
		if(admin || config.allow_vote_mode)
			dat += "<a href='?src=[UID()];vote=gamemode'>Игровой режим</a>"
		else
			dat += "<font color='grey'>Игровой режим (Недоступно)</font>"
		if(admin)
			dat += "\t(<a href='?src=[UID()];vote=toggle_gamemode'>[config.allow_vote_mode?"Разрешить":"Запретить"]</a>)"

		dat += "</li>"
		//custom
		if(admin)
			dat += "<li><a href='?src=[UID()];vote=custom'>Пользовательское</a></li>"
		dat += "</ul></div><hr>"
	var/datum/browser/popup = new(C.mob, "vote", "Панель голосования", nref=src)
	popup.set_content(dat)
	popup.open()

/datum/controller/subsystem/vote/proc/update_panel(var/client/C)
	C << output(url_encode(vote_html(C)), "vote.browser:update_vote_div")

/datum/controller/subsystem/vote/proc/vote_html(var/client/C)
	. = ""
	if(question)
		. += "<h2>Голосование: '[question]'</h2>"
	else
		. += "<h2>Голосование: [capitalize(mode)]</h2>"
	. += "Времени осталось: [time_remaining] сек.<hr><ul>"
	for(var/i = 1, i <= choices.len, i++)
		var/votes = choices[choices[i]]
		if(!votes)
			votes = 0
		if(current_votes[C.ckey] == i)
			. += "<li><b><a href='?src=[UID()];vote=[i]'>[choices[i]] ([votes] голос/а)</a></b></li>"
		else
			. += "<li><a href='?src=[UID()];vote=[i]'>[choices[i]] ([votes] голос/а)</a></li>"

	. += "</ul>"


/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	if(!usr || !usr.client)
		return	//not necessary but meh...just in-case somebody does something stupid
	var/admin = check_rights(R_ADMIN,0)
	if(href_list["close"])
		voting -= usr.client
		return
	switch(href_list["vote"])
		if("open")
			// vote proc will automatically get called after this switch ends
		if("cancel")
			if(admin && mode)
				var/votedesc = capitalize(mode)
				if(mode == "custom")
					votedesc += " ([question])"
				log_and_message_admins("отмененил текущее голосование [votedesc].")
				reset()
		if("toggle_restart")
			if(admin)
				config.allow_vote_restart = !config.allow_vote_restart
		if("toggle_gamemode")
			if(admin)
				config.allow_vote_mode = !config.allow_vote_mode
		if("restart")
			if(config.allow_vote_restart || admin)
				initiate_vote("restart",usr.key)
		if("gamemode")
			if(config.allow_vote_mode || admin)
				initiate_vote("gamemode",usr.key)
		if("crew_transfer")
			if(config.allow_vote_restart || admin)
				initiate_vote("crew_transfer",usr.key)
		if("custom")
			if(admin)
				initiate_vote("custom",usr.key)
		else
			submit_vote(usr.ckey, round(text2num(href_list["vote"])))
			update_panel(usr.client)
			return
	usr.vote()


/mob/verb/vote()
	set category = "OOC"
	set name = "Голосование"

	if(SSvote)
		SSvote.browse_to(client)
