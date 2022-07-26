local InitGrids = {}

InitGrids.energy_coeff = 1
if ( mods.Krastorio2 ) then InitGrids.energy_coeff = 1.8 end

InitGrids.PodEqupment_Grids = {}
table.insert(InitGrids.PodEqupment_Grids, "armor") --TO-REPLACE-

if ( mods.Krastorio2 ) then
  table.insert(InitGrids.PodEqupment_Grids, "vehicle-motor")
end
if ( mods.bobvehicleequipment ) then
  table.insert(InitGrids.PodEqupment_Grids, "car")
  table.insert(InitGrids.PodEqupment_Grids, "tank")
end

InitGrids.PodFinal_Grids = {}
if ( mods.RampantArsenal ) then
table.insert(InitGrids.PodFinal_Grids, "adv-generator")
end

return InitGrids