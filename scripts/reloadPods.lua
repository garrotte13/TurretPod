
local reloadPods = {}
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

function reloadPods.Init()

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
    reloadPods.AddMagazines()
    --[[
    reloadPods.AllowChangeAmmo = settings.global["zd-AllowChangeAmmo"].value
    global.magazines = {}
    

    global.weapons_equipment = {}
    global.equipped_weapons_count = 0
    global.equipped_weapon_id = 1
    global.equipped_weapon_last = 1

    global.grids = {}
    global.last_grid = 1
    global.grids_count = 0
]]
    weapons_equipment = global.reloadPods.weapons_equipment
    equipped_weapons_count = global.reloadPods.equipped_weapons_count
    equipped_weapon_id = global.reloadPods.equipped_weapon_id
    equipped_weapon_last = global.reloadPods.equipped_weapon_last

    grids = global.reloadPods.grids
    last_grid = global.reloadPods.last_grid
    grids_count = global.reloadPods.grids_count

    magazines = global.reloadPods.magazines

end

function reloadPods.OnLoad()

    weapons_equipment = global.reloadPods.weapons_equipment
    equipped_weapons_count = global.reloadPods.equipped_weapons_count
    equipped_weapon_id = global.reloadPods.equipped_weapon_id
    equipped_weapon_last = global.reloadPods.equipped_weapon_last

    grids = global.reloadPods.grids
    last_grid = global.reloadPods.last_grid
    grids_count = global.reloadPods.grids_count

    magazines = global.reloadPods.magazines
end

function reloadPods.EveryTick()

    if weapons_equipment[equipped_weapon_id] and weapons_equipment[equipped_weapon_id].sleepUntil < game.ticks_played then
        this_pod = weapons_equipment[equipped_weapon_id]
        if grids[this_pod.grid_id].grid and grids[this_pod.grid_id].grid.valid then
            this_grid = grids[this_pod.grid_id]
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
                            for magazine, size in pairs(magazines) do
                                if reloadPods.TryLoadAmmo(magazine, inv, this_grid.grid, this_pod) then break end
                            end
                            if this_pod.ammo_count == 0 then this_pod.sleepUntil = game.ticks_played + 360 end -- no ammo found of any type in inventory. Pls someone kill this looser.
                        else
                            if not reloadPods.TryLoadAmmo(this_pod.ammo, inv, this_grid.grid, this_pod) then
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
        else reloadPods.GridIsDead(this_pod.grid_id, nil) end
    end
    if equipped_weapon_id >= equipped_weapon_last then equipped_weapon_id = 1
     else equipped_weapon_id = equipped_weapon_id + 1 end
end

function reloadPods.TryLoadAmmo(ammo_wanted, inventory, GridEntity, PodMember)
    local ammo_stack = inventory.find_item_stack(ammo_wanted)
    local stacks_needed = PodMember.tier    --TO-DO- replace with constants table value
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
            PodMember.ammo_count = PodMember.ammo_count + (stacks_needed - 1) * magazines[ammo_wanted]
        else
            stacks_needed = stacks_needed - ammo_stack.count
            PodMember.ammo_count = PodMember.ammo_count + (ammo_stack.count - 1) * magazines[ammo_wanted]
            inventory.remove(ammo_stack)
            if stacks_needed > 0 then   -- if we still can take more ammo in one reload of high-tier turret pod
                local ammo_stack2 = inventory.find_item_stack(ammo_wanted)  -- and inventory has another stack of that ammo
                if ammo_stack2 and ammo_stack2.count > 0 then
                    if ammo_stack2.count > stacks_needed then
                        PodMember.ammo_count = PodMember.ammo_count + stacks_needed * magazines[ammo_wanted]
                        ammo_stack2.count = ammo_stack2.count - stacks_needed
                    else
                        PodMember.ammo_count = PodMember.ammo_count + ammo_stack2.count * magazines[ammo_wanted]
                        inventory.remove(ammo_stack2)
                    end
                end
            end
        end
        game.print("Loading bullets count: " .. PodMember.ammo_count .. "  While capacity buffer is: " .. PodMember.capacity .. "Pod index: ".. equipped_weapon_id)
    else return false end
    return true
