/mob/living/carbon/verb/give(var/mob/living/carbon/target in oview(1))
	set category = "IC"
	set name = "Дать"

	if(!iscarbon(target)) //something is bypassing the give arguments, no clue what, adding a sanity check JIC
		to_chat(usr, "<span class='danger'>Секундочку... У [target] НЕТУ РУК! ЧТОБ ТЕБЯ!</span>")//cheesy messages ftw
		return

	if(target.incapacitated() || usr.incapacitated() || target.client == null)
		return

	var/obj/item/I = get_active_hand()

	if(!I)
		to_chat(usr, "<span class='warning'> У тебя в руках нет ничего, что можно было бы отдать [target.name]</span>")
		return
	if((I.flags & NODROP) || (I.flags & ABSTRACT))
		to_chat(usr, "<span class='notice'>Это не совсем то, что ты можешь дать.</span>")
		return
	if(target.r_hand == null || target.l_hand == null)
		var/ans = alert(target,"[usr] хочет дать тебе [I]. Взять?",,"Да","Нет")
		if(!I || !target)
			return
		switch(ans)
			if("Да")
				if(target.incapacitated() || usr.incapacitated())
					return
				if(!Adjacent(target))
					to_chat(usr, "<span class='warning'> Вам нужно оставаться на расстоянии вытянутой руки, отдавая объект.</span>")
					to_chat(target, "<span class='warning'> [usr.name] отошёл слишком далеко.</span>")
					return
				if((I.flags & NODROP) || (I.flags & ABSTRACT))
					to_chat(usr, "<span class='warning'>[I] остается прилипшим к вашей руке, когда вы пытаетесь ее отдать!</span>")
					to_chat(target, "<span class='warning'>[I] остается прилипшим к руке [usr.name] когда ты пытаешься взять это!</span>")
					return
				if(I != get_active_hand())
					to_chat(usr, "<span class='warning'> Вам нужно держать предмет в активной руке.</span>")
					to_chat(target, "<span class='warning'> [usr.name] кажется, я отказался от того, чтобы отдавать вам [I].</span>")
					return
				if(target.r_hand != null && target.l_hand != null)
					to_chat(target, "<span class='warning'> У тебя полны руки.</span>")
					to_chat(usr, "<span class='warning'> У [usr.name] полны руки.</span>")
					return
				usr.unEquip(I)
				target.put_in_hands(I)
				I.add_fingerprint(target)
				target.visible_message("<span class='notice'> [usr.name] передал [I] [target.name].</span>")
				I.on_give(usr, target)
			if("Нет")
				target.visible_message("<span class='warning'> [usr.name] пытается передать [I] [target.name] но [target.name] отказался.</span>")
	else
		to_chat(usr, "<span class='warning'> Руки [target.name] оказались полными.</span>")
