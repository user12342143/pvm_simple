-- Viewmodel Module
-- Handles camera offset and viewmodel positioning for Payday 2
-- Provides functions to apply position/rotation offsets and manage camera system hooks

local ViewmodelModule = {}

-- Default settings for viewmodel positioning
local DefaultSettings = {
	position_offset = {
		x = 0,
		y = 0,
		z = 0
	},
	rotation_offset = {
		x = 0,
		y = 0,
		z = 0
	},
	fov_offset = 0,
	enabled = true
}

-- Current settings (starts as copy of defaults)
local CurrentSettings = {
	position_offset = {
		x = DefaultSettings.position_offset.x,
		y = DefaultSettings.position_offset.y,
		z = DefaultSettings.position_offset.z
	},
	rotation_offset = {
		x = DefaultSettings.rotation_offset.x,
		y = DefaultSettings.rotation_offset.y,
		z = DefaultSettings.rotation_offset.z
	},
	fov_offset = DefaultSettings.fov_offset,
	enabled = DefaultSettings.enabled
}

-- Camera system hooks
local CameraHooks = {}

--- Apply position offset to viewmodel
-- @param offset_x number X axis offset
-- @param offset_y number Y axis offset
-- @param offset_z number Z axis offset
function ViewmodelModule:apply_position_offset(offset_x, offset_y, offset_z)
	if not self:is_enabled() then
		return false
	end
	
	CurrentSettings.position_offset.x = offset_x or 0
	CurrentSettings.position_offset.y = offset_y or 0
	CurrentSettings.position_offset.z = offset_z or 0
	
	self:_update_camera_hooks()
	return true
end

--- Apply rotation offset to viewmodel
-- @param offset_x number X axis rotation offset (pitch)
-- @param offset_y number Y axis rotation offset (yaw)
-- @param offset_z number Z axis rotation offset (roll)
function ViewmodelModule:apply_rotation_offset(offset_x, offset_y, offset_z)
	if not self:is_enabled() then
		return false
	end
	
	CurrentSettings.rotation_offset.x = offset_x or 0
	CurrentSettings.rotation_offset.y = offset_y or 0
	CurrentSettings.rotation_offset.z = offset_z or 0
	
	self:_update_camera_hooks()
	return true
end

--- Apply FOV offset to camera
-- @param fov_offset number FOV offset in degrees
function ViewmodelModule:apply_fov_offset(fov_offset)
	if not self:is_enabled() then
		return false
	end
	
	CurrentSettings.fov_offset = fov_offset or 0
	self:_update_camera_hooks()
	return true
end

--- Update all viewmodel settings
-- @param settings table Settings table containing position_offset, rotation_offset, fov_offset, enabled
function ViewmodelModule:update_settings(settings)
	if not settings or type(settings) ~= "table" then
		return false
	end
	
	if settings.position_offset and type(settings.position_offset) == "table" then
		CurrentSettings.position_offset.x = settings.position_offset.x or CurrentSettings.position_offset.x
		CurrentSettings.position_offset.y = settings.position_offset.y or CurrentSettings.position_offset.y
		CurrentSettings.position_offset.z = settings.position_offset.z or CurrentSettings.position_offset.z
	end
	
	if settings.rotation_offset and type(settings.rotation_offset) == "table" then
		CurrentSettings.rotation_offset.x = settings.rotation_offset.x or CurrentSettings.rotation_offset.x
		CurrentSettings.rotation_offset.y = settings.rotation_offset.y or CurrentSettings.rotation_offset.y
		CurrentSettings.rotation_offset.z = settings.rotation_offset.z or CurrentSettings.rotation_offset.z
	end
	
	if settings.fov_offset then
		CurrentSettings.fov_offset = settings.fov_offset
	end
	
	if settings.enabled ~= nil then
		CurrentSettings.enabled = settings.enabled
	end
	
	self:_update_camera_hooks()
	return true
end

