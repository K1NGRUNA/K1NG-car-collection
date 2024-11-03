local QBCore = exports['qb-core']:GetCoreObject()
local spawnedVehicles = {}
local isAnimating = false

local function LoadModel(model)
    local hash = GetHashKey(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
    return hash
end

local function SetupVehicle(vehicle, config)
    -- Basic vehicle setup
    SetEntityInvincible(vehicle, true)
    SetVehicleDoorsLocked(vehicle, 2)
    SetVehicleEngineOn(vehicle, false, true, false)
    
    -- Disable interactions
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)
    SetVehicleCanBeUsedByFleeingPeds(vehicle, false)
    SetVehicleCanBeVisiblyDamaged(vehicle, false)
    SetVehicleCanBreak(vehicle, false)
    SetVehicleUndriveable(vehicle, true)
    
    -- Apply colors
    SetVehicleCustomPrimaryColour(vehicle, config.colors.primary.r, config.colors.primary.g, config.colors.primary.b)
    SetVehicleCustomSecondaryColour(vehicle, config.colors.secondary.r, config.colors.secondary.g, config.colors.secondary.b)
    
    -- Apply extras
    if config.extras.neonEnabled then
        for i = 0, 3 do
            SetVehicleNeonLightEnabled(vehicle, i, config.extras.neonEnabled[i+1])
        end
        SetVehicleNeonLightsColour(vehicle, config.extras.neonColor.r, config.extras.neonColor.g, config.extras.neonColor.b)
    end
    
    SetVehicleXenonLightsColour(vehicle, config.extras.xenonColor)
    SetVehicleWindowTint(vehicle, config.extras.windowTint)
    SetVehicleWheelType(vehicle, config.extras.wheelColor)
end

local function AnimateVehicle(vehicle, startCoords, endCoords)
    isAnimating = true
    
    -- Calculate path
    local startPos = vector3(startCoords.x, startCoords.y, startCoords.z)
    local endPos = vector3(endCoords.x, endCoords.y, endCoords.z)
    local heading = endCoords.w
    
    -- Drive to position
    TaskVehicleDriveToCoord(GetPedInVehicleSeat(vehicle, -1), vehicle, endPos.x, endPos.y, endPos.z, 
        Config.DriveInSpeed, 0, GetEntityModel(vehicle), 786603, 1.0, true)
    
    -- Wait for arrival
    while #(GetEntityCoords(vehicle) - endPos) > 0.5 do
        Wait(100)
    end
    
    -- Park vehicle
    SetEntityCoordsNoOffset(vehicle, endPos.x, endPos.y, endPos.z, false, false, false)
    SetEntityHeading(vehicle, heading)
    FreezeEntityPosition(vehicle, true)
    isAnimating = false
end

local function CreateDisplayVehicle(config)
    if isAnimating then return end
    
    local hash = LoadModel(config.model)
    local vehicle = CreateVehicle(hash, config.spawnPoint.x, config.spawnPoint.y, config.spawnPoint.z, config.spawnPoint.w, false, false)
    
    -- Create driver ped
    local driverHash = GetHashKey('a_m_y_business_01')
    RequestModel(driverHash)
    while not HasModelLoaded(driverHash) do Wait(0) end
    
    local driver = CreatePed(26, driverHash, config.spawnPoint.x, config.spawnPoint.y, config.spawnPoint.z, config.spawnPoint.w, false, true)
    SetPedIntoVehicle(driver, vehicle, -1)
    SetEntityInvincible(driver, true)
    SetBlockingOfNonTemporaryEvents(driver, true)
    
    SetupVehicle(vehicle, config)
    AnimateVehicle(vehicle, config.spawnPoint, config.parkingSpot)
    
    -- Delete driver after animation
    CreateThread(function()
        Wait(5000)
        DeleteEntity(driver)
    end)
    
    return vehicle
end

local function ManageVehicleVisibility()
    local playerPed = PlayerPedId()
    
    while true do
        local playerCoords = GetEntityCoords(playerPed)
        
        for i, displayConfig in ipairs(Config.VIPDisplays) do
            local distance = #(playerCoords - vector3(displayConfig.parkingSpot.x, displayConfig.parkingSpot.y, displayConfig.parkingSpot.z))
            
            if distance <= Config.RenderDistance then
                if not spawnedVehicles[i] or not DoesEntityExist(spawnedVehicles[i]) then
                    spawnedVehicles[i] = CreateDisplayVehicle(displayConfig)
                end
            else
                if spawnedVehicles[i] and DoesEntityExist(spawnedVehicles[i]) then
                    DeleteEntity(spawnedVehicles[i])
                    spawnedVehicles[i] = nil
                end
            end
        end
        
        Wait(1000)
    end
end

-- Key press handler
CreateThread(function()
    while Config.UseKeyPress do
        Wait(0)
        if IsControlJustPressed(0, Config.TriggerKey) then -- 'E' key
            local playerCoords = GetEntityCoords(PlayerPedId())
            
            for i, displayConfig in ipairs(Config.VIPDisplays) do
                local distance = #(playerCoords - vector3(displayConfig.parkingSpot.x, displayConfig.parkingSpot.y, displayConfig.parkingSpot.z))
                
                if distance <= 3.0 and not isAnimating then
                    if spawnedVehicles[i] and DoesEntityExist(spawnedVehicles[i]) then
                        DeleteEntity(spawnedVehicles[i])
                        spawnedVehicles[i] = nil
                    end
                    spawnedVehicles[i] = CreateDisplayVehicle(displayConfig)
                    break
                end
            end
        end
    end
end)

-- Initialize
CreateThread(ManageVehicleVisibility)