end

function reloadPods.AddWeapon(weapon, grid_id)
    local weapon_type
    local weapon_tier
    local weapon_ammo
    weapon_type, weapon_tier, weapon_ammo = string.match(weapon.name, "turret%-pod%-(.+)%-t(%d)%-(.+)%-equipment")

    local r = 0
    for ids_num = 1, equipped_weapon_last do
        if not weapons_equipment[ids_num] then r = ids_num break end
    end
    if r == 0 then
        game.print ("Last member of equipped pods was removed incorrectly! Total pods count: " .. equipped_weapons_count .. ". First free pod index: " .. equipped_weapon_last)
        equipped_weapon_last = equipped_weapon_last + 1
        r = equipped_weapon_last
    end

    weapons_equipment[r] = {
        weapon = weapon,
        type = weapon_type,
        ammo = weapon_ammo,
        ammo_count = 0,
        sleepUntil = 0,
        capacity = 0,
        tier = tonumber(weapon_tier),
        grid_id = grid_id
    }
    table.insert(grids[grid_id].weapons, r)
    if r == equipped_weapon_last then equipped_weapon_last = equipped_weapon_last + 1 end
    equipped_weapons_count = equipped_weapons_count + 1
    game.print("Installed pod: " .. weapon.name .. " Pod's index: " .. r .. " Grid index: " .. grid_id)
    game.print("First free index is ".. equipped_weapon_last)
    game.print("Total amount of installed turret pods in all active grids: " .. equipped_weapons_count)

end

function reloadPods.NewEquipment(weapon, grid)
    if weapon.type == "active-defense-equipment" and weapon.name:match("turret%-pod%-(.+)%-t%d") then
        local grid_id = 0
        local r = 0
        for ids = 1 , last_grid do
            if not grids[ids] then
                if r == 0 then r = ids end
            elseif grids[ids].grid == grid then
                grid_id = ids
                break
            end
        end
        if grid_id == 0 then
            if r == 0 then
                game.print ("Last member of grids was removed incorrectly! Total grids count: " .. grids_count .. ". First free grid order number: " .. last_grid)
                last_grid = last_grid + 1
                r = last_grid
            end
            grid_id = r
            grids[grid_id] = {
                grid = grid,
                weapons = {},
                owner = nil,
                inv_type = nil,
            }
            if r == last_grid then last_grid = last_grid + 1 end
            grids_count = grids_count + 1
            game.print("A new grid added. Its index: " .. grid_id)
            game.print("Total amount of active grids: " .. grids_count .. ". Last index in array: " .. last_grid)
        end
        reloadPods.AddWeapon(weapon, grid_id)
    end
end

function reloadPods.RemoveEquipment(weapon_name, grid, removed_count, player) -- several single-type weapons can be removed in one Ctrl+click
    if weapon_name:match("turret%-pod%-(.+)%-t%d") then
        local grid_id = 0
        for ids = 1 , last_grid do
            if grids[ids] and grids[ids].grid == grid then grid_id = ids break end
        end
        if grid_id > 0 then
            local to_remove = {}
            local to_keep = {}
            local i = 0
            for _, weapon_id in pairs(grids[grid_id].weapons) do
                if weapons_equipment[weapon_id].weapon and weapons_equipment[weapon_id].weapon.valid then
                    table.insert(to_keep, weapon_id)
                else
                    i = i + 1
                    to_remove[i] = weapon_id
                end
            end
            if i < removed_count then
                game.print("Some turret pods were lost. Turret pods count to remove: " .. i-1 .. " While player removed: " .. removed_count)
            end
            if i > 0 then
                grids[grid_id].weapons = to_keep
                for ids = 1, i do
                    game.print("Removed " .. weapon_name .. " Pod index:" .. to_remove[ids])
