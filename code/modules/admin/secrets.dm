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
					<h2><B>IC Events</B></h2>
					<b>Teams</b><br>
					<A href='?src=[UID()];secretsfun=infiltrators_syndicate'>Send SIT - Syndicate Infiltration Team</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=striketeam_syndicate'>Send in a Syndie Strike Team</A>&nbsp;&nbsp;
					<BR><A href='?src=[UID()];secretsfun=striketeam'>Send in the Deathsquad</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=honksquad'>Send in a HONKsquad</A><BR>
					<A href='?src=[UID()];secretsfun=gimmickteam'>Send in a Gimmick Team</A><BR>
					<b>Change Security Level</b><BR>
					<A href='?src=[UID()];secretsfun=securitylevel0'>Security Level - Green</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel1'>Security Level - Blue</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel2'>Security Level - Red</A><br>
					<A href='?src=[UID()];secretsfun=securitylevel3'>Security Level - Gamma</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel4'>Security Level - Epsilon</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=securitylevel5'>Security Level - Delta</A><BR>
					<b>Create Weather</b><BR>
					<A href='?src=[UID()];secretsfun=weatherashstorm'>Weather - Ash Storm</A>&nbsp;&nbsp;
					<BR>
					</center>"}

		if(2)
			if(check_rights((R_SERVER|R_EVENT),0))
				dat += {"
					<center>
					<h2><B>OOC Events</B></h2>
					<b>Thunderdome</b><br>
					<A href='?src=[UID()];secretsfun=tdomestart'>Start a Thunderdome match</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=tdomereset'>Reset Thunderdome to default state</A><BR><br>
					<b>ERT Armory</b><br>
					<A href='?src=[UID()];secretsfun=armotyreset'>Reset Armory to default state</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset1'>Set Armory to 1 option</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset2'>Set Armory to 2 option</A><BR><br>
					<A href='?src=[UID()];secretsfun=armotyreset3'>Set Armory to 3 option</A><BR><br>
					<b>Clothing</b><br>
					<A href='?src=[UID()];secretsfun=sec_clothes'>Remove 'internal' clothing</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=sec_all_clothes'>Remove ALL clothing</A><BR>
					<b>TDM</b><br>
					<A href='?src=[UID()];secretsfun=traitor_all'>Everyone is the traitor</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyone'>There can only be one!</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyme'>There can only be me!</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=onlyoneteam'>Dodgeball (TDM)!</A><BR>
					<b>Round-enders</b><br>
					<A href='?src=[UID()];secretsfun=floorlava'>The floor is lava! (DANGEROUS: extremely lame)</A><BR>
					<A href='?src=[UID()];secretsfun=fakelava'>The floor is fake-lava! (non-harmful)</A><BR>
					<A href='?src=[UID()];secretsfun=monkey'>Turn all humans into monkeys</A><BR>
					<A href='?src=[UID()];secretsfun=fakeguns'>Make all items look like guns</A><BR>
					<A href='?src=[UID()];secretsfun=prisonwarp'>Warp all Players to Prison</A><BR>
					<A href='?src=[UID()];secretsfun=stupify'>Make all players stupid</A><BR>
					<b>Misc</b><br>
					<A href='?src=[UID()];secretsfun=sec_classic1'>Remove firesuits, grilles, and pods</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=tripleAI'>Triple AI mode (needs to be used in the lobby)</A><BR>
					<A href='?src=[UID()];secretsfun=flicklights'>Ghost Mode</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=schoolgirl'>Japanese Animes Mode</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=eagles'>Egalitarian Station Mode</A><BR>
					<A href='?src=[UID()];secretsfun=guns'>Summon Guns</A>&nbsp;&nbsp;
					<A href='?src=[UID()];secretsfun=magic'>Summon Magic</A>
					<BR>
					<A href='?src=[UID()];secretsfun=rolldice'>Roll the Dice</A><BR>
					<BR>
					<BR>
					<A href='?src=[UID()];secretsfun=moveferry'>Move Ferry</A><BR>
					<A href='?src=[UID()];secretsfun=moveminingshuttle'>Move Mining Shuttle</A><BR>
					<A href='?src=[UID()];secretsfun=movelaborshuttle'>Move Labor Shuttle</A><BR>
					<BR>
					</center>"}
	dat += "</center></body></html>"
	var/datum/browser/popup = new(usr, "secrets", "<div align='center'>Admin Secrets</div>", 630, 670)
	popup.set_content(dat)
	popup.open(0)
