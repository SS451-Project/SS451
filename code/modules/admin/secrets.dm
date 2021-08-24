/datum/admins
	var/current_tab =0

/datum/admins/proc/Secrets()


	if(!check_rights(0))	return
	var/dat = {"<html><meta charset="UTF-8"><body><center>"}

	dat += "<a href='?src=[UID()];secretsmenu=tab;tab=0' [current_tab == 0 ? "class='linkOn'" : ""]>Debug</a>"
	dat += "<a href='?src=[UID()];secretsmenu=tab;tab=1' [current_tab == 1 ? "class='linkOn'" : ""]>IC Events</a>"
	dat += "<a href='?src=[UID()];secretsmenu=tab;tab=2' [current_tab == 2 ? "class='linkOn'" : ""]>OOC Events</a>"

	dat += "</center>"
	dat += "<HR>"
	switch(current_tab)
		if(0) // Debug
			if(check_rights(R_ADMIN,0))
				dat += {"
						<center><B><h2>Секреты</h2></B>
						<B>Игра</b><br>
						<A href='?src=[UID()];secretsadmin=showailaws'>Показать законы ИИ</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsadmin=showgm'>Показать режим игры</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsadmin=manifest'>Показать манифест экипажа</A><br>
						<A href='?src=[UID()];secretsadmin=check_antagonist'>Покажите предателей и цели</A><BR>
						<A href='?src=[UID()];secretsadmin=view_codewords'>Показать кодовые фразы и отклики</A><BR>
						<a href='?src=[UID()];secretsadmin=night_shift_set'>Режим ночной смены</a><br>
						<B>Бомбы</b><br>
						[check_rights(R_SERVER, 0) ? "&nbsp;&nbsp;<A href='?src=[UID()];secretsfun=togglebombcap'>Toggle bomb cap</A><br>" : "<br>"]
						<B>Списки</b><br>
						<A href='?src=[UID()];secretsadmin=list_signalers'>Показать последние [length(GLOB.lastsignalers)] сигнализаторы</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsadmin=list_lawchanges'>Показать последние [length(GLOB.lawchanges)] изменения в законах</A><BR>
						<A href='?src=[UID()];secretsadmin=DNA'>Список ДНК (Кровь)</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsadmin=fingerprints'>Список отпечатков пальцев</A><BR>
						<B>Питание</b><br>
						<A href='?src=[UID()];secretsfun=blackout'>Сломать все лампы</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsfun=whiteout'>Починить все лампы</A><BR>
						<A href='?src=[UID()];secretsfun=power'>Обеспечьте питанием всех областей</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsfun=unpower'>Сделать все области необеспеченными питанием</A>&nbsp;&nbsp;
						<A href='?src=[UID()];secretsfun=quickpower'>Запитать все SMES'ы</A><BR>
						</center>
					"}

			else if(check_rights(R_SERVER,0)) //only add this if admin secrets are unavailiable; otherwise, it's added inline
				dat += "<center><b>Bomb cap: </b><A href='?src=[UID()];secretsfun=togglebombcap'>Toggle bomb cap</A><BR></center>"
				dat += "<BR>"
			if(check_rights(R_DEBUG,0))
				dat += {"
					<center>
					<B>Повышение Уровеня Безопасности</B><BR>
					<BR>
					<A href='?src=[UID()];secretscoder=maint_access_engiebrig'>Изменить все двери технического обслуживания на доступ только для engie/brig</A><BR>
					<A href='?src=[UID()];secretscoder=maint_ACCESS_BRIG'>Изменить все двери технического обслуживания на доступ только для брига</A><BR>
					<A href='?src=[UID()];secretscoder=infinite_sec'>Убрать ограничение с Сотрудников Службы Безопасности</A>&nbsp;&nbsp;
					<BR>
					<B>Секреты кодера</B><BR>
					<BR>
					<A href='?src=[UID()];secretsadmin=list_job_debug'>Показать отладку профессий</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretscoder=spawn_objects'>Админ лог</A><BR>
					<BR>
					</center>
					"}

		if(1)
			if(check_rights((R_EVENT|R_SERVER),0))
				dat += {"
					<center>
					<h2><B>IC События</B></h2>
					<b>Команды</b><br>
					<A href='?src=[UID()];secretsfun=infiltrators_syndicate'>Послать ДОС - Диверсионный Отряд Синдиката</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=striketeam_syndicate'>Послать УОС - Ударный Отряд Синдиката</A>&nbsp;&nbsp;
					<BR><A href='?src=[UID()];secretsfun=striketeam'>Послать ОС - Отряд Смерти</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=honksquad'>Послать ХОНКОтряд</A><BR>
					<A href='?src=[UID()];secretsfun=gimmickteam'>Послать команду из...</A><BR>
					<b>Изменение Уровня Безопасности</b><BR>
					<A href='?src=[UID()];secretsfun=securitylevel0'>Зелёный</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel1'>Синий</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel2'>Красный</A><br>
					<A href='?src=[UID()];secretsfun=securitylevel3'>Гамма</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel4'>Эпсилон</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel5'>Дельта</A><BR>
					<b>Создать погоду</b><BR>
					<A href='?src=[UID()];secretsfun=weatherashstorm'>Пепельная буря</A>&nbsp;&nbsp;
					<BR>
					</center>"}

		if(2)
			if(check_rights((R_SERVER|R_EVENT),0))
				dat += {"
					<center>
					<h2><B>OOC События</B></h2>
					<b>Thunderdome</b><br>
					<A href='?src=[UID()];secretsfun=tdomestart'>Начать матч Thunderdome</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=tdomereset'>Сбросить матч Thunderdome в состояние по умолчанию</A><BR><br>
					<b>Арсенал ОБР</b><br>
					<A href='?src=[UID()];secretsfun=armotyreset'>Сбросить арсенал в состояние по умолчанию</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset1'>Установить 1 вариант арсенала</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset2'>Установить 2 вариант арсенала</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset3'>Установить 3 вариант арсенала</A><BR><br>
					<b>Одежда (НЕЛЬЗЯ ОТМЕНИТЬ)</b><br>
					<A href='?src=[UID()];secretsfun=sec_clothes'>Убрать верхнюю одежду</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=sec_all_clothes'>Убрать ВСЮ одежду</A><BR>
					<b>TDM</b><br>
					<A href='?src=[UID()];secretsfun=traitor_all'>Каждый из нас - предатель!</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyone'>Выживит только один!</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyme'>Здесь могу быть только Я!</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyoneteam'>Dodgeball (TDM)!</A><BR>
					<b>На конец раунда</b><br>
					<A href='?src=[UID()];secretsfun=floorlava'>Пол - это лава! (ОПАСНО: крайне неубедительно)</A><BR>
					<A href='?src=[UID()];secretsfun=fakelava'>Пол - это фальшивая лава! (не причиняет вреда)</A><BR>
					<A href='?src=[UID()];secretsfun=monkey'>Превратить всех в обезьян</A><BR>
					<A href='?src=[UID()];secretsfun=fakeguns'>Все предметы принимают вид пистолета</A><BR>
					<A href='?src=[UID()];secretsfun=prisonwarp'>Телепортировать всех в тюрьму</A><BR>
					<A href='?src=[UID()];secretsfun=stupify'>Сделать всех тупыми</A><BR>
					<b>Прочее</b><br>
					<A href='?src=[UID()];secretsfun=sec_classic1'>Удалить противопожарные костюмы, решетки и капсулы</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=tripleAI'>Режим тройного искусственного интеллекта (необходимо использовать в лобби)</A><BR>
					<A href='?src=[UID()];secretsfun=flicklights'>Режим призрака</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=schoolgirl'>Китайский Аниме Режим</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=eagles'>Эгалитарный режим Станции</A><BR>
					<A href='?src=[UID()];secretsfun=guns'>Призвать Оружие</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=magic'>Призвать Магию</A>
					<BR>
					<A href='?src=[UID()];secretsfun=rolldice'>Бросить кости</A><BR>
					<BR>
					<BR>
					<A href='?src=[UID()];secretsfun=moveferry'>Сдвинуть переправу</A><BR>
					<A href='?src=[UID()];secretsfun=moveminingshuttle'>Переместить Шахтерский Шаттл</A><BR>
					<A href='?src=[UID()];secretsfun=movelaborshuttle'>Переместить Рабочий Шаттл</A><BR>
					<BR>
					</center>"}
	dat += "</center></body></html>"
	var/datum/browser/popup = new(usr, "secrets", "<div align='center'>Секреты</div>", 630, 670)
	popup.set_content(dat)
	popup.open(0)