--- Get current viewmodel settings
-- @return table Current settings table
function ViewmodelModule:get_current_settings()
	return {
		position_offset = {
			x = CurrentSettings.position_offset.x,
			y = CurrentSettings.position_offset.y,
			z = CurrentSettings.position_offset.z
		},
		rotation_offset = {
			x = CurrentSettings.rotation_offset.x,
			y = CurrentSettings.rotation_offset.y,
			z = CurrentSettings.rotation_offset.z
		},
		fov_offset = CurrentSettings.fov_offset,
		enabled = CurrentSettings.enabled
	}
end

--- Get default settings
-- @return table Default settings table
function ViewmodelModule:get_default_settings()
	return {
		position_offset = {
			x = DefaultSettings.position_offset.x,
			y = DefaultSettings.position_offset.y,
			z = DefaultSettings.position_offset.z
		},
		rotation_offset = {
			x = DefaultSettings.rotation_offset.x,
			y = DefaultSettings.rotation_offset.y,
			z = DefaultSettings.rotation_offset.z
		},
		fov_offset = DefaultSettings.fov_offset,
		enabled = DefaultSettings.enabled
	}
end

--- Reset all settings to defaults
function ViewmodelModule:reset_to_defaults()
	CurrentSettings.position_offset.x = DefaultSettings.position_offset.x
	CurrentSettings.position_offset.y = DefaultSettings.position_offset.y
	CurrentSettings.position_offset.z = DefaultSettings.position_offset.z
	
	CurrentSettings.rotation_offset.x = DefaultSettings.rotation_offset.x
	CurrentSettings.rotation_offset.y = DefaultSettings.rotation_offset.y
	CurrentSettings.rotation_offset.z = DefaultSettings.rotation_offset.z
	
	CurrentSettings.fov_offset = DefaultSettings.fov_offset
	CurrentSettings.enabled = DefaultSettings.enabled
	
	self:_update_camera_hooks()
	return true
end

--- Enable/disable viewmodel system
-- @param enabled boolean Enable or disable
function ViewmodelModule:set_enabled(enabled)
	CurrentSettings.enabled = enabled
	self:_update_camera_hooks()
	return true
end

--- Check if viewmodel system is enabled
-- @return boolean Enabled status
function ViewmodelModule:is_enabled()
	return CurrentSettings.enabled
end

--- Register camera hook for viewport manager
-- @param hook_name string Name of the hook
-- @param hook_function function Function to execute
function ViewmodelModule:register_camera_hook(hook_name, hook_function)
	if not hook_name or not hook_function or type(hook_function) ~= "function" then
		return false
	end
	
	CameraHooks[hook_name] = hook_function
	return true
end

--- Unregister camera hook
-- @param hook_name string Name of the hook to remove
function ViewmodelModule:unregister_camera_hook(hook_name)
	if not hook_name then
		return false
	end
	
	CameraHooks[hook_name] = nil
	return true
end

--- Internal function to update all registered camera hooks
function ViewmodelModule:_update_camera_hooks()
	if not CurrentSettings.enabled then
		return
	end
	
	for hook_name, hook_function in pairs(CameraHooks) do
		local success, err = pcall(function()
			hook_function(CurrentSettings)
		end)
		
		if not success then
			log("[ViewmodelModule] Error executing hook '" .. hook_name .. "': " .. tostring(err))
		end
	end
end

--- Get position offset
-- @return table Position offset {x, y, z}
function ViewmodelModule:get_position_offset()
	return {
		x = CurrentSettings.position_offset.x,
		y = CurrentSettings.position_offset.y,
		z = CurrentSettings.position_offset.z
	}
end

--- Get rotation offset
-- @return table Rotation offset {x, y, z}
function ViewmodelModule:get_rotation_offset()
	return {
		x = CurrentSettings.rotation_offset.x,
		y = CurrentSettings.rotation_offset.y,
		z = CurrentSettings.rotation_offset.z
	}
end

--- Get FOV offset
-- @return number FOV offset
function ViewmodelModule:get_fov_offset()
	return CurrentSettings.fov_offset
end

return ViewmodelModule
