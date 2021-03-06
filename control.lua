local reloadPods = require("scripts.reloadPods")

remote.add_interface("zd-turretpod", reloadPods.remote_interface)

local Unlink = function(event)
  if event.entity then
    if event.entity.grid then reloadPods.GridLosesOwnerEntity(event.entity.grid)
    -- else game.print ("Mined vehicle has no equipment grid!")
    end
  end
end

local Link = function(event)
  reloadPods.GridGetsOwner(event.created_entity)
end

local KilledGridOwner = function(event)
  if event.entity and event.entity.grid then reloadPods.GridIsDead(nil, event.entity.grid) end
end

local function add_hooks()

  if settings.startup["zd-AllVehiclesSupport"].value then

-- ** any vehicle support
-- ?? on_entity_destroyed event.unit_number

    script.on_event( defines.events.on_built_entity, Link, {{filter = "vehicle"}} )
    script.on_event( defines.events.on_robot_built_entity,  Link, {{filter = "vehicle"}} )

    script.on_event( defines.events.on_entity_died,         KilledGridOwner, {{filter = "vehicle"}} )
    script.on_event( defines.events.on_pre_player_mined_item, Unlink, {{filter = "vehicle"}} )
    script.on_event( defines.events.on_robot_pre_mined,  Unlink, {{filter = "vehicle"}} )

  else

  -- ** only driven vehicles support
    script.on_event(defines.events.on_player_driving_changed_state, function (event)
      local player = game.get_player(event.player_index)
      reloadPods.DrivingState(player)
    end)

  end

  if settings.startup["zd-PlayerArmorSupport"].value then

    -- ** human armor support option
--  on_player_armor_inventory_changed
-- ?? on_player_died

-- ~~ ?? and multiplayer is supported ???
-- on_player_removed
-- on_player_kicked
-- on_player_left_game
-- on_player_joined_game
  end

end

script.on_init(function()
  reloadPods.Init()
  add_hooks()
end)

script.on_load(function()
  reloadPods.OnLoad()
  add_hooks()
end)

script.on_configuration_changed(function()
  
  reloadPods.AddMagazines()
  
end)



script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
  if e.setting == "zd-AllowChangeAmmo" then global.reloadPods.AllowChangeAmmo = settings.global["zd-AllowChangeAmmo"].value end
  --game.print("Auto ammunition reset setting was changed!")
end)

script.on_event(defines.events.on_tick, function(event)
  reloadPods.EveryTick()

end)

script.on_event(defines.events.on_player_selected_area, function (event)
  local player = game.get_player(event.player_index)
  if event.item == "zd-ammo-unload" then
    reloadPods.UnloadPods(event.entities, player, event.area)
  end
end)


script.on_event(defines.events.on_player_placed_equipment, function (event)
  reloadPods.NewEquipment(event.equipment, event.grid)
end)
script.on_event(defines.events.on_player_removed_equipment, function (event)
  local player = game.get_player(event.player_index)
  reloadPods.RemoveEquipment(event.equipment, event.grid, event.count, player)
end)
