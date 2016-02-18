/obj/item/weapon/contract
	name = "contract"
	desc = "written in the blood of some unfortunate fellow."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"

	var/contract_master = null

/obj/item/weapon/contract/attack_self(mob/user as mob)
	if(contract_master == null)
		user << "<span class='notice'>You bind the contract to your soul, making you the recipient of whatever poor fool's soul that decides to contract with you.</span>"
		contract_master = user
		return

	if(contract_master == user)
		user << "You can't contract with yourself!"
		return

	var/ans = alert(user,"The contract clearly states that signing this contract will bind your soul to \the [contract_master]. Are you sure you want to continue?","[src]","Yes","No")

	if(ans == "Yes")
		user.visible_message("\The [user] signs the contract, their body glowing a deep yellow.")
		if(!src.contract_effect(user))
			user.visible_message("\The [src] visibly rejects \the [user]. Erasing their signature from the line.")
			return
		user.visible_message("\The [src] disappears with a flash of light.")
		if(istype(contract_master,/mob/living)) //if it aint text its probably a mob or another user
			var/mob/living/M = contract_master
			M.add_spell(new /spell/contract/reward(user), "const_spell_ready")
			M.add_spell(new /spell/contract/punish(user), "const_spell_ready")
			M.add_spell(new /spell/contract/return_master(user), "const_spell_ready")
		log_and_message_admins("signed their soul over to \the [contract_master] using \the [src].", user)
		user.drop_from_inventory(src)
		qdel(src)

/obj/item/weapon/contract/proc/contract_effect(mob/user as mob)
	user << "<span class='warning'>You've signed your soul over to \the [contract_master] and with that your unbreakable vow of servitude begins.</span>"
	return 1

/obj/item/weapon/contract/apprentice
	name = "apprentice wizarding contract"

/obj/item/weapon/contract/apprentice/contract_effect(mob/user as mob)
	if(wizards.add_antagonist_mind(user.mind,1,"apprentice","<b>You are an apprentice! Your job is to learn the wizarding arts!</b>"))
		user << "<span class='notice'>With the signing of this paper you agree to become \the [contract_master]'s apprentice in the art of wizardry.</span>"
		return 1
	return 0


/obj/item/weapon/contract/wizard //contracts that involve making a deal with the Wizard Acadamy (or NON PLAYERS)
	contract_master = "\improper Wizard Academy"

/obj/item/weapon/contract/wizard/xray
	name = "xray vision contract"
	desc = "This contract is almost see-through..."

/obj/item/weapon/contract/wizard/xray/contract_effect(mob/user as mob)
	..()
	if (!(XRAY in user.mutations))
		user.mutations.Add(XRAY)
		user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
		user.see_in_dark = 8
		user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
		user << "<span class='notice'>The walls suddenly disappear.</span>"
		return 1
	return 0

/mob/item/weapon/contract/wizard/tk
	name = "telekinesis contract"
	desc = "This contract makes your mind buzz."

/obj/item/weapon/contract/wizard/tk/contract_effect(mob/user as mob)
	..()
	if(!(TK in user.mutations))
		user.mutations.Add(TK)
		user << "<span class='notice'>You feel your mind expanding!</span>"
		return 1
	return 0

/obj/item/weapon/contract/boon
	name = "boon contract"
	desc = "this contract grants you a boon for signing it."
	var/path
	var/item_name

/obj/item/weapon/contract/boon/New(var/newloc,var/new_name, var/new_path)
	..(newloc)
	if(new_path)
		path = new_path
	if(new_name)
		item_name = new_name
	name = "[item_name] contract"

/obj/item/weapon/contract/boon/contract_effect(mob/user as mob)
	..()
	if(ispath(path,/spell))
		user.add_spell(new path)
		return 1
	if(ispath(path,/obj))
		new path(get_turf(user.loc))
		flick("e_flash", usr.flash)
		return 1

/obj/item/weapon/contract/boon/wizard
	contract_master = "\improper Wizard Academy"

/obj/item/weapon/contract/boon/wizard/artificer
	item_name = "artificing"
	path = /spell/aoe_turf/conjure/construct
	desc = "This contract has a passage dedicated to an entity known as 'Nar-Sie'"

/obj/item/weapon/contract/boon/wizard/fireball
	path = /spell/targeted/projectile/dumbfire/fireball
	item_name = "fireball"
	desc = "This contract feels warm to the touch."

/obj/item/weapon/contract/boon/wizard/smoke
	path = /spell/aoe_turf/smoke
	item_name = "smoke"
	desc = "This contract smells as dank as they come."

/obj/item/weapon/contract/boon/wizard/mindswap
	path = /spell/targeted/mind_transfer
	item_name = "mindswap"
	desc = "This contract looks ragged and torn."

/obj/item/weapon/contract/boon/wizard/forcewall
	path = /spell/aoe_turf/conjure/forcewall
	item_name = "forcewall"
	contract_master = "\improper Mime Federation"
	desc = "This contract has a dedication to mimes everywhere at the top."

/obj/item/weapon/contract/boon/wizard/knock
	path = /spell/aoe_turf/knock
	item_name = "knock"
	desc = "This contract is hard to hold still."

/obj/item/weapon/contract/boon/wizard/horsemask
	path = /spell/targeted/equip_item/horsemask
	item_name = "horses"
	desc = "This contract is more horse than your mind has room for."

/obj/item/weapon/contract/boon/wizard/charge
	path = /spell/aoe_turf/charge
	item_name = "charging"
	desc = "This contract is made of 100% post-consumer wizard."

