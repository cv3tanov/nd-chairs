Config = {}
Config.Target = true   -- LEAVE THIS ENABLED IF USING TARGET

Config.Locations =  {
	[1] = { location = vector3(-39.55, 6471.5, 31.5-1.03), heading = 45.78, store = "Store1", },
}

Config.PedList = {
	{ model = "S_M_Y_Construct_01", coords = Config.Locations[1].location, heading = Config.Locations[1].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", },
}

--PRICES ARE ALL "0" CHANGE THEM IF YOU WANT TO CHARGE FOR THEM
Config.Store1 = {
    label = "Магазин за външни столове",
    slots = 3,
    items = {
        [1] = { name = "chair1", price = 500, amount = 50, info = {}, type = "item", slot = 1, },
        [2] = { name = "chair2", price = 500, amount = 50, info = {}, type = "item", slot = 2, },
        [3] = { name = "chair3", price = 500, amount = 50, info = {}, type = "item", slot = 3, },

    }
}
