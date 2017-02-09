/datum/malf_research
	var/stored_cpu = 0								// Currently stored amount of CPU time.
	var/last_tick = 0								// Last process() tick.
	var/max_cpu = 0									// Maximal amount of CPU time stored.
	var/cpu_increase_per_tick = 0					// Amount of CPU time generated by tick
	var/list/available_abilities = null				// List of available abilities that may be researched.
	var/list/unlocked_abilities = null				// List of already unlocked abilities.
	var/mob/living/silicon/ai/owner = null			// AI which owns this research datum.
	var/datum/malf_research_ability/focus = null	// Currently researched item

/datum/malf_research/New()
	setup_abilities()
	last_tick = world.time


// Proc:		setup_abilities()
// Parameters: 	None
// Description: Sets up basic abilities for AI Malfunction gamemode.
/datum/malf_research/proc/setup_abilities()
	available_abilities = list()
	unlocked_abilities = list()

	available_abilities += new/datum/malf_research_ability/networking/basic_hack()
	available_abilities += new/datum/malf_research_ability/interdiction/recall_shuttle()
	available_abilities += new/datum/malf_research_ability/manipulation/electrical_pulse()
	available_abilities += new/datum/malf_research_ability/passive/intellicard_interception

// Proc:		finish_research()
// Parameters: 	None
// Description: Finishes currently focused research.
/datum/malf_research/proc/finish_research()
	if(!focus)
		return
	to_chat(owner, "<b>Research Completed</b>: [focus.name]")
	if(focus.ability)
		owner.verbs.Add(focus.ability)
	focus.research_finished(owner)
	if(focus.next)
		available_abilities += focus.next
	unlocked_abilities += focus
	available_abilities -= focus
	focus = null

// Proc:		process()
// Parameters: 	None
// Description: Processes CPU gain and research progress based on "realtime" calculation.
/datum/malf_research/proc/process(var/idle = 0)
	if(idle)		// No power or running on APU. Do nothing.
		last_tick = world.time
		return
	var/time_diff = (world.time - last_tick)
	last_tick = world.time
	var/cpu_gained = time_diff * cpu_increase_per_tick
	if(cpu_gained < 0)
		return // This shouldn't happen, but just in case..
	if(max_cpu > stored_cpu)
		var/given = min((max_cpu - stored_cpu), cpu_gained)
		stored_cpu += given
		cpu_gained -= given

	cpu_gained = max(0, cpu_gained)
	if(focus && (cpu_gained > 0))
		focus.process(cpu_gained)
		if(focus.unlocked)
			finish_research()

/datum/malf_research/proc/advance_all()
	var/list/to_advance = list()
	// First remember a copy of all research that's available now, then finish them one by one.
	for(var/datum/malf_research_ability/MRA in available_abilities)
		to_advance.Add(MRA)

	for(var/datum/malf_research_ability/MRA in to_advance)
		focus = MRA
		finish_research()



