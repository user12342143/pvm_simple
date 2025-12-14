-- Payday 2 Viewmodel Mod - Main Initialization
-- BLT Framework Compatible

PVM = PVM or {}
PVM.config = {}
PVM._data = {}
PVM._enabled = true
PVM._menu_open = false
PVM.version = "1.0.0"

-- Load configuration
function PVM:load_config()
    self.config = {
        position = {
            x = 0,
            y = 0,
            z = 0
        },
        rotation = {
            pitch = 0,
            yaw = 0,
            roll = 0
        },
        enabled = true,
        debug = false
    }
    self:log("Config loaded")
end

-- Initialize mod
function PVM:init()
    self:load_config()
    self:setup_hooks()
    self:log("Viewmodel Mod initialized - Press F6 to toggle menu")
end

-- Setup game hooks
function PVM:setup_hooks()
    -- Game setup
    if Hooks then
        Hooks:Add("GameSetupPostInit", "PVM_Init", function()
            PVM:on_game_setup()
        end)
        
        -- Update loop
        Hooks:Add("Update", "PVM_Update", function(t, dt)
            PVM:update(dt)
        end)
        
        -- Render loop
        Hooks:Add("PostRender", "PVM_Render", function()
            if PVM._menu_open then
                PVM:render_menu()
            end
        end)
        
        self:log("Hooks registered successfully")
    end
end

-- Game setup callback
function PVM:on_game_setup()
    self:setup_input()
end

-- Setup input keybinding
function PVM:setup_input()
    if Input then
        -- Register F6 keybind to toggle menu
        Input:bind_key(Idstring("f6"), "pvm_toggle_menu", function()
            PVM:toggle_menu()
        end, {wait_time = 0.3})
        self:log("F6 keybind registered")
    end
end

-- Toggle menu
function PVM:toggle_menu()
    self._menu_open = not self._menu_open
    self:log("Menu toggled: " .. tostring(self._menu_open))
end

-- Update loop
function PVM:update(dt)
    if self._enabled then
        self:apply_viewmodel_offset()
    end
end

-- Apply viewmodel offset - placeholder for actual implementation
function PVM:apply_viewmodel_offset()
    -- This will be implemented with actual camera offset logic
end

-- Render menu - placeholder
function PVM:render_menu()
    -- Menu rendering will be implemented here
end

-- Logging helper
function PVM:log(message)
    if self.config.debug then
        print("[PVM Simple] " .. tostring(message))
    end
end

-- Initialize on load
PVM:init()