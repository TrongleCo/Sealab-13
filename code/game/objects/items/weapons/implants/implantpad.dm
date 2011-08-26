/obj/item/weapon/implantpad
	name = "implantpad"
	desc = "Used to modify implants."
	icon = 'items.dmi'
	icon_state = "implantpad-0"
	item_state = "electronic"
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	var
		obj/item/weapon/implantcase/case = null
		broadcasting = null
		listening = 1.0
	proc
		update()


	update()
		if (src.case)
			src.icon_state = "implantpad-1"
		else
			src.icon_state = "implantpad-0"
		return


	attack_hand(mob/user as mob)
		if ((src.case && (user.l_hand == src || user.r_hand == src)))
			if (user.hand)
				user.l_hand = src.case
			else
				user.r_hand = src.case
			src.case.loc = user
			src.case.layer = 20
			src.case.add_fingerprint(user)
			src.case = null
			user.update_clothing()
			src.add_fingerprint(user)
			update()
		else
			if (user.contents.Find(src))
				spawn( 0 )
					src.attack_self(user)
					return
			else
				return ..()
		return


	attackby(obj/item/weapon/implantcase/C as obj, mob/user as mob)
		..()
		if(istype(C, /obj/item/weapon/implantcase))
			if(!( src.case ))
				user.drop_item()
				C.loc = src
				src.case = C
		else
			return
		src.update()
		return


	attack_self(mob/user as mob)
		user.machine = src
		var/dat = "<B>Implant Mini-Computer:</B><HR>"
		if (src.case)
			if(src.case.imp)
				if(istype(src.case.imp, /obj/item/weapon/implant))
					dat += src.case.imp.get_data()
			else
				dat += "The implant casing is empty."
		else
			dat += "Please insert an implant casing!"
		user << browse(dat, "window=implantpad")
		onclose(user, "implantpad")
		return

/*
	Topic(href, href_list)
		..()
		if (usr.stat)
			return
		if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
			usr.machine = src
			if (href_list["id"])
				if ((istype(src.case, /obj/item/weapon/implantcase) && istype(src.case.imp, /obj/item/weapon/implant/tracking)))
					var/obj/item/weapon/implant/tracking/T = src.case.imp
					T.id += text2num(href_list["id"])
					T.id = min(100, T.id)
					T.id = max(1, T.id)
			if (istype(src.loc, /mob))
				attack_self(src.loc)
			else
				for(var/mob/M in viewers(1, src))
					if (M.client)
						src.attack_self(M)
					//Foreach goto(290)
			src.add_fingerprint(usr)
		else
			usr << browse(null, "window=implantpad")
			return
		return*/