/////////////////////
// DISABILITY GENES
//
// These activate either a mutation, disability
//
// Gene is always activated.
/////////////////////

/datum/dna/gene/disability
	name = "DISABILITY"

	// Mutation to give (or 0)
	var/mutation = 0

	// Activation message
	var/activation_message = ""

	// Yay, you're no longer growing 3 arms
	var/deactivation_message = ""

/datum/dna/gene/disability/can_activate(mob/M, flags)
	return TRUE // Always set!

/datum/dna/gene/disability/activate(mob/living/M, connected, flags)
	..()
	M.mutations |= mutation
	if(activation_message)
		to_chat(M, "<span class='warning'>[activation_message]</span>")
	else
		testing("[name] has no activation message.")

/datum/dna/gene/disability/deactivate(mob/living/M, connected, flags)
	..()
	M.mutations.Remove(mutation)
	if(deactivation_message)
		to_chat(M, "<span class='warning'>[deactivation_message]</span>")
	else
		testing("[name] has no deactivation message.")

/datum/dna/gene/disability/hallucinate
	name = "Hallucinate"
	activation_message = "Твой разум говорит 'Привет'."
	deactivation_message = "Здравомыслие возвращается. Или так оно и есть?"
	instability = -GENE_INSTABILITY_MODERATE
	mutation = HALLUCINATE

/datum/dna/gene/disability/hallucinate/New()
	..()
	block = GLOB.hallucinationblock

/datum/dna/gene/disability/hallucinate/OnMobLife(mob/living/carbon/human/H)
	if(prob(1))
		H.AdjustHallucinate(45)

/datum/dna/gene/disability/epilepsy
	name = "Epilepsy"
	activation_message = "У тебя начинает болеть голова."
	deactivation_message = "Наконец-то твоя головная боль прошла."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = EPILEPSY

/datum/dna/gene/disability/epilepsy/New()
	..()
	block = GLOB.epilepsyblock

/datum/dna/gene/disability/epilepsy/OnMobLife(mob/living/carbon/human/H)
	if((prob(1) && H.paralysis < 1))
		H.visible_message("<span class='danger'>У [H] начинается припадок!</span>","<span class='alert'>У тебя припадок!</span>")
		H.Paralyse(10)
		H.Jitter(1000)

/datum/dna/gene/disability/cough
	name = "Coughing"
	activation_message = "Ты начинаешь кашлять."
	deactivation_message = "Твое горло перестает болеть."
	instability = -GENE_INSTABILITY_MINOR
	mutation = COUGHING

/datum/dna/gene/disability/cough/New()
	..()
	block = GLOB.coughblock

/datum/dna/gene/disability/cough/OnMobLife(mob/living/carbon/human/H)
	if((prob(5) && H.paralysis <= 1))
		H.drop_item()
		H.emote("cough")

/datum/dna/gene/disability/clumsy
	name = "Clumsiness"
	activation_message = "У тебя кружится голова."
	deactivation_message = "Вы восстанавливаете некоторый контроль над своими движениями."
	instability = -GENE_INSTABILITY_MINOR
	mutation = CLUMSY

/datum/dna/gene/disability/clumsy/New()
	..()
	block = GLOB.clumsyblock

/datum/dna/gene/disability/tourettes
	name = "Tourettes"
	activation_message = "Тебя трясёт."
	deactivation_message = "У тебя во рту вкус мыла."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = TOURETTES

/datum/dna/gene/disability/tourettes/New()
	..()
	block = GLOB.twitchblock

/datum/dna/gene/disability/tourettes/OnMobLife(mob/living/carbon/human/H)
	if((prob(10) && H.paralysis <= 1))
		H.Stun(10)
		switch(rand(1, 3))
			if(1)
				H.emote("twitch")
			if(2 to 3)
				H.say("[prob(50) ? ";" : ""][pick("ГОВНО", "МОЧА", "БЛЯТЬ", "ПИЗДА", "ХУЕСОС", "ВЫБЛЯДОК", "ХУЙ", "ХОС ХУЕСОС", "СУКА", "ПОШЁЛ НАХУЙ", "ХЕРНЯ", "КОКПИТАН", "ДОЛБАЁБ", "ЕБЛЯ", "НАМ ПИЗДА", "МРАЗЬ", "МУДАК", "ЖОПА", "СРАНЬ")]")
		var/x_offset_old = H.pixel_x
		var/y_offset_old = H.pixel_y
		var/x_offset = H.pixel_x + rand(-2, 2)
		var/y_offset = H.pixel_y + rand(-1, 1)
		animate(H, pixel_x = x_offset, pixel_y = y_offset, time = 1)
		animate(H, pixel_x = x_offset_old, pixel_y = y_offset_old, time = 1)

/datum/dna/gene/disability/nervousness
	name = "Nervousness"
	activation_message="Ты начинаешь нервничать."
	deactivation_message ="Ты чувствуешь себя намного спокойнее."
	mutation = NERVOUS

