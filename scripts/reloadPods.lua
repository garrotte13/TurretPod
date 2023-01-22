local PodsTiers = {
    gun = {1, 2, 5},
    flame = {1, 2},
    shotgun = {1, 2, 5},
}
local reloadPod = {}
local weapons_equipment
local equipped_weapons_count
local equipped_weapon_id
local equipped_weapon_last

local grids
local last_grid
local grids_count

local magazines
local this_pod
local this_grid
local inv
local pos

function reloadPod.Init()

    global.reloadPods =
    {
        AllowChangeAmmo = settings.global["zd-AllowChangeAmmo"].value,
        magazines = {},
        weapons_equipment = {},
        equipped_weapons_count = 0,
        equipped_weapon_id = 1,
        equipped_weapon_last = 1,
        grids = {},
        last_grid = 1,
        grids_count = 0,

    }
    reloadPod.AddMagazines()

    weapons_equipment = global.reloadPods.weapons_equipment
    equipped_weapons_count = global.reloadPods.equipped_weapons_count
    equipped_weapon_id = global.reloadPods.equipped_weapon_id
    equipped_weapon_last = global.reloadPods.equipped_weapon_last

    grids = global.reloadPods.grids
    last_grid = global.reloadPods.last_grid
    grids_count = global.reloadPods.grids_count

    magazines = global.reloadPods.magazines

end

function reloadPod.OnLoad()

    weapons_equipment = global.reloadPods.weapons_equipment
    equipped_weapons_count = global.reloadPods.equipped_weapons_count
    equipped_weapon_id = global.reloadPods.equipped_weapon_id
    equipped_weapon_last = global.reloadPods.equipped_weapon_last

    grids = global.reloadPods.grids
    last_grid = global.reloadPods.last_grid
    grids_count = global.reloadPods.grids_count

    magazines = global.reloadPods.magazines
end

function reloadPod.EveryTick()

    if global.reloadPods.weapons_equipment[global.reloadPods.equipped_weapon_id] and global.reloadPods.weapons_equipment[global.reloadPods.equipped_weapon_id].sleepUntil < game.ticks_played then
        this_pod = global.reloadPods.weapons_equipment[global.reloadPods.equipped_weapon_id]
        if global.reloadPods.grids[this_pod.grid_id].grid and global.reloadPods.grids[this_pod.grid_id].grid.valid then
            this_grid = global.reloadPods.grids[this_pod.grid_id]
            if this_pod.ammo_count > 0 then                 -- are we in reloading process?
                if this_pod.weapon and this_pod.weapon.valid and this_pod.capacity <= this_pod.weapon.energy then
                    --game.print("Energy amount required was reached: ".. this_pod.weapon.energy )
                    pos = this_pod.weapon.position
                    this_grid.grid.take{ equipment = this_pod.weapon }
                    this_pod.weapon = this_grid.grid.put{
                        name = "turret-pod-" .. this_pod.type .. "-t" .. this_pod.tier .. "-" .. this_pod.ammo .. "-equipment",
                        position = pos
                    }
                    this_pod.weapon.energy = this_pod.ammo_count
                    this_pod.ammo_count = 0
                end
            elseif this_pod.weapon.energy == 0 then     -- are we in out of ammo state?
                if this_grid.owner and this_grid.owner.valid then       -- is ammo source available?
                    inv = this_grid.owner.get_inventory(this_grid.inv_type)
                    if inv and inv.valid then
                        if this_pod.ammo == "empty" then
                            for magazine, size in pairs(magazines[this_pod.type]) do
                                --game.print("Ammo type we try: " .. magazine)
                                if reloadPod.TryLoadAmmo(magazine, inv, this_grid.grid, this_pod) then break end
                            end
                            if this_pod.ammo_count == 0 then this_pod.sleepUntil = game.ticks_played + 360 end -- no ammo found of any type in inventory. Pls someone kill this looser.
                        else
                            if not reloadPod.TryLoadAmmo(this_pod.ammo, inv, this_grid.grid, this_pod) then
                                if global.reloadPods.AllowChangeAmmo then
                                    this_pod.ammo = "empty"
                                    pos = this_pod.weapon.position
                                    this_grid.grid.take{ equipment = this_pod.weapon }
                                    this_pod.weapon = this_grid.grid.put{
                                        name = "turret-pod-" .. this_pod.type .. "-t" .. this_pod.tier .. "-" .. this_pod.ammo .. "-equipment",
                                        position = pos
                                    }
                                else this_pod.sleepUntil = game.ticks_played + 360 end -- no ammo found of wanted type in inventory. Pls someone kill this looser.
                            end
                        end
                    else this_pod.sleepUntil = game.ticks_played + 720      -- owner has a broken/absent inventory suddenly
                    end
                else this_pod.sleepUntil = game.ticks_played + 720       -- nowhere to get ammo from.
                end

            end         -- we are in excellent state, ready to shoot
        else this_pod.sleepUntil = game.ticks_played + 720 end -- reloadPods.GridIsDead(this_pod.grid_id, nil) end
    end
    if global.reloadPods.equipped_weapon_id >= global.reloadPods.equipped_weapon_last then global.reloadPods.equipped_weapon_id = 1
     else global.reloadPods.equipped_weapon_id = global.reloadPods.equipped_weapon_id + 1 end
