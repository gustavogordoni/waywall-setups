local waywall = require("waywall")
local requests = require("waywall_ninbot_overlay.requests")
local json = require("waywall_ninbot_overlay.dkjson")

local NB_OVERLAY = {}

local data_sh = nil
local data_blind = nil
local data_boat = nil

local text_handle = nil
local text_handle_bold = nil

local SCREEN_W = 1920

local look = {
    Y = 10,
    color = '#000000',
    bold = false,
    size = 2
}

-- Estimativa de largura de um caractere em pixels para o size=2
-- waywall usa fonte monospace ~8px por char no size=1, logo size=2 = ~16px/char
local CHAR_W = 8 * look.size

local nb_background_path = os.getenv("HOME") .. "/.config/waywall/waywall_ninbot_overlay/nb_background.png"

local make_image = function(path, dst)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.image(path, dst)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

-- backgrounds serão recriados dinamicamente com x centralizado
local full_background_toggle = nil
local partial_background_toggle = nil

local function make_centered_backgrounds(text_len)
    local w = 1 + text_len * CHAR_W
    local cx = math.floor((SCREEN_W - w) / 2)

    if full_background_toggle then full_background_toggle(false) end
    if partial_background_toggle then partial_background_toggle(false) end

    full_background_toggle = make_image(nb_background_path, {
        dst = { x = cx, y = look.Y, w = w, h = 1 + 1 * 16 * look.size },
    })
    partial_background_toggle = make_image(nb_background_path, {
        dst = { x = cx, y = look.Y, w = w, h = 1 + 1 * 16 * look.size },
    })
end

function set_full_background(toggle_func)
    full_background_toggle = toggle_func
end

function set_partial_background(toggle_func)
    partial_background_toggle = toggle_func
end

local function angle_to_destination(x_pos, z_pos, x_dest, z_dest)
    local dx = x_dest - x_pos
    local dz = z_dest - z_pos
    local angle_rad = math.atan2(-dx, dz)
    local angle_deg = math.deg(angle_rad)
    if angle_deg > 180 then
        angle_deg = angle_deg - 360
    elseif angle_deg < -180 then
        angle_deg = angle_deg + 360
    end
    return angle_deg
end

local function getarrow(player_angle, target_angle)
    local diff = target_angle - player_angle
    if diff > 180 then diff = diff - 360 end
    if diff < -180 then diff = diff + 360 end

    if diff > 3 then
        return "->"
    elseif diff < -3 then
        return "<-"
    else
        return "--"
    end
end

local function nb_mode()
    if not data_sh or not data_sh.playerPosition then
        return "NB Ready"
    elseif data_sh.resultType == "BLIND" then
        return "Blinding"
    elseif data_sh.predictions and data_sh.predictions[1] and data_sh.predictions[1].certainty >= 0.95 then
        return "Nether Travel"
    else
        return "Measuring"
    end
end

local function boat_status()
    if not data_boat or not data_boat.boatState then
        return "Error"
    elseif data_boat.boatState == "MEASURING" or data_boat.boatState == "ERROR" then
        return "Not Ready"
    elseif data_boat.boatState == "VALID" then
        return "Ready"
    else
        return "Error"
    end
end

local function update_overlay()
    if text_handle then
        text_handle:close()
        text_handle = nil
    end

    if text_handle_bold then
        text_handle_bold:close()
        text_handle_bold = nil
    end

    if nb_mode() == "NB Ready" then
        if full_background_toggle then full_background_toggle(false) end
        if partial_background_toggle then partial_background_toggle(false) end
        return
    end

    local player = data_sh.playerPosition or {
        xInOverworld = 0,
        zInOverworld = 0,
        horizontalAngle = 0
    }

    local sh = data_sh.predictions and data_sh.predictions[1] or {
        chunkX = 0,
        chunkZ = 0,
        overworldDistance = 0
    }

    local layout = nb_mode()

    if nb_mode() == "Measuring" then
        if data_sh.predictions and data_sh.predictions[1] and data_sh.predictions[1].certainty then
            local cert = math.floor(data_sh.predictions[1].certainty * 100)
            layout = nb_mode() .. " " .. cert .. "%"
        end
    end

    if nb_mode() == "Nether Travel" then
        local sh_x, sh_z, distance
        local px, pz

        if player.isInOverworld then
            sh_x = math.floor(16 * (sh.chunkX or 0) + 4)
            sh_z = math.floor(16 * (sh.chunkZ or 0) + 4)
            px = player.xInOverworld
            pz = player.zInOverworld
            distance = math.floor(sh.overworldDistance or 0)
        elseif player.isInNether then
            sh_x = math.floor(2 * (sh.chunkX or 0))
            sh_z = math.floor(2 * (sh.chunkZ or 0))
            px = player.xInOverworld / 8
            pz = player.zInOverworld / 8
            distance = math.floor((sh.overworldDistance or 0) / 8)
        end

        local angle = angle_to_destination(px, pz, sh_x, sh_z)
        local diff = angle - player.horizontalAngle
        if diff > 180 then diff = diff - 360 end
        if diff < -180 then diff = diff + 360 end

        local arrow = getarrow(player.horizontalAngle, angle)
        local deg = math.floor(math.abs(diff))

        -- formato: (188,-6) | 215 | <- -118
        layout = "(" .. sh_x .. "," .. sh_z .. ") | " .. distance .. " | " .. arrow .. " " .. deg
    end

    -- centraliza o texto
    local text_len = #layout
    local cx = math.floor((SCREEN_W - text_len * CHAR_W) / 2)

    make_centered_backgrounds(text_len)

    if nb_mode() == "Nether Travel" then
        full_background_toggle(true)
        partial_background_toggle(false)
    else
        full_background_toggle(false)
        partial_background_toggle(true)
    end

    local state = waywall.state()
    if state and state.screen == "inworld" then
        text_handle = waywall.text(layout, { x = cx, y = look.Y, color = look.color, size = look.size })
        if look.bold then
            text_handle_bold = waywall.text(layout, { x = cx + 1, y = look.Y, color = look.color, size = look.size })
        end
    end
end

NB_OVERLAY.trigger_http_send = function()
    local sh = requests.get("http://localhost:52533/api/v1/stronghold")
    local blind = requests.get("http://localhost:52533/api/v1/blind")
    local boat = requests.get("http://localhost:52533/api/v1/boat")

    local ok1, sh_tbl = pcall(sh.json)
    local ok2, blind_tbl = pcall(blind.json)
    local ok3, boat_tbl = pcall(boat.json)

    data_sh = ok1 and sh_tbl or nil
    data_blind = ok2 and blind_tbl or nil
    data_boat = ok3 and boat_tbl or nil

    update_overlay()
end

NB_OVERLAY.enable_overlay = function()
    NB_OVERLAY.trigger_http_send()
end

NB_OVERLAY.disable_overlay = function()
    if text_handle then
        text_handle:close(); text_handle = nil
    end
    if text_handle_bold then
        text_handle_bold:close(); text_handle_bold = nil
    end
    if full_background_toggle then
        full_background_toggle(false)
    end
    if partial_background_toggle then
        partial_background_toggle(false)
    end
end

return NB_OVERLAY