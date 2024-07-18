local propsBox, parachute, pickup, pickupBlip, soundID

function getRandomLoot()
    local random = math.random(1, #LootSettings.randomLoot)
    return LootSettings.randomLoot[random]
end

RegisterNetEvent("cxLoot:create")
AddEventHandler("cxLoot:create", function(dropCoords)
    local requirements = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood02a_pu"}
    CreateThread(function()
        if DoesEntityExist(parachute) then 
            DeleteEntity(parachute)
        end
        if DoesEntityExist(propsBox) then 
            DeleteEntity(propsBox)
        end
        if DoesEntityExist(pickup) then 
            DeleteEntity(pickup)
            RemovePickup(pickup)
        end
        RemoveBlip(pickupBlip)
        StopSound(soundID)
        ReleaseSoundId(soundID)
        for i = 1, #requirements do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requirements[i]))
        end
        propsBox, parachute, pickup, pickupBlip, soundID = nil, nil, nil, nil, nil 
        for i = 1, #requirements do
            RequestModel(GetHashKey(requirements[i]))
            while not HasModelLoaded(GetHashKey(requirements[i])) do
                Wait(0)
            end
        end
        RequestWeaponAsset(GetHashKey("weapon_flare")) 
        while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
            Wait(0)
        end
        local crateSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z+20.0) 
        propsBox = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true) 
        SetEntityLodDist(propsBox, 10000) 
        ActivatePhysics(propsBox)
        SetDamping(propsBox, 2, 0.1) 
        SetEntityVelocity(propsBox, 0.0, 0.0, -0.2) 
        SetEntityInvincible(propsBox, true)
        parachute = CreateObject(GetHashKey("p_cargo_chute_s"), crateSpawn, true, true, true) 
        SetEntityLodDist(parachute, 10000)
        SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
        SetEntityInvincible(parachute, true)
        if LootSettings.useWeaponItem then 
            pickup = CreateAmbientPickup(GetHashKey("pickup_weapon_smokegrenade"), crateSpawn, 0, 1, GetHashKey("ex_prop_adv_case_sm"), true, true)
        else
            pickup = CreateAmbientPickup(GetHashKey("pickup_"..getRandomLoot().weaponName:lower()), crateSpawn, 0, 45, GetHashKey("ex_prop_adv_case_sm"), true, true)
        end
        ActivatePhysics(pickup)
        SetDamping(pickup, 2, 0.0245)
        SetEntityVelocity(pickup, 0.0, 0.0, -0.2)
        SetEntityInvincible(pickup, true)
        soundID = GetSoundId()
        PlaySoundFromEntity(soundID, "Crate_Beeps", pickup, "MP_CRATE_DROP_SOUNDS", true, 0)
        pickupBlip = AddBlipForEntity(pickup)
        SetBlipSprite(pickupBlip, LootSettings.blips.sprite) 
        SetBlipScale(pickupBlip, LootSettings.blips.scale)
        SetBlipColour(pickupBlip, LootSettings.blips.colour)
        SetBlipAlpha(pickupBlip, 120)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(LootSettings.blips.name)
        EndTextCommandSetBlipName(pickupBlip)
        AttachEntityToEntity(parachute, pickup, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true) 
        AttachEntityToEntity(pickup, propsBox, 0, 0.0, 0.0, 0.3, 0.0, 0.0, 0.0, false, false, true, false, 2, true) 
        FreezeEntityPosition(propsBox, false)
        while HasObjectBeenBroken(propsBox) == false do 
            Wait(0)
        end
        local parachuteCoords = vector3(GetEntityCoords(parachute))
        ShootSingleBulletBetweenCoords(parachuteCoords, parachuteCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0) 
        DetachEntity(parachute, true, true)
        DeleteEntity(parachute)
        DetachEntity(pickup)
        SetBlipAlpha(pickupBlip, 255)
        while DoesEntityExist(pickup) do 
            Wait(0)
        end
        TriggerServerEvent("cxLoot:rewards", getRandomLoot().item) 
        while DoesObjectOfTypeExistAtCoords(parachuteCoords, 10.0, GetHashKey("w_am_flare"), true) do
            Wait(0)
            local prop = GetClosestObjectOfType(parachuteCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
            RemoveParticleFxFromEntity(prop)
            SetEntityAsMissionEntity(prop, true, true)
            DeleteObject(prop)
        end
        if DoesBlipExist(pickupBlip) then 
            RemoveBlip(pickupBlip)
        end
        StopSound(soundID) 
        ReleaseSoundId(soundID) 
        for i = 1, #requirements do
            Wait(0)
            SetModelAsNoLongerNeeded(GetHashKey(requirements[i]))
        end
        RemoveWeaponAsset(GetHashKey("weapon_flare"))
    end)
end)

RegisterNetEvent("cxLoot:reset")
AddEventHandler("cxLoot:reset", function()
    local requirements = {"p_cargo_chute_s", "ex_prop_adv_case_sm", "prop_box_wood02a_pu"}
    if DoesEntityExist(parachute) then 
        DeleteEntity(parachute)
    end
    if DoesEntityExist(propsBox) then 
        DeleteEntity(propsBox)
    end
    if DoesEntityExist(pickup) then 
        DeleteEntity(pickup)
        RemovePickup(pickup)
    end
    RemoveBlip(pickupBlip)
    StopSound(soundID)
    ReleaseSoundId(soundID)
    for i = 1, #requirements do
        Wait(0)
        SetModelAsNoLongerNeeded(GetHashKey(requirements[i]))
    end
    propsBox, parachute, pickup, pickupBlip, soundID = nil, nil, nil, nil, nil 
end)