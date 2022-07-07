data:extend(
{

	{
		type = "item",
		name = "turret-pod-gun-t1-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t1-equipment" },
		icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png",
		icon_size = 32,
		placed_as_equipment_result = "turret-pod-gun-t1-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-a[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-gun-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t2-equipment" },
		icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png",
		icon_size = 32,
		placed_as_equipment_result = "turret-pod-gun-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

-- "hidden", "hide-from-bonus-gui"

--[[
	{
		type = "item",
		name = "gun-turret-equipment",
		localised_name = { "item-name.personal-turret-equipment" },
		icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png",
		icon_size = 32,
		placed_as_equipment_result = "personal-turret-no-magazine-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-a[personal-turret-equipment]",
		stack_size = 10
  },
]]
})