-- PVM Simple Configuration
-- Mod settings and slider values

local config = {
    -- Enabled state
    enabled = true,
    
    -- Viewmodel position adjustments (in units)
    position = {
        x = 0,      -- Left/Right adjustment (-100 to 100)
        y = 0,      -- Up/Down adjustment (-100 to 100)
        z = 0       -- Forward/Backward adjustment (-100 to 100)
    },
    
    -- Viewmodel rotation adjustments (in degrees)
    rotation = {
        pitch = 0,  -- X-axis rotation (-180 to 180)
        yaw = 0,    -- Y-axis rotation (-180 to 180)
        roll = 0    -- Z-axis rotation (-180 to 180)
    }
}

-- Function to update configuration from slider values
function config.updateFromSliders(sliders)
    if sliders.position_x then config.position.x = sliders.position_x end
    if sliders.position_y then config.position.y = sliders.position_y end
    if sliders.position_z then config.position.z = sliders.position_z end
    if sliders.rotation_pitch then config.rotation.pitch = sliders.rotation_pitch end
    if sliders.rotation_yaw then config.rotation.yaw = sliders.rotation_yaw end
    if sliders.rotation_roll then config.rotation.roll = sliders.rotation_roll end
end

-- Function to get all current settings as a table
function config.getSettings()
    return {
        enabled = config.enabled,
        position = config.position,
        rotation = config.rotation
    }
end

-- Function to reset all settings to defaults
function config.reset()
    config.position = { x = 0, y = 0, z = 0 }
    config.rotation = { pitch = 0, yaw = 0, roll = 0 }
    print("[PVM Simple] Configuration reset to defaults")
end

return config