end

function reloadPod.TryLoadAmmo(ammo_wanted, inventory, GridEntity, PodMember)
    local ammo_stack = inventory.find_item_stack(ammo_wanted)
    local stacks_needed = PodsTiers[PodMember.type][PodMember.tier]
    if ammo_stack and ammo_stack.count > 0 then
        pos = PodMember.weapon.position
        GridEntity.take{ equipment = PodMember.weapon }
        PodMember.weapon = GridEntity.put{
            name = "turret-pod-" .. PodMember.type .. "-t" .. PodMember.tier .. "-" .. ammo_wanted .. "-equipment-reload",
            position = pos
        }
        PodMember.weapon.energy = 0
        PodMember.capacity = tonumber(PodMember.weapon.prototype.energy_source.buffer_capacity)
        PodMember.ammo = ammo_wanted
        PodMember.ammo_count = ammo_stack.ammo

        if ammo_stack.count > stacks_needed then
            ammo_stack.count = ammo_stack.count - stacks_needed
            PodMember.ammo_count = PodMember.ammo_count + (stacks_needed - 1) * magazines[PodMember.type][ammo_wanted]
        else
            stacks_needed = stacks_needed - ammo_stack.count
            PodMember.ammo_count = PodMember.ammo_count + (ammo_stack.count - 1) * magazines[PodMember.type][ammo_wanted]
            inventory.remove(ammo_stack)
            if stacks_needed > 0 then   -- if we still can take more ammo in one reload of high-tier turret pod
                local ammo_stack2 = inventory.find_item_stack(ammo_wanted)  -- and inventory has another stack of that ammo
                if ammo_stack2 and ammo_stack2.count > 0 then
                    if ammo_stack2.count > stacks_needed then
                        PodMember.ammo_count = PodMember.ammo_count + stacks_needed * magazines[PodMember.type][ammo_wanted]
                        ammo_stack2.count = ammo_stack2.count - stacks_needed
                    else
                        PodMember.ammo_count = PodMember.ammo_count + ammo_stack2.count * magazines[PodMember.type][ammo_wanted]
                        inventory.remove(ammo_stack2)
                    end -- we don't look for third stack. If player put 3 stacks with 1 count, then we can't help a looser.
                end
            end
        end
        --game.print("Loading bullets count: " .. PodMember.ammo_count .. "  While capacity buffer is: " .. PodMember.capacity .. "Pod index: ".. global.reloadPods.equipped_weapon_id)
    else return false end
    return true
end

