/*
 * AI Saycode
 */


/mob/living/silicon/ai/handle_track(var/message, var/verb = "says", var/mob/speaker = null, var/speaker_name, var/atom/follow_target, var/hard_to_hear)
	if(hard_to_hear)
		return

	var/jobname // the mob's "job"
	var/mob/living/carbon/human/impersonating //The crewmember being impersonated, if any.
	var/changed_voice

	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker

		var/obj/item/card/id/id = H.wear_id
		if((istype(id) && id.is_untrackable()) && H.HasVoiceChanger())
			changed_voice = 1
			var/mob/living/carbon/human/I = locate(speaker_name)
			if(I)
				impersonating = I
				jobname = impersonating.get_assignment()
			else
				jobname = "Unknown"
		else
			jobname = H.get_assignment()

	else if(iscarbon(speaker)) // Nonhuman carbon mob
		jobname = "No ID"
	else if(isAI(speaker))
		jobname = "AI"
	else if(isrobot(speaker))
		jobname = "Cyborg"
	else if(ispAI(speaker))
		jobname = "Personal AI"
	else if(isAutoAnnouncer(speaker))
		var/mob/living/automatedannouncer/AA = speaker
		jobname = AA.role
	else
		jobname = "Unknown"

	var/track = ""
	var/mob/mob_to_track = null
	if(changed_voice)
		if(impersonating)
			mob_to_track = impersonating
		else
			track = "[speaker_name] ([jobname])"
	else
		if(istype(follow_target, /mob/living/simple_animal/bot))
			track = "<a href='byond://?src=[UID()];trackbot=\ref[follow_target]'>[speaker_name] ([jobname])</a>"
		else
			mob_to_track = speaker

	if(mob_to_track)
		track = "<a href='byond://?src=[UID()];track=\ref[mob_to_track]'>[speaker_name] ([jobname])</a>"
		track += "&nbsp;<a href='byond://?src=[UID()];open=\ref[mob_to_track]'>\[Open\]</a>"

	return track



/*
 * AI VOX Announcements
 */

GLOBAL_VAR_INIT(announcing_vox, 0) // Stores the time of the last announcement
#define VOX_DELAY 100
#define VOX_PATH "sound/vox_fem/"

/mob/living/silicon/ai/verb/announcement_help()
	set name = "Справка по объявлению"
	set desc = "Отображает список вокальных слов, которые можно объявить экипажу."
	set category = "AI Commands"

	var/dat = {"<meta charset="UTF-8">Вот список слов, которые вы можете ввести в 'Сделать VOX объявление' на экране, чтобы вокально объявить всем на одном уровне с вами.<BR> \
	<UL><LI>Вы также можете нажать на слово, чтобы прослушать его.</LI>\
	<LI>Вы можете сказать только 30 слов для каждого объявления.</LI>\
	<LI>Не используйте знаки препинания, как обычно. Если вам нужна пауза, вы можете использовать символы полной остановки и запятой, разделив их пробелами, например: 'Alpha . Test , Bravo'.</LI></UL>\
	<font class='bad'>ПРЕДУПРЕЖДЕНИЕ:</font><BR>Неправильное использование VOX системы приведет к тому, что вам выдадут бан на профессию.<HR>"}

	// Show alert and voice sounds separately
	var/vox_words = GLOB.vox_sounds - GLOB.vox_alerts
	dat = help_format(GLOB.vox_alerts, dat)
	dat = help_format(vox_words, dat)

	var/datum/browser/popup = new(src, "announce_help", "Справка по объявлению", 500, 400)
	popup.set_content(dat)
	popup.open()

/mob/living/silicon/ai/proc/help_format(word_list, dat)
	var/index = 0
	for(var/word in word_list)
		index++
		dat += "<A href='?src=[UID()];say_word=[word]'>[capitalize(word)]</A>"
		if(index != length(word_list))
			dat += " / "
		else
			dat += "<HR>"
	return dat

/mob/living/silicon/ai/proc/ai_announcement()
	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(GLOB.announcing_vox > world.time)
		to_chat(src, "<span class='warning'>Пожалуйста подождите [round((GLOB.announcing_vox - world.time) / 10)] секунд.</span>")
		return

	var/message = clean_input("ПРЕДУПРЕЖДЕНИЕ: Неправильное использование этого действия может привести к тому, что вам дадут бан данной профессии. Дополнительная информация доступна в разделе 'AI Commands -> Справка по объявлению'", "VOX объявление", last_announcement, src)

	last_announcement = message

	if(check_unable(AI_CHECK_WIRELESS | AI_CHECK_RADIO))
		return

	if(!message || GLOB.announcing_vox > world.time)
		return

	var/list/words = splittext(trim(message), " ")
	var/list/incorrect_words = list()

	if(words.len > 30)
		words.len = 30

	for(var/word in words)
		word = lowertext(trim(word))
		if(!word)
			words -= word
			continue
		if(!GLOB.vox_sounds[word])
			incorrect_words += word

	if(incorrect_words.len)
		to_chat(src, "<span class='warning'>Этих слов не найдено в VOX системе: [english_list(incorrect_words)].</span>")
		return

	GLOB.announcing_vox = world.time + VOX_DELAY

	log_game("[key_name(src)] сделал vox объявление: [message].")
	message_admins("[key_name_admin(src)] сделал vox объявление: [message].")

	var/i = 0
	for(var/word in words)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/play_vox_word, word, src.z, null), i)
		i++

	ai_voice_announcement_to_text(words)


/mob/living/silicon/ai/proc/ai_voice_announcement_to_text(words)
	var/words_string = jointext(words, " ")
	var/formatted_message = "<h1 class='alert'>Объявление И.И.</h1>"
	formatted_message += "<br><span class='alert'>[words_string]</span>"
	formatted_message += "<br><span class='alert'> -[src]</span>"

	for(var/player in GLOB.player_list)
		var/mob/M = player
		if(M.client && !(M.client.prefs.sound & SOUND_AI_VOICE))
			var/turf/T = get_turf(M)
			if(T && T.z == z && M.can_hear())
				SEND_SOUND(M, 'sound/misc/notice2.ogg')
				to_chat(M, formatted_message)

/proc/play_vox_word(word, z_level, mob/only_listener)

	word = lowertext(word)

	if(GLOB.vox_sounds[word])

		var/sound_file = GLOB.vox_sounds[word]
		var/sound/voice = sound(sound_file, wait = 1, channel = CHANNEL_VOX)
		voice.status = SOUND_STREAM

		// If there is no single listener, broadcast to everyone in the same z level
		if(!only_listener)
			// Play voice for all mobs in the z level
			for(var/mob/M in GLOB.player_list)
				if(M.client && M.client.prefs.sound & SOUND_AI_VOICE)
					var/turf/T = get_turf(M)
					if(T && T.z == z_level && M.can_hear())
						M << voice
		else
			only_listener << voice
		return 1
	return 0

// VOX sounds moved to /code/defines/vox_sounds.dm

/client/proc/preload_vox()
	var/list/vox_files = flist(VOX_PATH)
	for(var/file in vox_files)
//	to_chat(src, "Скачивание [file]")
		var/sound/S = sound("[VOX_PATH][file]")
		src << browse_rsc(S)