/datum/dna/gene/disability/nervousness/New()
	..()
	block = GLOB.nervousblock

/datum/dna/gene/disability/nervousness/OnMobLife(mob/living/carbon/human/H)
	if(prob(10))
		H.Stuttering(10)

/datum/dna/gene/disability/blindness
	name = "Blindness"
	activation_message = "Кажется, ты ничего не видишь."
	deactivation_message = "Теперь ты можешь видеть, если ещё не заметили..."
	instability = -GENE_INSTABILITY_MAJOR
	mutation = BLINDNESS

/datum/dna/gene/disability/blindness/New()
	..()
	block = GLOB.blindblock

/datum/dna/gene/disability/blindness/activate(mob/M, connected, flags)
	..()
	M.update_blind_effects()

/datum/dna/gene/disability/blindness/deactivate(mob/M, connected, flags)
	..()
	M.update_blind_effects()


/datum/dna/gene/disability/colourblindness
	name = "Colourblindness"
	activation_message = "Ты чувствуешь странное покалывание в глазах, в то время как восприятие цвета меняется."
	deactivation_message ="Твои глаза тревожно щиплет, хотя все, кажется, становится намного красочнее."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = COLOURBLIND

/datum/dna/gene/disability/colourblindness/New()
	..()
	block = GLOB.colourblindblock

/datum/dna/gene/disability/colourblindness/activate(mob/M, connected, flags)
	..()
	M.update_client_colour() //Handle the activation of the colourblindness on the mob.
	M.update_icons() //Apply eyeshine as needed.

/datum/dna/gene/disability/colourblindness/deactivate(mob/M, connected, flags)
	..()
	M.update_client_colour() //Handle the deactivation of the colourblindness on the mob.
	M.update_icons() //Remove eyeshine as needed.

/datum/dna/gene/disability/deaf
	name = "Deafness"
	activation_message="Здесь как-то тихо."
	deactivation_message ="Ты снова можешь слышать!"
	instability = -GENE_INSTABILITY_MAJOR
	mutation = DEAF

/datum/dna/gene/disability/deaf/New()
	..()
	block = GLOB.deafblock

/datum/dna/gene/disability/deaf/activate(mob/M, connected, flags)
	..()
	M.MinimumDeafTicks(1)

/datum/dna/gene/disability/nearsighted
	name = "Nearsightedness"
	activation_message="У тебя странно ведут себя глаза..."
	deactivation_message ="Теперь ты ясно видишь."
	instability = -GENE_INSTABILITY_MODERATE
	mutation = NEARSIGHTED

/datum/dna/gene/disability/nearsighted/New()
	..()
	block = GLOB.glassesblock

/datum/dna/gene/disability/nearsighted/activate(mob/living/M, connected, flags)
	..()
	M.update_nearsighted_effects()

/datum/dna/gene/disability/nearsighted/deactivate(mob/living/M, connected, flags)
	..()
	M.update_nearsighted_effects()

/datum/dna/gene/disability/lisp
	name = "Lisp"
	desc = "Интересно, что оно делает."
	activation_message = "Сто-то не так, как казетшя."
	deactivation_message = "Теперь ты чувствуешь, что можете произносить согласные."
	mutation = LISP

/datum/dna/gene/disability/lisp/New()
	..()
	block = GLOB.lispblock

/datum/dna/gene/disability/lisp/OnSay(mob/M, message)
	return replacetext(message,"с",pick("щ","ш","ф"))

/datum/dna/gene/disability/comic
	name = "Comic"
	desc = "Привносит только смерть и разрушение."
	activation_message = "<span class='sans'>О ёй!</span>"
	deactivation_message = "Ну, хвала Богу, с этим покончено."
	mutation = COMIC

/datum/dna/gene/disability/comic/New()
	..()
	block = GLOB.comicblock

/datum/dna/gene/disability/wingdings
	name = "Alien Voice"
	desc = "Искажает голос субъекта в непонятную речь."
	activation_message = "<span class='wingdings'>Твои голосовые связки кажутся инопланетными.</span>"
	deactivation_message = "Ваши голосовые связки больше не чувствуют себя инопланетными."
	instability = -GENE_INSTABILITY_MINOR
	mutation = WINGDINGS

/datum/dna/gene/disability/wingdings/New()
	..()
	block = GLOB.wingdingsblock

/datum/dna/gene/disability/wingdings/OnSay(mob/M, message)
	var/garbled_message = ""
	for(var/i in 1 to length(message))
		if(message[i] in GLOB.alphabet_uppercase)
			garbled_message += pick(GLOB.alphabet_uppercase)
		else if(message[i] in GLOB.alphabet)
			garbled_message += pick(GLOB.alphabet)
		else
			garbled_message += message[i]
	message = garbled_message
	return message