function reloadPod.AddWeapon(weapon, grid_id, untilTick)
    local weapon_type
    local weapon_tier
    local weapon_ammo
    weapon_type, weapon_tier, weapon_ammo = string.match(weapon.name, "turret%-pod%-(.+)%-t(%d)%-(.+)%-equipment")

    local r = 0
    for ids_num = 1, global.reloadPods.equipped_weapon_last do
        if not global.reloadPods.weapons_equipment[ids_num] then r = ids_num break end
    end
    if r == 0 then
        --game.print ("Last member of equipped pods was removed incorrectly! Total pods count: " .. equipped_weapons_count .. ". First free pod index: " .. equipped_weapon_last)
        global.reloadPods.equipped_weapon_last = global.reloadPods.equipped_weapon_last + 1
        r = global.reloadPods.equipped_weapon_last
    end
    weapon.energy = 0
    global.reloadPods.weapons_equipment[r] = {
        weapon = weapon,
        type = weapon_type,
        ammo = weapon_ammo,
        ammo_count = 0,
        sleepUntil = untilTick,
        capacity = 0,
        tier = tonumber(weapon_tier),
        grid_id = grid_id
    }
    table.insert(global.reloadPods.grids[grid_id].weapons, r)
    if r == global.reloadPods.equipped_weapon_last then global.reloadPods.equipped_weapon_last = global.reloadPods.equipped_weapon_last + 1 end
    global.reloadPods.equipped_weapons_count = global.reloadPods.equipped_weapons_count + 1
    --game.print("Installed pod: " .. weapon.name .. " Pod's index: " .. r .. " Grid index: " .. grid_id)
    --game.print("First free index is ".. global.reloadPods.equipped_weapon_last)
    --game.print("Total amount of installed turret pods in all active grids: " .. global.reloadPods.equipped_weapons_count)

end

function reloadPod.NewEquipment(weapon, grid)
    if weapon.type == "active-defense-equipment" and weapon.name:match("turret%-pod%-(.+)%-t%d") then
        local grid_id = 0
        local r = 0
        for ids = 1 , global.reloadPods.last_grid do
            if not global.reloadPods.grids[ids] then
                if r == 0 then r = ids end
            elseif global.reloadPods.grids[ids].grid == grid then
                grid_id = ids
                break
            end
        end
        if grid_id == 0 then
            if r == 0 then
                --game.print ("Last member of grids was removed incorrectly! Total grids count: " .. global.reloadPods.grids_count .. ". First free grid order number: " .. global.reloadPods.last_grid)
                global.reloadPods.last_grid = global.reloadPods.last_grid + 1
                r = global.reloadPods.last_grid
            end
            grid_id = r
            global.reloadPods.grids[grid_id] = {
                grid = grid,
                weapons = {},
                owner = nil,
                unit = 0,
                inv_type = nil,
            }
            if r == global.reloadPods.last_grid then global.reloadPods.last_grid = global.reloadPods.last_grid + 1 end
            global.reloadPods.grids_count = global.reloadPods.grids_count + 1
            --game.print("A new grid added. Its index: " .. grid_id)
            --game.print("Total amount of active grids: " .. global.reloadPods.grids_count .. ". Last index in array: " .. global.reloadPods.last_grid)
        end
        reloadPod.AddWeapon(weapon, grid_id, 0)
    end
end

function reloadPod.RemoveEquipment(weapon_name, grid, removed_count, player) -- several single-type weapons can be removed in one Ctrl+click
    if weapon_name:match("turret%-pod%-(.+)%-t%d") then
        local grid_id = 0
        for ids = 1 , global.reloadPods.last_grid do
            if global.reloadPods.grids[ids] and global.reloadPods.grids[ids].grid == grid then grid_id = ids break end
        end
        if grid_id > 0 then
            --game.print("Player removed pods from Grid with index ".. grid_id)
            local to_remove = {}
            local to_keep = {}
            local i = 0
            for _, weapon_id in pairs(global.reloadPods.grids[grid_id].weapons) do
                if global.reloadPods.weapons_equipment[weapon_id].weapon and global.reloadPods.weapons_equipment[weapon_id].weapon.valid then
                    table.insert(to_keep, weapon_id)
                else
                    i = i + 1
                    to_remove[i] = weapon_id
                end
            end
            if i < removed_count then
                game.print("Some turret pods were lost. Turret pods count to remove: " .. i .. " While player removed: " .. removed_count)
            end
            if i > 0 then
                global.reloadPods.grids[grid_id].weapons = to_keep
                for ids = 1, i do
                    --game.print("Removed " .. weapon_name .. " Pod index:" .. to_remove[ids])
                    global.reloadPods.weapons_equipment[to_remove[ids]] = nil
                end
                global.reloadPods.equipped_weapons_count = global.reloadPods.equipped_weapons_count - i
            else --game.print("No turret pods at all were found to remove!")
            end
        else
            --game.print("Grid was not found! Can't remove turret pods from it.")
        end
        --game.print("Total amount of remaining pods in all active grids: " .. global.reloadPods.equipped_weapons_count)
    end
