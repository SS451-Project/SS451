/mob/living/carbon/brain/emote(act,m_type = 1, message = null, force)
	if(!(container && istype(container, /obj/item/mmi)))//No MMI, no emotes
		return

	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	if(src.stat == DEAD)
		return
	act = lowertext(act)
	switch(act)

		if("alarm")
			to_chat(src, "Ты бьешь тревогу.")
			message = "<B>[src]</B> издает сигнал тревоги."
			m_type = 2
		if("alert")
			to_chat(src, "Ты издал огорченный звук.")
			message = "<B>[src]</B> издает огорченный звук."
			m_type = 2
		if("notice")
			to_chat(src, "Ты играешь громким тоном.")
			message = "<B>[src]</B> играет громким тоном."
			m_type = 2
		if("flash")
			message = "Индикаторы на <B>[src]</B> быстро мигают."
			m_type = 1
		if("blink")
			message = "<B>[src]</B> моргает."
			m_type = 1
		if("whistle")
			to_chat(src, "Ты свистишь.")
			message = "<B>[src]</B> свистит."
			m_type = 2
		if("beep")
			to_chat(src, "Ты пищишь.")
			message = "<B>[src]</B> пищит."
			m_type = 2
		if("boop")
			to_chat(src, "Ты издаешь звук 'буп'.")
			message = "<B>[src]</B> издает звук 'буп'."
			m_type = 2
		if("help")
			to_chat(src, "alarm, alert, notice, flash,blink, whistle, beep, boop")

	if(message && !stat)
		..()
