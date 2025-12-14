 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/lua/config.lua b/lua/config.lua
index 843fff7dab212c62adc029ebead3357205f26fce..c9b92d3a01087726e34a225bf10ac0bd7e090b84 100644
--- a/lua/config.lua
+++ b/lua/config.lua
@@ -1,89 +1,56 @@
- (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
-diff --git a/lua/config.lua b/lua/config.lua
-index e2d752537ff3bfea884b7511dc4a53d44e563d68..c9b92d3a01087726e34a225bf10ac0bd7e090b84 100644
---- a/lua/config.lua
-+++ b/lua/config.lua
-@@ -1,49 +1,56 @@
- -- PVM Simple Configuration
- -- Mod settings and slider values
- 
- local config = {
--    -- Enabled state
-     enabled = true,
--    
--    -- Viewmodel position adjustments (in units)
-+    debug = false,
-     position = {
--        x = 0,      -- Left/Right adjustment (-100 to 100)
--        y = 0,      -- Up/Down adjustment (-100 to 100)
--        z = 0       -- Forward/Backward adjustment (-100 to 100)
-+        x = 0,
-+        y = 0,
-+        z = 0
-     },
--    
--    -- Viewmodel rotation adjustments (in degrees)
-     rotation = {
--        pitch = 0,  -- X-axis rotation (-180 to 180)
--        yaw = 0,    -- Y-axis rotation (-180 to 180)
--        roll = 0    -- Z-axis rotation (-180 to 180)
-+        pitch = 0,
-+        yaw = 0,
-+        roll = 0
-     }
- }
- 
---- Function to update configuration from slider values
--function config.updateFromSliders(sliders)
-+local function copy_table(tbl)
-+    local result = {}
-+    for key, value in pairs(tbl) do
-+        if type(value) == "table" then
-+            result[key] = copy_table(value)
-+        else
-+            result[key] = value
-+        end
-+    end
-+    return result
-+end
-+
-+function config.update_from_sliders(sliders)
-     if sliders.position_x then config.position.x = sliders.position_x end
-     if sliders.position_y then config.position.y = sliders.position_y end
-     if sliders.position_z then config.position.z = sliders.position_z end
-     if sliders.rotation_pitch then config.rotation.pitch = sliders.rotation_pitch end
-     if sliders.rotation_yaw then config.rotation.yaw = sliders.rotation_yaw end
-     if sliders.rotation_roll then config.rotation.roll = sliders.rotation_roll end
-+    if sliders.enabled ~= nil then config.enabled = sliders.enabled end
- end
- 
---- Function to get all current settings as a table
--function config.getSettings()
--    return {
--        enabled = config.enabled,
--        position = config.position,
--        rotation = config.rotation
--    }
-+function config.get_settings()
-+    return copy_table(config)
-+end
-+
-+function config.set_enabled(enabled)
-+    config.enabled = enabled and true or false
- end
- 
---- Function to reset all settings to defaults
- function config.reset()
-     config.position = { x = 0, y = 0, z = 0 }
-     config.rotation = { pitch = 0, yaw = 0, roll = 0 }
--    print("[PVM Simple] Configuration reset to defaults")
-+    config.enabled = true
-+    config.debug = false
- end
- 
--return config
-\ No newline at end of file
-+return config
- 
-EOF
-)
+-- PVM Simple Configuration
+-- Mod settings and slider values
+
+local config = {
+    enabled = true,
+    debug = false,
+    position = {
+        x = 0,
+        y = 0,
+        z = 0
+    },
+    rotation = {
+        pitch = 0,
+        yaw = 0,
+        roll = 0
+    }
+}
+
+local function copy_table(tbl)
+    local result = {}
+    for key, value in pairs(tbl) do
+        if type(value) == "table" then
+            result[key] = copy_table(value)
+        else
+            result[key] = value
+        end
+    end
+    return result
+end
+
+function config.update_from_sliders(sliders)
+    if sliders.position_x then config.position.x = sliders.position_x end
+    if sliders.position_y then config.position.y = sliders.position_y end
+    if sliders.position_z then config.position.z = sliders.position_z end
+    if sliders.rotation_pitch then config.rotation.pitch = sliders.rotation_pitch end
+    if sliders.rotation_yaw then config.rotation.yaw = sliders.rotation_yaw end
+    if sliders.rotation_roll then config.rotation.roll = sliders.rotation_roll end
+    if sliders.enabled ~= nil then config.enabled = sliders.enabled end
+end
+
+function config.get_settings()
+    return copy_table(config)
+end
+
+function config.set_enabled(enabled)
+    config.enabled = enabled and true or false
+end
+
+function config.reset()
+    config.position = { x = 0, y = 0, z = 0 }
+    config.rotation = { pitch = 0, yaw = 0, roll = 0 }
+    config.enabled = true
+    config.debug = false
+end
+
+return config
 
EOF
)
