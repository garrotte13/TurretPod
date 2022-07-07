-- old Zdenek's:
-- "personal%-turret%-(.+)%-equipment"
-- "personal%-turret%-(.+)%-equipment%-reload%-(%d+)"
local magazine = "firearm-magazine" or "piercing-rounds-magazine"
local size = 25
local name = "personal-turret-" .. magazine .. "-equipment-reload-" .. size
local reload_name = "personal-turret-" .. magazine .. "-equipment-reload-" --after removing mag size
local empty_turret = "personal-turret-no-magazine-equipment"

-- new names convention:
local weapon
local new_pattern = "turret%-pod%-(.+)%-t%d%-(.+)%-equipment"
if weapon.name:match("turret%-pod%-(.+)%-t%d") then local detected = true end
-- turret-pod-gun-t1-empty-equipment
-- turret-pod-gun-t2-empty-equipment
-- turret-pod-gun-t3-empty-equipment
-- turret-pod-flame-t1-empty-equipment
-- turret-pod-flame-t2-flamethrower-ammo-equipment
-- turret-pod-shotgun-t1-empty-equipment
-- turret-pod-shotgun-t2-empty-equipment

-- turret-pod-gun-t1-empty-equipment-reload