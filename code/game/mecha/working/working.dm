/obj/mecha/working
	deflect_chance = 10
	health = 500
	req_access = access_heads
	operation_req_access = list(access_engine,access_robotics)
	internals_req_access = list(access_engine,access_robotics)
	var/add_req_access = 1
	internal_damage_threshold = 70

/obj/mecha/working/New()
	..()
	new /obj/item/mecha_tracking(src)
	return

/*
/obj/mecha/working/melee_action(atom/target as obj|mob|turf)
	if(internal_damage&MECHA_INT_CONTROL_LOST)
		target = pick(oview(1,src))
	if(selected_tool)
		selected_tool.action(target)
	return
*/

/obj/mecha/working/range_action(atom/target as obj|mob|turf)
	return

/obj/mecha/working/Topic(href, href_list)
	..()
	if (href_list["unlock_id_upload"])
		add_req_access = 1
	if (href_list["add_req_access"])
		if(!add_req_access) return
		var/access = text2num(href_list["add_req_access"])
		operation_req_access += access
		output_access_dialog(locate(href_list["id_card"]),locate(href_list["user"]))
	if (href_list["del_req_access"])
		operation_req_access -= text2num(href_list["del_req_access"])
		output_access_dialog(locate(href_list["id_card"]),locate(href_list["user"]))
	if (href_list["finish_req_access"])
		add_req_access = 0
		var/mob/user = locate(href_list["user"])
		user << browse(null,"window=exosuit_add_access")
	return

/obj/mecha/working/get_stats_part()
	var/output = ..()
	output += "<b>[src.name] Tools:</b><div style=\"margin-left: 15px;\">"
	if(equipment.len)
		for(var/obj/item/mecha_parts/mecha_equipment/MT in equipment)
			output += "[selected==MT?"<b>":"<a href='?src=\ref[src];select_equip=\ref[MT]'>"][MT.get_equip_info()][selected==MT?"</b>":"</a>"]<br>"
	else
		output += "None"
	output += "</div>"
	return output


/obj/mecha/working/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(add_req_access && (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda)))
		var/obj/item/weapon/card/id/id_card
		if(istype(W, /obj/item/weapon/card/id))
			id_card = W
		else
			var/obj/item/device/pda/pda = W
			id_card = pda.id
		output_access_dialog(id_card, user)
	else
		return ..()

/obj/mecha/working/get_commands()
	var/output = {"<a href='?src=\ref[src];unlock_id_upload=1'>Unlock ID upload panel</a><br>
				"}
	output += ..()
	return output


/obj/mecha/working/proc/output_access_dialog(obj/item/weapon/card/id/id_card, mob/user)
	if(!id_card || !user) return
	var/output = "<html><head></head><body><b>Following keycodes are present in this system:</b><br>"
	for(var/a in operation_req_access)
		output += "[get_access_desc(a)] - <a href='?src=\ref[src];del_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Delete</a><br>"
	output += "<hr><b>Following keycodes were detected on portable device:</b><br>"
	for(var/a in id_card.access)
		if(a in operation_req_access) continue
		var/a_name = get_access_desc(a)
		if(!a_name) continue //there's some strange access without a name
		output += "[a_name] - <a href='?src=\ref[src];add_req_access=[a];user=\ref[user];id_card=\ref[id_card]'>Add</a><br>"
	output += "<hr><a href='?src=\ref[src];finish_req_access=1;user=\ref[user]'>Finish</a> <font color='red'>(Warning! The ID upload panel will be locked. It can be unlocked only through Exosuit Interface.)</font>"
	output += "</body></html>"
	user << browse(output, "window=exosuit_add_access")
	onclose(user, "exosuit_add_access")
	return
