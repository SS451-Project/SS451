/mob/living
	var/datum/language/default_language

/mob/living/verb/set_default_language(language as null|anything in languages)
	set name = "Установить язык по умолчанию"
	set category = "IC"

	if(language)
		to_chat(src, "<span class='notice'>Теперь вы будете говорить на [language], если не укажете другой язык при разговоре.</span>")
	else
		to_chat(src, "<span class='notice'>Теперь вы будете говорить на стандартном языке по умолчанию, если вы не укажете другой при разговоре.</span>")
	default_language = language

// Silicons can't neccessarily speak everything in their languages list
/mob/living/silicon/set_default_language(language as null|anything in speech_synthesizer_langs)
	..()

/mob/living/verb/check_default_language()
	set name = "Проверить известные языки"
	set category = "IC"

	if(default_language)
		to_chat(src, "<span class='notice'>В настоящее время вы говорите на [default_language] по умолчанию.</span>")
	else
		to_chat(src, "<span class='notice'>Ваш текущий язык по умолчанию - это ваш вид или тип моба по умолчанию.</span>")
