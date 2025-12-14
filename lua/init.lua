 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/lua/init.lua b/lua/init.lua
index 4df7d7aab7bb2e8fe3dc0209e6d6bf8def01305d..4680435dbf79968336a57fbc9c642889d6d78ea8 100644
--- a/lua/init.lua
+++ b/lua/init.lua
@@ -1,172 +1,118 @@
- (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
-diff --git a/lua/init.lua b/lua/init.lua
-index 66f3a86bcbd0cca0826e48d27f87190a2626580c..fea91fcd7e1cdb886896f881e5b4ed1bc461f13d 100644
---- a/lua/init.lua
-+++ b/lua/init.lua
-@@ -1,108 +1,107 @@
- -- Payday 2 Viewmodel Mod - Main Initialization
- -- BLT Framework Compatible
- 
-+local config_module = require("lua/config")
-+local viewmodel_module = require("lua/viewmodel")
-+local menu_module = require("lua/menu")
-+
- PVM = PVM or {}
--PVM.config = {}
--PVM._data = {}
- PVM._enabled = true
- PVM._menu_open = false
- PVM.version = "1.0.0"
-+PVM.config = config_module.get_settings()
- 
---- Load configuration
- function PVM:load_config()
--    self.config = {
--        position = {
--            x = 0,
--            y = 0,
--            z = 0
--        },
--        rotation = {
--            pitch = 0,
--            yaw = 0,
--            roll = 0
--        },
--        enabled = true,
--        debug = false
--    }
-+    self.config = config_module.get_settings()
-     self:log("Config loaded")
- end
- 
---- Initialize mod
- function PVM:init()
-     self:load_config()
-+    menu_module:init(self)
-     self:setup_hooks()
-     self:log("Viewmodel Mod initialized - Press F6 to toggle menu")
- end
- 
---- Setup game hooks
- function PVM:setup_hooks()
--    -- Game setup
--    if Hooks then
--        Hooks:Add("GameSetupPostInit", "PVM_Init", function()
--            PVM:on_game_setup()
--        end)
--        
--        -- Update loop
--        Hooks:Add("Update", "PVM_Update", function(t, dt)
--            PVM:update(dt)
--        end)
--        
--        -- Render loop
--        Hooks:Add("PostRender", "PVM_Render", function()
--            if PVM._menu_open then
--                PVM:render_menu()
--            end
--        end)
--        
--        self:log("Hooks registered successfully")
-+    if not Hooks then
-+        return
-     end
-+
-+    Hooks:Add("GameSetupPostInit", "PVM_Init", function()
-+        PVM:on_game_setup()
-+    end)
-+
-+    Hooks:Add("Update", "PVM_Update", function(t, dt)
-+        PVM:update(dt)
-+    end)
-+
-+    Hooks:Add("PostRender", "PVM_Render", function()
-+        if PVM._menu_open then
-+            PVM:render_menu()
-+        elseif menu_module:is_open() then
-+            menu_module:hide_menu()
-+        end
-+    end)
-+
-+    self:log("Hooks registered successfully")
- end
- 
---- Game setup callback
- function PVM:on_game_setup()
-     self:setup_input()
- end
- 
---- Setup input keybinding
- function PVM:setup_input()
--    if Input then
--        -- Register F6 keybind to toggle menu
--        Input:bind_key(Idstring("f6"), "pvm_toggle_menu", function()
--            PVM:toggle_menu()
--        end, {wait_time = 0.3})
--        self:log("F6 keybind registered")
-+    if not Input then
-+        return
-     end
-+
-+    Input:bind_key(Idstring("f6"), "pvm_toggle_menu", function()
-+        PVM:toggle_menu()
-+    end, { wait_time = 0.3 })
-+    self:log("F6 keybind registered")
- end
- 
---- Toggle menu
- function PVM:toggle_menu()
-     self._menu_open = not self._menu_open
-+    if self._menu_open then
-+        menu_module:show_menu()
-+    else
-+        menu_module:hide_menu()
-+    end
-     self:log("Menu toggled: " .. tostring(self._menu_open))
- end
- 
---- Update loop
- function PVM:update(dt)
-     if self._enabled then
-         self:apply_viewmodel_offset()
-     end
- end
- 
---- Apply viewmodel offset - placeholder for actual implementation
- function PVM:apply_viewmodel_offset()
--    -- This will be implemented with actual camera offset logic
-+    viewmodel_module:update_settings({
-+        position_offset = {
-+            x = self.config.position.x,
-+            y = self.config.position.y,
-+            z = self.config.position.z
-+        },
-+        rotation_offset = {
-+            x = self.config.rotation.pitch,
-+            y = self.config.rotation.yaw,
-+            z = self.config.rotation.roll
-+        },
-+        enabled = self.config.enabled
-+    })
- end
- 
---- Render menu - placeholder
- function PVM:render_menu()
--    -- Menu rendering will be implemented here
-+    menu_module:render(self.config)
- end
- 
---- Logging helper
- function PVM:log(message)
-     if self.config.debug then
-         print("[PVM Simple] " .. tostring(message))
-     end
- end
- 
---- Initialize on load
--PVM:init()
-\ No newline at end of file
-+PVM:init()
- 
-EOF
-)
+-- Payday 2 Viewmodel Mod - Main Initialization
+-- BLT Framework Compatible
+
+local config_module = require("lua/config")
+local viewmodel_module = require("lua/viewmodel")
+local menu_module = require("lua/menu")
+
+PVM = PVM or {}
+PVM._enabled = true
+PVM._menu_open = false
+PVM.version = "1.0.0"
+PVM.config = config_module.get_settings()
+
+-- Load configuration
+function PVM:load_config()
+    self.config = config_module.get_settings()
+    self:log("Config loaded")
+end
+
+-- Initialize mod
+function PVM:init()
+    self:load_config()
+    menu_module:init(self)
+    self:setup_hooks()
+    self:log("Viewmodel Mod initialized - Press F6 to toggle menu")
+end
+
+-- Setup game hooks
+function PVM:setup_hooks()
+    if not Hooks then
+        return
+    end
+
+    Hooks:Add("GameSetupPostInit", "PVM_Init", function()
+        PVM:on_game_setup()
+    end)
+
+    Hooks:Add("Update", "PVM_Update", function(t, dt)
+        PVM:update(dt)
+    end)
+
+    Hooks:Add("PostRender", "PVM_Render", function()
+        if PVM._menu_open then
+            PVM:render_menu()
+        elseif menu_module:is_open() then
+            menu_module:hide_menu()
+        end
+    end)
+
+    self:log("Hooks registered successfully")
+end
+
+-- Game setup callback
+function PVM:on_game_setup()
+    self:setup_input()
+end
+
+-- Setup input keybinding
+function PVM:setup_input()
+    if not Input then
+        return
+    end
+
+    Input:bind_key(Idstring("f6"), "pvm_toggle_menu", function()
+        PVM:toggle_menu()
+    end, { wait_time = 0.3 })
+    self:log("F6 keybind registered")
+end
+
+-- Toggle menu
+function PVM:toggle_menu()
+    self._menu_open = not self._menu_open
+    if self._menu_open then
+        menu_module:show_menu()
+    else
+        menu_module:hide_menu()
+    end
+    self:log("Menu toggled: " .. tostring(self._menu_open))
+end
+
+-- Update loop
+function PVM:update(dt)
+    if self._enabled then
+        self:apply_viewmodel_offset()
+    end
+end
+
+-- Apply viewmodel offset - placeholder for actual implementation
+function PVM:apply_viewmodel_offset()
+    viewmodel_module:update_settings({
+        position_offset = {
+            x = self.config.position.x,
+            y = self.config.position.y,
+            z = self.config.position.z
+        },
+        rotation_offset = {
+            x = self.config.rotation.pitch,
+            y = self.config.rotation.yaw,
+            z = self.config.rotation.roll
+        },
+        enabled = self.config.enabled
+    })
+end
+
+-- Render menu - placeholder
+function PVM:render_menu()
+    menu_module:render(self.config)
+end
+
+-- Logging helper
+function PVM:log(message)
+    if self.config.debug then
+        print("[PVM Simple] " .. tostring(message))
+    end
+end
+
+-- Initialize on load
+PVM:init()
 
EOF
)