end

function reloadPod.AddMagazines()
    global.reloadPods.magazines = {
        gun = {},
        flame = {},
        shotgun = {}
    }
    local typesOfPods = {"gun", "flame", "shotgun"}
    for _, podType in pairs(typesOfPods) do
        for item_name, item_prototype in pairs(game.get_filtered_item_prototypes{{filter = 'type', type = 'ammo'}}) do
            if game.equipment_prototypes["turret-pod-".. podType .. "-t2-" .. item_name .. "-equipment"] then
                global.reloadPods.magazines[podType][item_name] = item_prototype.magazine_size
            end
        end
    end
    magazines = global.reloadPods.magazines
end

function reloadPod.GridGetsOwner(entity)
    local grid
    if entity and entity.valid and entity.grid and entity.get_inventory(defines.inventory.car_trunk) then grid = entity.grid else return nil end
    local grid_id = 0
    local r = 0
    for ids = 1 , global.reloadPods.last_grid do
        if not global.reloadPods.grids[ids] then
            if r == 0 then r = ids end
        elseif global.reloadPods.grids[ids].grid == grid then
            grid_id = ids
            break
        end
    end
    if grid_id == 0 then
        if r == 0 then
            --game.print ("Last member of grids was removed incorrectly! Total grids count: " .. global.reloadPods.grids_count .. ". First free (but it's not free!) grid order number: " .. global.reloadPods.last_grid)
            global.reloadPods.last_grid = global.reloadPods.last_grid + 1
            r = global.reloadPods.last_grid
        end
        grid_id = r
        global.reloadPods.grids[grid_id] = {
            grid = grid,
            weapons = {},
            owner = nil,
            unit = 0,
            inv_type = defines.inventory.car_trunk,
        }
        if r == global.reloadPods.last_grid then global.reloadPods.last_grid = global.reloadPods.last_grid + 1 end
        global.reloadPods.grids_count = global.reloadPods.grids_count + 1
        --game.print("A new grid added. Its index: " .. grid_id)
        --game.print("Total amount of active grids: " .. global.reloadPods.grids_count .. ". Last index in array: " .. global.reloadPods.last_grid)

-- TO DO -- Find and Insert missing turret pods IF ANY are missing! Why can it happen?? Who inserted them? Expecting grid is to have no turret pods.

    end
    global.reloadPods.grids[grid_id].owner = entity
    global.reloadPods.grids[grid_id].inv_type = defines.inventory.car_trunk
    --game.print("A grid got an inventory connected. Grid's index: " .. grid_id)
    r = entity.unit_number -- https://lua-api.factorio.com/latest/LuaEntity.html#LuaEntity.unit_number
    if r then
        --game.print("Owner has a unit number: " .. r)
        global.reloadPods.grids[grid_id].unit = r
    end
    return grid_id
end

