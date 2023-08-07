
local grid
local found
for _, car in pairs(data.raw["car"]) do
    if car.equipment_grid and data.raw["equipment-grid"][car.equipment_grid] then
        found = false
        grid = data.raw["equipment-grid"][car.equipment_grid].equipment_categories
        if grid then
            for i = 1, #grid do
                if grid[i] == "zd-turret-pod-equipment-basic-category" then
                    found = true
                    break
                end
            end
        end
        if not found then
            if grid then table.insert(grid, "zd-turret-pod-equipment-basic-category") else grid = {"zd-turret-pod-equipment-basic-category"} end
        end
    end
end

if mods.RampantArsenal and settings.startup["rampant-arsenal-enableVehicle"].value then
    table.insert(data.raw["equipment-grid"]["nuclear-car-grid-rampant-arsenal"].equipment_categories, "zd-turret-pod-equipment-advanced-category")
    table.insert(data.raw["equipment-grid"]["nuclear-tank-grid-rampant-arsenal"].equipment_categories, "zd-turret-pod-equipment-advanced-category")
end


require ("prototypes.equipment")
require ("prototypes.equipment-flame")
require ("prototypes.equipment-shotgun")