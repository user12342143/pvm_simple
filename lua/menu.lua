 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/lua/menu.lua b/lua/menu.lua
new file mode 100644
index 0000000000000000000000000000000000000000..80097dfb6a48aa7504de054832a554e5d7ed1c45
--- /dev/null
+++ b/lua/menu.lua
@@ -0,0 +1,186 @@
+-- Menu module responsible for building and rendering the in-game sliders
+
+local config_module = require("lua/config")
+
+local Menu = {}
+Menu.menu_id = "pvm_simple_menu"
+Menu._initialized = false
+Menu._is_open = false
+Menu._pvm = nil
+
+local SLIDERS = {
+    {
+        id = "pvm_simple_position_x",
+        title = "Position X",
+        desc = "Adjust horizontal viewmodel offset",
+        key = "position_x",
+        min = -100,
+        max = 100,
+        step = 1
+    },
+    {
+        id = "pvm_simple_position_y",
+        title = "Position Y",
+        desc = "Adjust vertical viewmodel offset",
+        key = "position_y",
+        min = -100,
+        max = 100,
+        step = 1
+    },
+    {
+        id = "pvm_simple_position_z",
+        title = "Position Z",
+        desc = "Adjust forward/backward viewmodel offset",
+        key = "position_z",
+        min = -100,
+        max = 100,
+        step = 1
+    },
+    {
+        id = "pvm_simple_rotation_pitch",
+        title = "Rotation Pitch",
+        desc = "Rotate viewmodel on X axis",
+        key = "rotation_pitch",
+        min = -180,
+        max = 180,
+        step = 1
+    },
+    {
+        id = "pvm_simple_rotation_yaw",
+        title = "Rotation Yaw",
+        desc = "Rotate viewmodel on Y axis",
+        key = "rotation_yaw",
+        min = -180,
+        max = 180,
+        step = 1
+    },
+    {
+        id = "pvm_simple_rotation_roll",
+        title = "Rotation Roll",
+        desc = "Rotate viewmodel on Z axis",
+        key = "rotation_roll",
+        min = -180,
+        max = 180,
+        step = 1
+    }
+}
+
+local function get_config_value(config, key)
+    if key == "position_x" then return config.position.x end
+    if key == "position_y" then return config.position.y end
+    if key == "position_z" then return config.position.z end
+    if key == "rotation_pitch" then return config.rotation.pitch end
+    if key == "rotation_yaw" then return config.rotation.yaw end
+    if key == "rotation_roll" then return config.rotation.roll end
+end
+
+local function set_config_value(config, key, value)
+    if key == "position_x" then config.position.x = value end
+    if key == "position_y" then config.position.y = value end
+    if key == "position_z" then config.position.z = value end
+    if key == "rotation_pitch" then config.rotation.pitch = value end
+    if key == "rotation_yaw" then config.rotation.yaw = value end
+    if key == "rotation_roll" then config.rotation.roll = value end
+end
+
+function Menu:init(pvm)
+    if self._initialized then
+        return
+    end
+
+    self._pvm = pvm
+    self:_setup_menu_callbacks()
+    self:_setup_menu_structure()
+    self._initialized = true
+end
+
+function Menu:_setup_menu_callbacks()
+    if not MenuCallbackHandler then
+        return
+    end
+
+    MenuCallbackHandler.PVM_Slider_Changed = function(_, item)
+        local key = item:parameters().callback_key
+        local value = tonumber(item:value())
+        if not key or not value then
+            return
+        end
+
+        set_config_value(self._pvm.config, key, value)
+        config_module.update_from_sliders({ [key] = value })
+        self._pvm:apply_viewmodel_offset()
+    end
+end
+
+function Menu:_setup_menu_structure()
+    if not Hooks or not MenuHelper then
+        return
+    end
+
+    Hooks:Add("MenuManagerSetupCustomMenus", "PVM_Simple_SetupMenu", function(menu_manager, menus)
+        menus[self.menu_id] = MenuHelper:NewMenu(self.menu_id)
+    end)
+
+    Hooks:Add("MenuManagerPopulateCustomMenus", "PVM_Simple_PopulateMenu", function(menu_manager, menus)
+        for _, slider in ipairs(SLIDERS) do
+            MenuHelper:AddSlider({
+                id = slider.id,
+                title = slider.title,
+                desc = slider.desc,
+                callback = "PVM_Slider_Changed",
+                value = get_config_value(self._pvm.config, slider.key),
+                min = slider.min,
+                max = slider.max,
+                step = slider.step,
+                show_value = true,
+                menu_id = self.menu_id,
+                priority = 100,
+                callback_key = slider.key
+            })
+        end
+    end)
+
+    Hooks:Add("MenuManagerBuildCustomMenus", "PVM_Simple_BuildMenu", function(menu_manager, nodes)
+        nodes[self.menu_id] = MenuHelper:BuildMenu(self.menu_id)
+    end)
+end
+
+function Menu:show_menu()
+    if managers and managers.menu then
+        managers.menu:open_node(self.menu_id)
+        self._is_open = true
+    end
+end
+
+function Menu:hide_menu()
+    if managers and managers.menu and self._is_open then
+        managers.menu:back()
+    end
+    self._is_open = false
+end
+
+function Menu:is_open()
+    return self._is_open
+end
+
+function Menu:render(current_config)
+    if not self._is_open then
+        self:show_menu()
+        return
+    end
+
+    if not managers or not managers.menu_component then
+        return
+    end
+
+    -- Sync slider values if config changed elsewhere
+    for _, slider in ipairs(SLIDERS) do
+        local value = get_config_value(current_config, slider.key)
+        local slider_item = managers.menu:active_menu() and managers.menu:active_menu().logic:get_item(slider.id)
+        if slider_item and slider_item:value() ~= value then
+            slider_item:set_value(value)
+        end
+    end
+end
+
+return Menu
 
EOF
)
