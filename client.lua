local config = {
    minimapCenterX = 0.12, -- Minimap center X on screen
    minimapTopY = 0.88,    -- Minimap top Y coordinate

    plateVinBoxOffsetX = -0.035, -- Offset left from minimap center for Plate|VIN box
    plateVinBoxOffsetY = -0.12,  -- Offset up from minimap top for Plate|VIN box

    plateVinBgWidth = 0.14,  -- Width of background box behind Plate|VIN
    plateVinBgHeight = 0.029, -- Height of background box behind Plate|VIN

    plateVinTextOffsetY = -0.014, -- Vertical text offset to center in box

    speedOffsetX = 0.10,         -- Speed display X offset from minimap center
    speedLabelOffsetY = -0.02,   -- Speed label Y offset
    speedValueOffsetY = 0.015,   -- Speed value Y offset

    fuelLabelOffsetY = 0.057,    -- Fuel label Y offset
    fuelBarOffsetY = 0.07,       -- Fuel bar Y offset
    fuelBarWidth = 0.08,         -- Fuel bar width
    fuelBarHeight = 0.015,       -- Fuel bar height

    defaultUseKmh = false,       -- Default speed unit (false = MPH, true = KMH)
}

local vinList = {}
local vinMap = {}
local randomSeeded = false
local useKmh = config.defaultUseKmh

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        local file = LoadResourceFile(GetCurrentResourceName(), "vin.json")
        if file then
            vinList = json.decode(file)
            print("Loaded VIN list with " .. tostring(#vinList) .. " entries.")
        else
            print("Failed to load vin.json!")
        end
    end
end)

local function getVIN(vehicle)
    if not vinList or #vinList == 0 then return "UNKNOWN" end
    if vinMap[vehicle] then return vinMap[vehicle] end

    if not randomSeeded then
        math.randomseed(GetGameTimer()) -- Seed randomness once
        randomSeeded = true
    end
    local randomIndex = math.random(1, #vinList)
    vinMap[vehicle] = vinList[randomIndex]
    return vinMap[vehicle]
end

local function drawText(text, x, y, scale, font, color, center)
    SetTextFont(font or 0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextCentre(center or false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

-- Draw rectangle helper
local function drawRect(x, y, width, height, color)
    DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function getSpeed(vehicle)
    local speed = GetEntitySpeed(vehicle) -- speed in m/s
    if useKmh then
        return math.floor(speed * 3.6 + 0.5), "KMH"
    else
        return math.floor(speed * 2.23694 + 0.5), "MPH"
    end
end

local function getFuelLevel(vehicle)
    local fuel = GetVehicleFuelLevel(vehicle)
    if fuel > 100 then fuel = 100 end
    if fuel < 0 then fuel = 0 end
    return fuel / 100
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 311) then
            useKmh = not useKmh
            local msg = useKmh and "^2Speed unit set to KMH" or "^2Speed unit set to MPH"
            TriggerEvent('chat:addMessage', { args = { msg } })
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if vehicle and vehicle ~= 0 then
                local plate = GetVehicleNumberPlateText(vehicle)
                local vin = getVIN(vehicle)
                local speed, unit = getSpeed(vehicle)
                local fuelLevel = getFuelLevel(vehicle)

                local boxX = config.minimapCenterX + config.plateVinBoxOffsetX
                local boxY = config.minimapTopY + config.plateVinBoxOffsetY
                local textX = boxX
                local textY = boxY + config.plateVinTextOffsetY

                local text = string.format("PLATE: %s   |   VIN: %s", plate, vin)

                -- Draw background box
                drawRect(boxX, boxY, config.plateVinBgWidth, config.plateVinBgHeight, { r=50, g=50, b=50, a=180 })
                -- Draw Plate and VIN text
                drawText(text, textX, textY, 0.40, 4, { r=255, g=255, b=255, a=230 }, true)

                local speedX = config.minimapCenterX + config.speedOffsetX
                drawText("SPEED ("..unit..")", speedX, config.minimapTopY + config.speedLabelOffsetY, 0.32, 0, { r=200, g=200, b=200, a=230 }, true)
                drawText(tostring(speed), speedX, config.minimapTopY + config.speedValueOffsetY, 0.7, 4, { r=255, g=255, b=255, a=230 }, true)

                drawText("FUEL", speedX, config.minimapTopY + config.fuelLabelOffsetY, 0.32, 0, { r=200, g=200, b=200, a=230 }, true)
                drawRect(speedX, config.minimapTopY + config.fuelBarOffsetY, config.fuelBarWidth, config.fuelBarHeight, { r=50, g=50, b=50, a=180 })

                local fillWidth = config.fuelBarWidth * fuelLevel
                local fillColor = { r=0, g=200, b=0, a=220 }
                if fuelLevel < 0.3 then
                    fillColor = { r=200, g=0, b=0, a=220 }
                elseif fuelLevel < 0.6 then
                    fillColor = { r=200, g=200, b=0, a=220 }
                end
                drawRect(speedX - config.fuelBarWidth/2 + fillWidth/2, config.minimapTopY + config.fuelBarOffsetY, fillWidth, config.fuelBarHeight, fillColor)
            end
        end
    end
end)
