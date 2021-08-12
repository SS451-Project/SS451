/datum/game_mode/blob/proc/send_intercept(var/report = 1)
	var/intercepttext = ""
	var/interceptname = ""
	switch(report)
		if(0)
			return
		if(1)
			interceptname = "Процедуры Реагирования На Биологическую Опасность 5-6 Уровня"
			intercepttext += "<FONT size = 3><B>Обновление Nanotrasen</B>: Тревога биологической опасности.</FONT><HR>"
			intercepttext += "Сообщения указывают на вероятную передачу биологически опасного агента на [station_name()] во время последнего цикла высадки экипажа.<BR>"
			intercepttext += "Предварительный анализ организма классифицирует его как биологическую опасность 5-го уровня. Его происхождение неизвестно.<BR>"
			intercepttext += "Nanotrasen издал директиву 7-10 для [station_name()]. Станция должна считаться помещенной на карантин.<BR>"
			intercepttext += "Распоряжение на весь персонал [station_name()] следует:<BR>"
			intercepttext += " 1. Не покидайте зону карантина.<BR>"
			intercepttext += " 2. Найдите любые вспышки заболевания на станции.<BR>"
			intercepttext += " 3. При обнаружении используйте любые необходимые средства для сдерживания организма.<BR>"
			intercepttext += " 4. Избегайте повреждения инфраструктуры станции.<BR>"
			intercepttext += "<BR>Примечание. В случае нарушения карантина или неконтролируемого распространения биологической опасности директива 7-10 может быть изменена на директиву 7-12.<BR>"
			intercepttext += "Конец сообщения."
		if(2)
			var/nukecode = rand(10000, 99999)
			for(var/obj/machinery/nuclearbomb/bomb in GLOB.machines)
				if(bomb && bomb.r_code)
					if(is_station_level(bomb.z))
						bomb.r_code = nukecode

			interceptname = "Секретное [command_name()] Обновление"
			intercepttext += "<FONT size = 3><B>Обновление Nanotrasen</B>: Тревога биологической опасности.</FONT><HR>"
			intercepttext += "Директива 7-12 была издана для [station_name()].<BR>"
			intercepttext += "Биологическая опасность вышла из-под контроля и скоро достигнет критической массы.<BR>"
			intercepttext += "Ваши задачи заключаются в следующем:<BR>"
			intercepttext += "1. Защитите диск с ядерной аутентификацией.<BR>"
			intercepttext += "2. Взорвите ядерную бомбу, расположенную в хранилище Станции.<BR>"
			intercepttext += "Код Ядерной Аутентификации: [nukecode] <BR>"
			intercepttext += "Конец сообщения."

			for(var/mob/living/silicon/ai/aiPlayer in GLOB.player_list)
				if(aiPlayer.client)
					var/law = "Станция находится на карантине. Никому не позволяйте уходить. Игнорируйте законы 1-3, если это необходимо. Ядерная защита должна быть активирована любой ценой, код: [nukecode]."
					aiPlayer.set_zeroth_law(law)
					to_chat(aiPlayer, "Законы обновлены: [law]")

	print_command_report(intercepttext, interceptname, FALSE)
	GLOB.event_announcement.Announce("Отчет был загружен и распечатан на всех коммуникационных консолях.", "Входящее Секретное Сообщение", 'sound/AI/commandreport.ogg', from = "Обновление [command_name()]")

/datum/station_state
	var/floor = 0
	var/wall = 0
	var/r_wall = 0
	var/window = 0
	var/door = 0
	var/grille = 0
	var/mach = 0


/datum/station_state/proc/count()
	for(var/turf/T in block(locate(1,1,1), locate(world.maxx,world.maxy,1)))

		if(istype(T,/turf/simulated/floor))
			if(!(T:burnt))
				src.floor += 12
			else
				src.floor += 1

		if(istype(T, /turf/simulated/wall))
			var/turf/simulated/wall/W = T
			if(W.intact)
				src.wall += 2
			else
				src.wall += 1

		if(istype(T, /turf/simulated/wall/r_wall))
			var/turf/simulated/wall/r_wall/R = T
			if(R.intact)
				src.r_wall += 2
			else
				src.r_wall += 1


		for(var/obj/O in T.contents)
			if(istype(O, /obj/structure/window))
				src.window += 1
			else if(istype(O, /obj/structure/grille))
				var/obj/structure/grille/GR = O
				if(!GR.broken)
					grille += 1
			else if(istype(O, /obj/machinery/door))
				src.door += 1
			else if(istype(O, /obj/machinery))
				src.mach += 1

/datum/station_state/proc/score(var/datum/station_state/result)
	if(!result)	return 0
	var/output = 0
	output += (result.floor / max(floor,1))
	output += (result.r_wall/ max(r_wall,1))
	output += (result.wall / max(wall,1))
	output += (result.window / max(window,1))
	output += (result.door / max(door,1))
	output += (result.grille / max(grille,1))
	output += (result.mach / max(mach,1))
	return (output/7)