--                  local ammo_count = weapons_equipment[to_remove[ids]].ammo_count
--                    if ammo_count > 0 then
--                        game.print("Amount of lost ammo units (bullets, shells, fluid units) is: " .. ammo_count)
--                    end
                    weapons_equipment[to_remove[ids]] = nil
                end
                equipped_weapons_count = equipped_weapons_count - i
            else game.print("No turret pods at all were found to remove!")
            end
        else
            game.print("Grid was not found! Can't remove turret pods from it.")
        end
        game.print("Total amount of installed pods in all active grids: " .. equipped_weapons_count)
    end
end

function reloadPods.AddMagazines()
    for item_name, item_prototype in pairs(game.get_filtered_item_prototypes{{filter = 'type', type = 'ammo'}}) do
        if game.equipment_prototypes["turret-pod-gun-t2-" .. item_name .. "-equipment"] then
            global.reloadPods.magazines[item_name] = item_prototype.magazine_size
        end
    end
end

function reloadPods.GridGetsOwner(entity)
    local grid
    if entity and entity.valid and entity.grid and entity.get_inventory(defines.inventory.car_trunk) then grid = entity.grid else return end
    local grid_id = 0
    local r = 0
    for ids = 1 , last_grid do
        if not grids[ids] then
            if r == 0 then r = ids end
        elseif grids[ids].grid == grid then
            grid_id = ids
            break
        end
    end
    if grid_id == 0 then
        if r == 0 then
            game.print ("Last member of grids was removed incorrectly! Total grids count: " .. grids_count .. ". First free (but it's not free!) grid order number: " .. last_grid)
            last_grid = last_grid + 1
            r = last_grid
        end
        grid_id = r
        grids[grid_id] = {
            grid = grid,
            weapons = {},
            owner = nil,
            inv_type = defines.inventory.car_trunk,
        }
        if r == last_grid then last_grid = last_grid + 1 end
        grids_count = grids_count + 1
        game.print("A new grid added. Its index: " .. grid_id)
        game.print("Total amount of active grids: " .. grids_count .. ". Last index in array: " .. last_grid)

-- TO DO -- Find and Insert missing turret pods IF ANY are missing! Why can it happen?? Who inserted them? Expecting grid is to have no turret pods.

    end
    grids[grid_id].owner = entity
    game.print("A grid got an inventory connected. Grid's index: " .. grid_id)
end

function reloadPods.GridIsDead(grid_id, grid) -- one of two parameters is always nil
    if grid then
        grid_id = 0
        for ids = 1 , last_grid do
            if grids[ids] and grids[ids].grid == grid then grid_id = ids break end
        end
        if grid_id == 0 then
            return
        else
            game.print("A grid was removed due to death of its owner.")
        end
    else game.print("A grid was removed, because it was destroyed with/without its owner some time ago.") end
    local i
    if grids[grid_id].weapons then
        for _, weapon_id in pairs(grids[grid_id].weapons) do
            i = grids[grid_id].weapons[weapon_id]
            game.print("Removed: turret-pod-" .. weapons_equipment[i].type .. "-t" .. weapons_equipment[i].tier .. "-" .. weapons_equipment[i].ammo .. "-equipment. Pod's index: " .. i)
            weapons_equipment[i] = nil
            equipped_weapons_count = equipped_weapons_count - 1
        end
    end
    grids[grid_id] = nil
    grids_count = grids_count - 1
    game.print("Grid index was: " .. grid_id .. " Grid count now is: " .. grids_count)

end

function reloadPods.GridLosesOwnerEntity(grid)
    local grid_id = 0
    for ids = 1 , last_grid do
        if grids[ids] and grids[ids].grid == grid then grid_id = ids break end
    end
    if grid_id > 0 then
        if grid.equipment[1] then
            grids[grid_id].owner = nil
            game.print("A grid lost its inventory connection, because it's owner was put in the box or dropped on the ground. Grid's index: " .. grid_id)
        else
            if grids[grid_id].weapons[1] then
                game.print("We've got a problem - lost pods in array")
            end
            grids[grid_id] = nil
            grids_count = grids_count - 1
            game.print("Grid is empty and lost inventory link - will be destroyed. It's index was: " .. grid_id .. " Grid count now is: " .. grids_count)
        end
    end
end

function reloadPods.DrivingState(player)
end

return reloadPods