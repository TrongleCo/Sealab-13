/datum/trader/ship/unique
	trade_flags = TRADER_WANTED_ONLY|TRADER_GOODS
	want_multiplier = 5

/datum/trader/ship/unique/severance
	name = "Unknown"
	origin = "SGS Severance"

	possible_wanted_items = list(
							/obj/item/weapon/reagent_containers/food/snacks/human                      = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/reagent_containers/food/snacks/meat/human                 = TRADER_THIS_TYPE,
							/mob/living/carbon/human                                                   = TRADER_ALL
							)

	possible_trading_items = list(/obj/mecha/combat                                                    = TRADER_SUBTYPES_ONLY,
							/obj/item/weapon/gun/projectile/automatic                                  = TRADER_SUBTYPES_ONLY
							)

	blacklisted_trade_items = null

	speech = list("hail_generic"     = "H-hello. Can you hear me? G-good... I have... specific needs... I have a lot to t-trade with you in return of course.",
				"hail_deny"          = "--CONNECTION SEVERED--",

				"trade_complete"     = "Hahahahahahaha! Thankyouthankyouthankyou!",
				"trade_refuse"       = "No! T-that isn't even close... I want more...",
				"how_much"           = "Meat. I want meat. The kind they don't serve i-in teh mess hall.",

				"compliment_deny"    = "Your lies won't c-change what I did.",
				"compliment_accept"  = "Yes... I suppose you're right.",
				"insult_good"        = "I... probably deserve that.",
				"insult_bad"         = "Maybe you should c-come here and say that. You'd be worth s-something then.",
				)
	mob_transfer_message = "<span class='danger'>You are transported to ORIGIN, and with a sickening thud, you fall unconscious, never to wake again.</span>"


/datum/trader/ship/unique/rock
	name = "Bobo"
	origin = "Floating Rock"

	possible_wanted_items  = list(/obj/item/weapon/ore                        = TRADER_ALL)
	possible_trading_items = list(/obj/machinery/power/supermatter            = TRADER_ALL,
								/obj/item/weapon/aiModule                     = TRADER_SUBTYPES_ONLY)
	want_multiplier = 5000

	speech = list("hail_generic"     = "Blub am MERCHANT. Blub hunger for things. Boo bring them to blub, yes?",
				"hail_deny"          = "Blub does not want to speak to boo.",

				"trade_complete"     = "Blub likes to trade!",
				"trade_refuse"       = "No, Blub will not do that. Blub wants bocks, yes? Give bocks.",
				"how_much"           = "Blub wants bocks. Boo give bocks. Blub gives stuff blub found.",

				"compliment_deny"    = "Blub is just MERCHANT. What do boo mean?",
				"compliment_accept"  = "Boo are a bood berson!",
				"insult_good"        = "Blub do not understand. Blub thought we were briends.",
				"insult_bad"         = "Blub feels bad now.",
				)

//probably could stick soem Howl references in here but like, eh. Haven't seen it in years.
/datum/trader/ship/unique/wizard
	name = "Wizard"
	origin = "A Moving Castle"
	name_language = TRADER_DEFAULT_NAME

	possible_wanted_items = list(/mob/living/simple_animal/construct            = TRADER_SUBTYPES_ONLY,
								/obj/item/weapon/melee/cultblade                = TRADER_THIS_TYPE,
								/obj/item/clothing/head/culthood                = TRADER_ALL,
								/obj/item/clothing/suit/space/cult              = TRADER_ALL,
								/obj/item/clothing/suit/cultrobes               = TRADER_ALL,
								/obj/item/clothing/head/helmet/space/cult       = TRADER_ALL,
								/obj/structure/cult                             = TRADER_SUBTYPES_ONLY,
								/obj/structure/constructshell                   = TRADER_ALL,
								/mob/living/simple_animal/familiar              = TRADER_SUBTYPES_ONLY,
								/mob/living/simple_animal/familiar/pet          = TRADER_BLACKLIST,
								/mob/living/simple_animal/hostile/mimic         = TRADER_ALL)

	possible_trading_items = list(/obj/item/clothing/gloves/purple/wizard        = TRADER_THIS_TYPE,
								/obj/item/clothing/head/helmet/space/void/wizard = TRADER_THIS_TYPE,
								/obj/item/clothing/head/wizard                   = TRADER_ALL,
								/obj/item/clothing/suit/space/void/wizard        = TRADER_THIS_TYPE,
								/obj/item/toy/figure/wizard                      = TRADER_THIS_TYPE,
								/obj/item/weapon/staff                           = TRADER_ALL
								) //Probably see about getting some more wizard based shit

	speech = list("hail_generic"     = "Hello! Are you here on pleasure or business?",
				"hail_Golem"         = "Interesting... how incredibly interesting.... come! Let us do business!",
				"hail_deny"          = "I'm sorry, but I REALLY don't want to speak to you.",

				"trade_complete"     = "Pleasure doing business with you! Just don't feed it after midnight!",
				"trade_refuse"       = "See, thats not what I want. I thought you knew better.",
				"how_much"           = "I want dark things, brooding things... things that go bump in the night. Things that bleed wrong, live wrong, are wrong.",

				"compliment_deny"    = "Like I haven't heard that one before!",
				"compliment_accept"  = "Haha! Aren't you nice.",
				"insult_good"        = "Naughty naughty.",
				"insult_bad"         = "Now where do you get off talking to me like that?",
				)