local reloadP = require("scripts.reloadPods")

local Unlink = function(event)
  if event.entity then
    if event.entity.grid then
      --reloadP.UnloadPods({event.entity}, nil, nil)
      --reloadP.GridLosesOwnerEntity(event.entity.grid) -- if factorio keeps grid and destroys only inventory
      reloadP.GridIsDead(nil, event.entity.grid) -- if factorio destroys grid too
    -- else game.print ("Mined vehicle has no equipment grid!")
    end
  end
end

local Link = function(event)
  -- reloadP.GridGetsOwner(event.created_entity, false)
  reloadP.EntityBuiltRaised(event) -- assuming someone is playing with entities, transferring grid equipment and other things
end

local KilledGridOwner = function(event)
  if event.entity and event.entity.grid then reloadP.GridIsDead(nil, event.entity.grid) end
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
    script.on_event( defines.events.script_raised_destroy,  reloadP.EntityDestruction, {{filter = "vehicle"}} )
    script.on_event( defines.events.script_raised_built,  reloadP.EntityBuiltRaised, {{filter = "vehicle"}} )

  end

  if settings.startup["zd-PlayerArmorSupport"].value then

    script.on_event(defines.events.on_player_driving_changed_state, function (event)
      local player = game.get_player(event.player_index)
      reloadP.DrivingState(player)
    end)

    script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
      reloadP.CheckArmor(game.get_player(event.player_index))
    end)
    
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
  reloadP.Init()
  add_hooks()
end)

script.on_load(function()
  reloadP.OnLoad()
  add_hooks()
end)

script.on_configuration_changed(function()
  
  reloadP.AddMagazines()
  for _, surface in pairs(game.surfaces) do
    local vehicles = surface.find_entities_filtered({ type = {"car", "spider-vehicle", "cargo-wagon"}, force = "player" })
    for _, entity in pairs(vehicles) do
      reloadP.GridGetsOwner(entity, true)
    end
  end
  if settings.startup["zd-PlayerArmorSupport"].value then
    for _, p in pairs(game.players) do
      if p and p.valid and p.character and p.character.valid then reloadP.CheckArmor(p) end
    end
  else
    -- Check and unregister all char armors here...
    for i = (storage.reloadPods.last_grid - 1), 1, -1 do
      if storage.reloadPods.grids[i] and storage.reloadPods.grids[i].inv_type == defines.inventory.character_main then
        reloadP.GridIsDead(i, nil)
      end
    end
  end
end)

script.on_event(defines.events.on_selected_entity_changed, function(e)
  reloadP.selectedEntity(e)
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
  if e.setting == "zd-AllowChangeAmmo" then storage.reloadPods.AllowChangeAmmo = settings.global["zd-AllowChangeAmmo"].value end
  --game.print("Auto ammunition reset setting was changed!")
end)

script.on_event(defines.events.on_tick, function(event)
  reloadP.EveryTick(storage.reloadPods.equipped_weapon_id, event.tick)
  if storage.reloadPods.equipped_weapon_id >= storage.reloadPods.equipped_weapon_last then storage.reloadPods.equipped_weapon_id = 1
   else storage.reloadPods.equipped_weapon_id = storage.reloadPods.equipped_weapon_id + 1 end
end)

script.on_event(defines.events.on_player_selected_area, function (event)
  local player = game.get_player(event.player_index)
  if event.item == "zd-ammo-unload" then
    reloadP.UnloadPods(event.entities, player, event.area, event.tick + 1200)
  end
end)


script.on_event(defines.events.on_player_placed_equipment, function (event)
  reloadP.NewEquipment(event.equipment, event.grid)
end)
script.on_event(defines.events.on_player_removed_equipment, function (event)
  local player = game.get_player(event.player_index)
  reloadP.RemoveEquipment(event.equipment, event.grid, event.count, player)
end)
