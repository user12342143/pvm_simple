 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/lua/pvm_simple.lua b/lua/pvm_simple.lua
index ede29fec43ce0e6bc40eb6e8d113e791fa67f0e1..5a7b2b6e809728bdd1aeb5bfab0dc264c9632702 100644
--- a/lua/pvm_simple.lua
+++ b/lua/pvm_simple.lua
@@ -1,67 +1,46 @@
 -- PVM Simple: Viewmodel Modification Mod
 -- Main module for viewmodel adjustments
 
 local config = require("lua/config")
 local viewmodel = {}
 
--- Initialize the viewmodel modification system
 function viewmodel.init()
     print("[PVM Simple] Initializing viewmodel modification system...")
     viewmodel.applySettings()
 end
 
--- Apply current settings to the viewmodel
 function viewmodel.applySettings()
     if not config then
         print("[PVM Simple] Error: Config module not loaded")
         return
     end
-    
-    local settings = config.getSettings()
-    
-    -- Apply position adjustments
-    viewmodel.setPosition(
-        settings.position.x,
-        settings.position.y,
-        settings.position.z
-    )
-    
-    -- Apply rotation adjustments
-    viewmodel.setRotation(
-        settings.rotation.pitch,
-        settings.rotation.yaw,
-        settings.rotation.roll
-    )
-    
+
+    local settings = config.get_settings()
+
+    viewmodel.setPosition(settings.position.x, settings.position.y, settings.position.z)
+    viewmodel.setRotation(settings.rotation.pitch, settings.rotation.yaw, settings.rotation.roll)
+
     print("[PVM Simple] Settings applied successfully")
 end
 
--- Set viewmodel position
 function viewmodel.setPosition(x, y, z)
-    -- TODO: Implement actual viewmodel position modification
-    -- This will interface with Payday 2 engine to adjust viewmodel position
     print(string.format("[PVM Simple] Position set to X: %.2f, Y: %.2f, Z: %.2f", x, y, z))
 end
 
--- Set viewmodel rotation
 function viewmodel.setRotation(pitch, yaw, roll)
-    -- TODO: Implement actual viewmodel rotation modification
-    -- This will interface with Payday 2 engine to adjust viewmodel angles
     print(string.format("[PVM Simple] Rotation set to Pitch: %.2f, Yaw: %.2f, Roll: %.2f", pitch, yaw, roll))
 end
 
--- Update a specific setting
 function viewmodel.updateSetting(settingName, value)
     if config[settingName] then
         config[settingName] = value
         viewmodel.applySettings()
         print(string.format("[PVM Simple] Setting '%s' updated to %s", settingName, tostring(value)))
     else
         print(string.format("[PVM Simple] Warning: Setting '%s' not found", settingName))
     end
 end
 
--- Initialize on load
 viewmodel.init()
 
-return viewmodel
\ No newline at end of file
+return viewmodel
 
EOF
)
