//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "Wiki"
	set desc = "Введите то, о чем вы хотите знать. Это откроет вики-страницу в вашем браузере."
	set hidden = 1
	log_admin("[key_name(src)] нажал на кнопку \'WIKI\'!")
	message_admins("[key_name_admin(src)] <span class='red'>нажал на кнопку \'WIKI\'!</span>")
	if(config.wikiurl)
		var/query = stripped_input(src, "Искать:", "Поиск по Wiki", "Руководства")
		if(query == "Руководства")
			src << link(config.wikiurl)
		else if(query)
			var/output = config.wikiurl + "index.php/" + query
			src << link(output)
	else
		to_chat(src, "<span class='danger'>Адрес Wiki не задан в конфигурации сервера.</span>")
	return

/client/verb/forum()
	set name = "Forum"
	set desc = "Посетить форум SS13"
	set hidden = 1
	log_admin("[key_name(src)] нажал на кнопку \'FORUM\'!")
	message_admins("[key_name_admin(src)] <span class='red'>нажал на кнопку \'FORUM\'!</span>")
	if(config.forumurl)
		if(alert("Открыть форум в браузере?", null, "Да", "Нет") == "Да")
			if(config.forum_link_url && prefs && !prefs.fuid)
				link_forum_account()
			src << link(config.forumurl)
	else
		to_chat(src, "<span class='danger'>Адрес форума не задан в конфигурации сервера.</span>")

