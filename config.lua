Config = {}

Config = {

	Positions = {
		{x = 2557.18,  y = 382.4,    z = 108.62},
		{x = -3039.46, y = 585.99,   z = 7.91},
		{x = -3242.34, y = 1001.7,   z = 12.83},
		{x = 547.44,   y = 2671.2,   z = 42.16},
		{x = 1961.43,  y = 3740.94,  z = 32.34},
		{x = 2678.9,   y = 3280.68,  z = 55.24},
		{x = 1729.34,  y = 6414.49,  z = 35.04},
		{x = 25.95,    y = -1345.46, z = 29.5},
		{x = 1136.14,  y = -982.3,   z = 46.42},
		{x = -1223.19, y = -907.07,  z = 12.33},
		{x = -1487.2,  y = -379.53,  z = 40.16},
		{x = -2968.16, y = 390.43,   z = 15.04},
		{x = 1166.02,  y = 2708.99,  z = 38.16},
		{x = 1392.42,  y = 3604.59,  z = 34.98},
		{x = -48.5,    y = -1757.58, z = 29.42},
		{x = 1163.26,  y = -324.1,   z = 69.21},
		{x = -707.67,  y = -914.72,  z = 19.22},
		{x = -1820.71, y = 792.42,   z = 138.12},
		{x = 1698.44,  y = 4924.65,  z = 42.06},
		{x = 374.07,  y = 326.05,  z = 103.56}
	},

	NPC = {
		{position = vec3(-1019.38, -993.00, 2.15), heading = 209.08, typePed = "s_m_y_dealer_01"}
	},

	Items = {
		{Label = "Exemple Item 1", Model = "bread", Prix = 50},
		{Label = "Exemple Item 2", Model = "water", Prix = 75}
	}

}

Config.Shopkeeper = 416176080
Config.Locale = 'fr'

Config.Shops = {
	-- Los Santos
    {coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
	{coords = vector3(-1486.28, -377.96, 40.16-0.98), heading = 138.96, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
	{coords = vector3(-1221.88, -908.36, 12.32-0.98), heading = 31.70, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
	{coords = vector3(-46.69, -1758.08, 29.42-0.98), heading = 53.56, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
	{coords = vector3(1134.06, -982.55, 46.41-0.98), heading = 274.57, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
	{coords = vector3(1164.76, -322.69, 69.20-0.98), heading = 97.06, money = {8500, 13000}, cops = 3, blip = true, name = '7/11', cooldown = {hour = 0, minute = 30, second = 0}, robbed = false},
}

Translation = {
    ['fr'] = {
        ['shopkeeper'] = '~r~Ma caisse',
        ['robbed'] = "~r~est vide.",
        ['cashrecieved'] = 'Vous avez volé',
        ['currency'] = '$',
        ['scared'] = 'Effreyée',
        ['no_cops'] = "Pour braquer il faut minimum 3 policiers.",
        ['cop_msg'] = 'Nous vous avons envoyé une photo du voleur prise par la caméra de surveillance.',
        ['set_waypoint'] = 'Définir un point vers le magasin.',
        ['hide_box'] = 'Fermer cette case.',
        ['robbery'] = 'Braquage en cours..',
        ['walked_too_far'] = 'Vous vous êtes trop éloignez.'
    }
}