/mob/living/simple_animal/spiderbot

	min_oxy = 0
	max_tox = 0
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 500

	var/obj/item/device/radio/borg/radio = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/item/weapon/cell/cell = null
	var/obj/machinery/camera/camera = null
	var/obj/item/device/mmi/mmi = null

	name = "spider-bot"
	desc = "A skittering robotic chassis!"
	icon = 'icons/mob/robots.dmi'
	icon_state = "spiderbot-chassis"
	icon_living = "spiderbot-chassis"
	icon_dead = "spiderbot-smashed"
	small = 1
	speak_emote = list("beeps","clicks","chirps")
	health = 10
	maxHealth = 10
	attacktext = "shocks"
	attacktext = "shocks"
	melee_damage_lower = 1
	melee_damage_upper = 3
	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "stomps on"
	wander = 0
	speed = -1 //Spiderbots gotta go fast.

/mob/living/simple_animal/spiderbot/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(istype(O, /obj/item/device/mmi) || istype(O, /obj/item/device/posibrain))
		var/obj/item/device/mmi/B = O
		if(src.mmi) //There's already a brain in it.
			user << "\red There's already a brain in [src]!"
			return
		if(!B.brainmob)
			user << "\red Sticking an empty MMI into the frame would sort of defeat the purpose."
			return
		if(!B.brainmob.key)
			var/ghost_can_reenter = 0
			if(B.brainmob.mind)
				for(var/mob/dead/observer/G in player_list)
					if(G.can_reenter_corpse && G.mind == B.brainmob.mind)
						ghost_can_reenter = 1
						break
			if(!ghost_can_reenter)
				user << "<span class='notice'>[O] is completely unresponsive; there's no point.</span>"
				return

		if(B.brainmob.stat == DEAD)
			user << "\red [O] is dead. Sticking it into the frame would sort of defeat the purpose."
			return

		if(jobban_isbanned(B.brainmob, "Cyborg"))
			user << "\red [O] does not seem to fit."
			return

		user << "\blue You install [O] in [src]!"

		user.drop_item()
		src.mmi = O
		src.transfer_personality(O)

		O.loc = src
		src.update_icon()

	else
		if(O.force)
			var/damage = O.force
			if (O.damtype == HALLOSS)
				damage = 0
			adjustBruteLoss(damage)
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("\red \b [src] has been attacked with the [O] by [user]. ")
		else
			usr << "\red This weapon is ineffective, it does no damage."
			for(var/mob/M in viewers(src, null))
				if ((M.client && !( M.blinded )))
					M.show_message("\red [user] gently taps [src] with the [O]. ")

/mob/living/simple_animal/spiderbot/proc/transfer_personality(var/obj/item/device/mmi/M as obj)

		src.mind = M.brainmob.mind
		src.mind.key = M.brainmob.key
		src.name = "spider-bot ([M.brainmob.name])"

/mob/living/simple_animal/spiderbot/proc/update_icon()
	if(mmi)
		if (istype(mmi,/obj/item/device/mmi))
			icon_state = "spiderbot-chassis-mmi"
			icon_living = "spiderbot-chassis-mmi"
		else
			icon_state = "spiderbot-chassis-posi"
			icon_living = "spiderbot-chassis-posi"
	else
		icon_state = "spiderbot-chassis"
		icon_living = "spiderbot-chassis"

/mob/living/simple_animal/spiderbot/Del()
	if(mmi)
		var/turf/T = get_turf(loc)
		if(T)
			mmi.loc = T
		if(mind)	mind.transfer_to(mmi.brainmob)
		mmi = null
	..()

/mob/living/simple_animal/spiderbot/New()

	radio = new /obj/item/device/radio/borg(src)
	camera = new /obj/machinery/camera(src)
	camera.c_tag = real_name
	camera.network = list("SS13")

	..()

/mob/living/simple_animal/spiderbot/Die()

	living_mob_list -= src
	dead_mob_list += src

	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message("\red Damaged beyond repair, [src] explodes in a spray of scrap metal.")

	if(camera)
		camera.status = 0

	robogibs(src.loc, viruses)
	src.Del()
	return

//copy paste from alien/larva, if that func is updated please update this one also
/mob/living/simple_animal/spiderbot/verb/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Spiderbot"

//	if(!istype(V,/obj/machinery/atmoalter/siphs/fullairsiphon/air_vent))
//		return
	var/obj/machinery/atmospherics/unary/vent_pump/vent_found
	var/welded = 0
	for(var/obj/machinery/atmospherics/unary/vent_pump/v in range(1,src))
		if(!v.welded)
			vent_found = v
			break
		else
			welded = 1
	if(vent_found)
		if(vent_found.network&&vent_found.network.normal_members.len)
			var/list/vents = list()
			for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
				if(temp_vent.loc == loc)
					continue
				vents.Add(temp_vent)
			var/list/choices = list()
			for(var/obj/machinery/atmospherics/unary/vent_pump/vent in vents)
				if(vent.loc.z != loc.z)
					continue
				var/atom/a = get_turf(vent)
				choices.Add(a.loc)
			var/turf/startloc = loc
			var/obj/selection = input("Select a destination.", "Duct System") in choices
			var/selection_position = choices.Find(selection)
			if(loc==startloc)
				var/obj/target_vent = vents[selection_position]
				if(target_vent)
					/*
					for(var/mob/O in oviewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<B>[src] scrambles into the ventillation ducts!</B>"), 1)
					*/
					loc = target_vent.loc
			else
				src << "\blue You need to remain still while entering a vent."
		else
			src << "\blue This vent is not connected to anything."
	else if(welded)
		src << "\red That vent is welded."
	else
		src << "\blue You must be standing on or beside an air vent to enter it."
	return

//copy paste from alien/larva, if that func is updated please update this one alsoghost
/mob/living/simple_animal/spiderbot/verb/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Spiderbot"

	if (layer != TURF_LAYER+0.2)
		layer = TURF_LAYER+0.2
		src << text("\blue You are now hiding.")
		/*
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("<B>[] scurries to the ground!</B>", src)
		*/
	else
		layer = MOB_LAYER
		src << text("\blue You have stopped hiding.")
		/*
		for(var/mob/O in oviewers(src, null))
			if ((O.client && !( O.blinded )))
				O << text("[] slowly peaks up from the ground...", src)
		*/