/client/verb/rules()
	set name = "Rules"
	set desc = "Просмотр правил сервера."
	set hidden = 1
	log_admin("[key_name(src)] нажал на кнопку \'RULES\'!")
	message_admins("[key_name_admin(src)] <span class='red'>нажал на кнопку \'RULES\'!</span>")
	if(config.rulesurl)
		if(alert("Это откроет правила в вашем браузере. Ты уверен?", null, "Да", "Нет") == "Нет")
			return
		src << link(config.rulesurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")

/client/verb/github()
	set name = "GitHub"
	set desc = "Посетить наш репозиторий GitHub."
	set hidden = 1
	log_admin("[key_name(src)] нажал на кнопку \'GITHUB\'!")
	message_admins("[key_name_admin(src)] <span class='red'>нажал на кнопку \'GITHUB\'!</span>")
	if(config.githuburl)
		if(alert("Это откроет наш репозиторий GitHub в вашем браузере. Ты уверен?", null, "Да", "Нет") == "Нет")
			return
		src << link(config.githuburl)
	else
		to_chat(src, "<span class='danger'>Адрес GitHub не задан в конфигурации сервера.</span>")

/client/verb/discord()
	set name = "Discord"
	set desc = "Присоединяйтесь к нашему серверу Discord."
	set hidden = 1
	log_admin("[key_name(src)] нажал на кнопку \'DISCORD\'!")
	message_admins("[key_name_admin(src)] <span class='red'>нажал на кнопку \'DISCORD\'!</span>")

	var/durl = config.discordurl
	if(config.forum_link_url && prefs && prefs.fuid && config.discordforumurl)
		durl = config.discordforumurl
	if(!durl)
		to_chat(src, "<span class='danger'>Адрес Discord не задан в конфигурации сервера.</span>")
		return
	if(alert("Это пригласит вас на наш сервер Discord. Ты уверен?", null, "Да", "Нет") == "Нет")
		return
	src << link(durl)

/client/verb/donate()
	set name = "Donate"
	set desc = "Пожертвуйте, чтобы помочь с расходами на хостинг."
	set hidden = 1
	log_admin("[key_name(src)] has pressed the \'DONATE\' button!")
	message_admins("[key_name_admin(src)] <span class='red'>has pressed the \'DONATE\' button!</span>")
	if(config.donationsurl)
		if(alert("Это откроет страницу пожертвования в вашем браузере. Ты уверен?", null, "Да", "Нет") == "Нет")
			return
		src << link(config.donationsurl)
	else
		to_chat(src, "<span class='danger'>The rules URL is not set in the server configuration.</span>")

/client/verb/hotkeys_help()
	set name = "Hotkey Help"
	set category = "OOC"

	var/adminhotkeys = {"<font color='purple'>
Для админов:
\tF5 = Asay
\tF6 = Admin Ghost
\tF7 = Панель игроков
\tF8 = Admin PM
\tF9 = Невидимка

Admin ghost:
\tCtrl+Click (по игроку) = Панель игрока
\tCtrl+Shift+Click = Переменные
\tShift+Middle Click = Mob Info
</font>"}

	mob.hotkey_help()

	if(check_rights(R_MOD|R_ADMIN,0))
		to_chat(src, adminhotkeys)

/mob/proc/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
'Хоткей' режим: (должен быть включен - Tab)
\tTAB = Включить режим 'Хоткей'
\tA = ВЛЕВО
\tS = ВНИЗ
\tD = ВПРАВО
\tW = ВВЕРХ
\tQ = Отпустить
\tE = Экипировать
\tR = Бросить/Поймать (если активно)
\tC = Перестать тянуть
\tM = Me (действие 1-ого лица)
\tT = Say (IC чат; +SHIFT - шептать)
\tO = OOC (OOC чат)
\tL = LOOC (Локальный OOC чат)
\tB = Сопротивляться (+SHIFT - Лечь)
\tH = Кобура/достать оружие из кобуры, если у вас есть кобура
\tX = Поменять руку
\tZ = Активировать удерживаемый объект (или Y)
\tF = Прокрутить интенты влево
\tG = Прокрутить интенты вправо
\t1 = Помощь
\t2 = Обезоружить (также сбивает с ног)
\t3 = Захват
\t4 = Вред
\tNumpad = Выбор маста на теле (Нажатие 8 выбирает Голову->Глаза->Рот)
\tAlt(Удерживая) = Изменить движение (Бег <-> Шаг)
</font>"}

	var/other = {"<font color='purple'>
Общее: (Режим 'Хоткей' не обязательно должен быть включен)
\tCtrl+A = ВЛЕВО
\tCtrl+S = ВНИЗ
\tCtrl+D = ВПРАВО
\tCtrl+W = ВВЕРХ
\tCtrl+Q = Отпустить
\tCtrl+E = Экипировать
\tCtrl+R = Бросить/Поймать (если активно)
\tCtrl+C = Перестать тянуть
\tCtrl+M = Me (действие 1-ого лица)
\tCtrl+T = Say (IC чат; +SHIFT - шептать)
\tCtrl+O = OOC (OOC чат)
\tCtrl+L = LOOC (Локальный OOC чат)
\tCtrl+B = Сопротивляться (+SHIFT - Лечь)
\tCtrl+X = Поменять руку
\tCtrl+Z = Активировать удерживаемый объект (или Ctrl+Y)
\tCtrl+F = Прокрутить интенты влево
\tCtrl+G = Прокрутить интенты вправо
\tCtrl+1 = Помощь
\tCtrl+2 = Обезоружить (также сбивает с ног)
\tCtrl+3 = Захват
\tCtrl+4 = Вред
Альтернативный режим:
\tDEL = Перестать тянуть
\tINS = Прокрутить интенты вправо
\tHOME = Отпустить
\tPGUP = Поменять руку
\tPGDN = Активировать удерживаемый объект
\tEND = Бросить/Поймать (если активно)
\tCtrl+Numpad = Выбор маста на теле (Нажатие 8 выбирает Голову->Глаза->Рот)
\tF2 = OOC (OOC чат)
\tF3 = Say (IC чат; +SHIFT - шептать)
\tF4 = Me (действие 1-ого лица)
\tF11 = Полный экран
\tCtrl+F11 = Подогнать окно
</font>"}

	to_chat(src, hotkey_mode)
	to_chat(src, other)

/mob/living/silicon/robot/hotkey_help()
	var/hotkey_mode = {"<font color='purple'>
'Хоткей' режим: (должен быть включен - Tab)
\tTAB = Включить режим 'Хоткей'
\tA = ВЛЕВО
\tS = ВНИЗ
\tD = ВПРАВО
\tW = ВВЕРХ
\tQ = Отпустить с активного модуля
\tC = Перестать тянуть
\tM = Me (действие 1-ого лица)
\tT = Say (IC чат; +SHIFT - шептать)
\tO = OOC (OOC чат)
\tL = LOOC (Локальный OOC чат)
\tX = Поменять модули
\tB = Сопротивляться (+SHIFT - Лечь)
\tZ или Y = Активировать удерживаемый объект
\tF = Прокрутить интенты влево
\tG = Прокрутить интенты вправо
\t1 = Модуль 1
\t2 = Модуль 2
\t3 = Модуль 3
\t4 = Переключить интенты
</font>"}

	var/other = {"<font color='purple'>
Общее: (Режим 'Хоткей' не обязательно должен быть включен)
\tCtrl+A = ВЛЕВО
\tCtrl+S = ВНИЗ
\tCtrl+D = ВПРАВО
\tCtrl+W = ВВЕРХ
\tCtrl+Q = Отпустить с активного модуля
\tCtrl+C = Перестать тянуть
\tCtrl+M = Me (действие 1-ого лица)
\tCtrl+T = Say (IC чат; +SHIFT - шептать)
\tCtrl+O = OOC (OOC чат)
\tCtrl+L = LOOC (Локальный OOC чат)
\tCtrl+X = Поменять модули
\tCtrl+B = Сопротивляться (+SHIFT - Лечь)
\tCtrl+Z или Ctrl+Y = Активировать удерживаемый объект
\tCtrl+F = Прокрутить интенты влево
\tCtrl+G = Прокрутить интенты вправо
\tCtrl+1 = Модуль 1
\tCtrl+2 = Модуль 2
\tCtrl+3 = Модуль 3
\tCtrl+4 = Переключить интенты
\tDEL = Тянуть
\tINS = Переключить интенты
\tPGUP = Поменять модули
\tPGDN = Активировать удерживаемый объект
\tF2 = OOC (OOC чат)
\tF3 = Say (IC чат; +SHIFT - шептать)
\tF4 = Me (действие 1-ого лица)
\tF11 = Полный экран
\tCtrl+F11 = Подогнать окно
</font>"}

	to_chat(src, hotkey_mode)
	to_chat(src, other)
