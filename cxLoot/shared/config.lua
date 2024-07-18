LootSettings = { 
    useLegacy = true, -- si vous utilisez la version legacy, mettez sur true
    waitingDuration = 2, -- temps d'attente entre chaque largages (en minutes)
    useWeaponItem = true, -- si vous avez les armes avec /giveitem, mettez sur true 
    randomLoot = { -- loot aléatoire des caisses (si useWeaponItem = true, mettre weaponName = nil, et item avec l'item en question, inversement si useWeaponItem = false)
        {weaponName = nil, item = "weapon_pistol", count = 1}, 
        {weaponName = nil, item = "money", count = 5000}, 
    },
    eventZones = { -- zones de largages
        vector3(850.888671875,1276.5509033203,359.61773681641),
        vector3(0.0, 0.0, 0.0),
    },
    blips = { -- configuration du blips du loot 
        name = "Cargaison d'armes",
        sprite = 408,
        scale = 0.7,
        colour = 1
    },
    message = {
        title = "Mission",
        subtitle = "~r~Cargaison~s~",
        announcement = "Une cargaison a été lachée dans la ville, vas-y vite avant que quelqu'un prenne de l'avance !",
        defeat = "La cargaison a été récupéré par quelqu'un, chope la prochaine !",
        char = "CHAR_MP_JULIO"
    }
}