function reloadPod.GridIsDead(grid_id, grid) -- one of two parameters is always nil
    if grid then
        grid_id = 0
        for ids = 1 , global.reloadPods.last_grid do
            if global.reloadPods.grids[ids] and global.reloadPods.grids[ids].grid == grid then grid_id = ids break end
        end
        if grid_id == 0 then
            return
        else
            --game.print("A grid was removed due to death of its owner. It's index: ".. grid_id)
        end
    else --game.print("A grid with index " .. grid_id .. " was removed, because it was destroyed with/without its owner some time ago.")
    end
    local i
    if global.reloadPods.grids[grid_id].weapons then
        for _, weapon_id in pairs(global.reloadPods.grids[grid_id].weapons) do
            if global.reloadPods.weapons_equipment[weapon_id] then
                --game.print("Removed: turret-pod-" .. global.reloadPods.weapons_equipment[weapon_id].type .. "-t" .. global.reloadPods.weapons_equipment[weapon_id].tier .. "-" .. global.reloadPods.weapons_equipment[weapon_id].ammo .. "-equipment. Pod's index: " .. weapon_id)
                global.reloadPods.weapons_equipment[weapon_id] = nil
                global.reloadPods.equipped_weapons_count = global.reloadPods.equipped_weapons_count - 1
            else --game.print("That grid had a not-existing index of contained pod: ".. weapon_id)
            end
        end
    end
    global.reloadPods.grids[grid_id] = nil
    global.reloadPods.grids_count = global.reloadPods.grids_count - 1
    --game.print("Grid index was: " .. grid_id .. " Grids remaining amount is: " .. global.reloadPods.grids_count)

end

function reloadPod.GridLosesOwnerEntity(grid)
    local grid_id = 0
    for ids = 1 , global.reloadPods.last_grid do
        if global.reloadPods.grids[ids] and global.reloadPods.grids[ids].grid == grid then grid_id = ids break end
    end
    if grid_id > 0 then
        if grid.equipment[1] then
            global.reloadPods.grids[grid_id].owner = nil
            global.reloadPods.grids[grid_id].unit = 0
           -- game.print("A grid lost its inventory connection, because it's owner was put in the box or dropped on the ground. Grid's index: " .. grid_id)
        else
            if global.reloadPods.grids[grid_id].weapons and global.reloadPods.grids[grid_id].weapons[1] then
                --game.print("We've got a problem - lost pods in array")
            end
            global.reloadPods.grids[grid_id] = nil
            global.reloadPods.grids_count = global.reloadPods.grids_count - 1
            --game.print("Grid is empty and lost inventory link - will be destroyed. It's index was: " .. grid_id .. " Grid count now is: " .. global.reloadPods.grids_count)
        end
    end
end

function reloadPod.DrivingState(player)
end

