/////////////////////////////////////////////////////////////////////////////////////////
// Research
/////////////////////////////////////////////////////////////////////////////////////////

// MAXIMUM SCIENCE
/datum/job_objective/further_research
	completion_payment = 5
	per_unit = 1

/datum/job_objective/further_research/get_description()
	var/desc = "Исследуйте технические уровни и отправьте их грузом в CentComm."
	desc += "([units_completed] выполнено.)"
	return desc

/datum/job_objective/maximize_research/check_for_completion()
	for(var/tech in SSshuttle.techLevels)
		if(SSshuttle.techLevels[tech] > 0)
			return 1
	return 0

/////////////////////////////////////////////////////////////////////////////////////////
// Robotics
/////////////////////////////////////////////////////////////////////////////////////////

//Cyborgs
/datum/job_objective/make_cyborg
	completion_payment = 100
	per_unit = 1

/datum/job_objective/make_cyborg/get_description()
	var/desc = "Создать киборга."
	desc += "([units_completed] создано.)"
	return desc



//RIPLEY's
/datum/job_objective/make_ripley
	completion_payment = 600
	per_unit = 1

/datum/job_objective/make_ripley/get_description()
	var/desc = "Создайте Рипли или Огнеборца."
	desc += "([units_completed] создано.)"
	return desc
