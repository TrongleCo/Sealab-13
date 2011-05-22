/*
Revised. Original based on space ninja hologram code. Which is also mine. /N
How it works:
AI clicks on holopad in camera view. View centers on holopad.
AI clicks again on the holopad to display a hologram. Hologram stays as long as AI is looking at the pad and it (the hologram) is in range of the pad.
AI can use the directional keys to move the hologram around, provided the above conditions are met and the AI in question is the holopad's master.
Only one AI may project from a holopad at any given time.
AI may cancel the hologram at any time by clicking on the holopad once more.

Possible to do for anyone motivated enough:
	Give an AI variable for different hologram icons.
	Itegrate EMP effects to disable the unit.
*/
/obj/machinery/holopad/attack_ai(var/mob/living/silicon/ai/user as mob)
	if (!istype(user))
		return
	/*There are pretty much only three ways to interact here.
	I don't need to check for client since they're clicking on an object.
	This may change in the future but for now will suffice.*/
	if(user.client.eye!=src)//Set client eye on the object if it's not already.
		user.current = src
		user.reset_view(src)
	else if(!hologram)//If there is no hologram, possibly make one.
		activate_holo(user)
	else if(master==user)//If there is a hologram, remove it. But only if the user is the master. Otherwise do nothing.
		clear_holo()
	return

/obj/machinery/holopad/proc/activate_holo(var/mob/living/silicon/ai/user as mob)
	if(!(stat & NOPOWER)&&user.client.eye==src)//If the projector has power and client eye is on it.
		if(!hologram)//If there is not already a hologram.
			create_holo(user)//Create one.
			for(var/mob/M in viewers())
				M.show_message("A holographic image of [user] flicks to life right before your eyes!",1)
		else
			user << "\red ERROR: \black Image feed in progress."
	else
		user << "\red ERROR: \black Unable to project hologram."
	return

/*This is the proc for special two-way communication between AI and holopad/people talking near holopad.
For the other part of the code, check silicon say.dm. Particularly robot talk.*/
/obj/machinery/holopad/hear_talk(mob/M as mob, text)
	if(M&&hologram&&master)//Master is mostly a safety in case lag hits or something.
		if(!master.say_understands(M))//The AI will be able to understand most mobs talking through the holopad.
			text = stars(text)
		var/name_used = M.name
		if(istype(M.wear_mask, /obj/item/clothing/mask/gas/voice)&&M.wear_mask:vchange)//Can't forget the ninjas.
			name_used = M.wear_mask:voice
		//This communication is imperfect because the holopad "filters" voices and is only designed to connect to the master only.
		var/rendered = "<i><span class='game say'>Holopad received, <span class='name'>[name_used]</span> <span class='message'>[M.say_quote(text)]</span></span></i>"
		master.show_message(rendered, 2)
	return

/obj/machinery/holopad/proc/create_holo(var/mob/living/silicon/ai/A, var/turf/T = loc)
	hologram = new(T)//Spawn a blank effect at the location.
	hologram.icon = 'mob.dmi'
	hologram.icon_state = "ai-holo"
	hologram.mouse_opacity = 0//So you can't click on it.
	hologram.sd_SetLuminosity(1)//To make it glowy.
	sd_SetLuminosity(1)//To make the pad glowy.
	icon_state = "holopad1"
	master = A//AI is the master.
	use_power = 2//Active power usage.
	return 1

/obj/machinery/holopad/proc/clear_holo()
	hologram.sd_SetLuminosity(0)//Clear lighting.
	del(hologram)//Get rid of hologram.
	master = null//Null the master, since no-one is using it now.
	sd_SetLuminosity(0)//Clear lighting for the parent.
	icon_state = "holopad0"
	use_power = 1//Passive power usage.
	return 1

/obj/machinery/holopad/process()
	if(hologram)//If there is a hologram.
		if(master&&!master.stat&&master.client&&master.client.eye==src)//If there is an AI attached, it's not incapacitated, it has a client, and the client eye is centered on the projector.
			if( !(get_dist(src,hologram.loc)>3||stat & NOPOWER) )//If the hologram is not out of bounds and the machine has power.
				return 1
		clear_holo()//If not, we want to get rid of the hologram.
	return 1

/obj/machinery/holopad/power_change()
	if (powered())
		stat &= ~NOPOWER
	else
		stat |= ~NOPOWER

//Destruction procs.
/obj/machinery/holopad/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				del(src)
		if(3.0)
			if (prob(5))
				del(src)
	return

/obj/machinery/holopad/blob_act()
	del(src)
	return

/obj/machinery/holopad/meteorhit()
	del(src)
	return

/obj/machinery/holopad/Del()
	if(hologram)
		clear_holo()
	..()