function reloadPod.UnloadPods(entities, player, box)
    local grids_processed = 0
    local pods_unloaded = 0
    local grid
    local grid_id
    local tempInv = game.create_inventory(36)
    local tempStack
    local stack_unloaded
    local r = 0
    local d
    local vehInv
    for _, vehicle in pairs(entities) do
        if vehicle and vehicle.valid and vehicle.grid and vehicle.get_inventory(defines.inventory.car_trunk) and vehicle.get_inventory(defines.inventory.car_trunk).valid then
            grid = vehicle.grid
            vehInv = vehicle.get_inventory(defines.inventory.car_trunk)
            grid_id = 0
            for ids = 1 , global.reloadPods.last_grid do
                if global.reloadPods.grids[ids] and global.reloadPods.grids[ids].grid == grid then
                    grid_id = ids
                    break
                end
            end
            if grid_id > 0 then
                grids_processed = grids_processed + 1
                this_grid = global.reloadPods.grids[grid_id]
                if this_grid.weapons and this_grid.weapons[1] then
                    for _, weapon_id in pairs(this_grid.weapons) do
                        if global.reloadPods.weapons_equipment[weapon_id] and global.reloadPods.weapons_equipment[weapon_id].weapon
                        then
                            this_pod = global.reloadPods.weapons_equipment[weapon_id]
                            this_pod.sleepUntil = game.ticks_played + 7200
                            if this_pod.ammo == "empty" then
                                -- it's already empty
                            else
                                if this_pod.ammo_count > 0 then             -- were we in reloading process?
                                    r = this_pod.ammo_count
                                    this_pod.ammo_count = 0
                                    pos = this_pod.weapon.position
                                    this_grid.grid.take{ equipment = this_pod.weapon }
                                    this_pod.weapon = this_grid.grid.put{
                                        name = "turret-pod-" .. this_pod.type .. "-t" .. this_pod.tier .. "-" .. this_pod.ammo .. "-equipment",
                                        position = pos
                                    }
                                elseif this_pod.weapon.energy > 0 then      -- were we in a ready to shoot state with some ammo left?
                                    r = this_pod.weapon.energy
                                    this_pod.weapon.energy = 0
                                else r = 0
                                end
                                pods_unloaded = pods_unloaded + 1
                                if r > 0 then
                                    --game.print("Unloaded " .. r .. " bullets from pod with index " .. weapon_id)
                                    stack_unloaded = tempInv.find_empty_stack()
                                    d = math.fmod(r, magazines[this_pod.type][this_pod.ammo])
                                    if d == 0 then d = magazines[this_pod.type][this_pod.ammo] end
                                    stack_unloaded.set_stack({
                                        name = this_pod.ammo,
                                        count = math.ceil(r / magazines[this_pod.type][this_pod.ammo] ),
                                        ammo = d
                                    })
                                end
                                this_pod.ammo = "empty"
                            end
                        else
                            --game.print("Not existing pod detected index : ".. weapon_id .. " in grid of index: " .. grid_id)
                            -- global.reloadPods.weapons_equipment[weapon_id] = nil
                        end
                    end
                    tempInv.sort_and_merge()
                    for i=1, #tempInv do
                        stack_unloaded = tempInv[i]
                        if stack_unloaded and stack_unloaded.valid_for_read then
                            r = 0
                            tempStack, r = vehInv.find_item_stack(stack_unloaded.name)
                            if r and r > 0 then
                                for x=r,#vehInv do
                                    if vehInv[x].name == stack_unloaded.name and vehInv[x].transfer_stack(stack_unloaded) then break end
                                end
                            end
                            if stack_unloaded.valid_for_read and stack_unloaded.count > 0 then
                                r = 0
                                tempStack, r = vehInv.find_empty_stack()
                                if r and r > 0 then
                                    tempStack.transfer_stack(stack_unloaded)
                                else
                                    vehicle.surface.spill_item_stack(vehicle.position, stack_unloaded)
                                end
                            end
                        else break
                        end
                    end

                    tempInv.clear()
                end
            end

        end
    end
    tempInv.destroy()
    if player and box then
    local x = box.left_top.x + (box.right_bottom.x - box.left_top.x) / 2
    local y = box.left_top.y + (box.right_bottom.y - box.left_top.y) / 2
    player.create_local_flying_text({
--        color = options.color,
        position = {x,y},
        text = {"message.zd-unloadedPods", pods_unloaded, grids_processed},
      })
    end
-- debug loaded magazines types list section
--[[
 local typesOfPods = {"gun", "flame", "shotgun"}
 for _, podType in pairs(typesOfPods) do
    for magazine, size in pairs(magazines[podType]) do
        game.print(podType .. " class ammo type: " .. magazine)
    end
 end
]]
end

reloadPod.remote_interface = {

    unload_vehicle = function (vehicle, kill_grid)      -- unload all turret pods and optionally remove gamedata if vehicle to be destroyed
        reloadPod.UnloadPods({vehicle}, nil, nil)
        if kill_grid then
            reloadPod.GridIsDead(nil, vehicle.grid)
        end
    end,

    reload_vehicle = function (vehicle)                 -- Fulfill gamedata for vehicle and its turret pods with 3-seconds pods pause
        local grid_id = reloadPod.GridGetsOwner(vehicle)
        if grid_id and grid_id > 0 then
            local equipment_array = vehicle.grid.equipment
            if equipment_array and equipment_array[1] then
                local untilTick = game.ticks_played + 180
                for i = 1, #equipment_array do
                    if equipment_array[i].type == "active-defense-equipment" and equipment_array[i].name:match("turret%-pod%-(.+)%-t%d") then
                        reloadPod.AddWeapon(equipment_array[i], grid_id, untilTick)
                    end
                end
            end
        end
    end,

}

return reloadPod