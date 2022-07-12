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
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-gun-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t2-equipment" },
		icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png",
		icon_size = 32,
		tint = { r=0.97, g = 0.77, b = 0.77, a = 1 },
		placed_as_equipment_result = "turret-pod-gun-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-gun-t3-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t3-equipment" },
		icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png",
		icon_size = 32,
		placed_as_equipment_result = "turret-pod-gun-t3-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},
-- "hidden", "hide-from-bonus-gui"
	{
		type = "item",
		name = "turret-pod-flame-t1-empty-equipment",
		localised_name = { "item-name.turret-pod-flame-t1-equipment" },
		icon = "__TurretPod__/graphics/icons/flamepod1_64_64.png",
		icon_size = 64,
		placed_as_equipment_result = "turret-pod-flame-t1-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},
	{
		type = "item",
		name = "turret-pod-flame-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-flame-t2-equipment" },
		icon = "__TurretPod__/graphics/icons/flamepod1_64_64.png",
		icon_size = 64,
		tint = { r=0.97, g = 0.77, b = 0.77, a = 1 },
		placed_as_equipment_result = "turret-pod-flame-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},



 {
	type = "selection-tool",
	name = "zd-ammo-unload",
	icon = "__TurretPod__/graphics/icons/minus-machine-gun-magazine-white-64.png",
	icon_size = 64,
	mipmaps = 1,
	subgroup = "military-equipment",
	order = "b[active-defense]-u[unload]",
	stack_size = 1,
	flags = { "not-stackable", "spawnable", "only-in-cursor" },
	show_in_library = false,

--mouse_cursor = "selection-tool-cursor",
	selection_color = {r=0.75, g=0.75},
	alt_selection_color = {g=1},
	reverse_selection_color = {b=0.75},
	selection_cursor_box_type = "entity",
	alt_selection_cursor_box_type = "entity",
	selection_mode = {"same-force", "entity-with-owner", "avoid-rolling-stock"},
	alt_selection_mode = {"same-force", "entity-with-owner", "avoid-rolling-stock"},
	--reverse_selection_mode = {"same-force", "entity-with-owner", "avoid-rolling-stock"},
	entity_type_filters = {"tank","car"},
	alt_entity_type_filters = {"tank","car"},
 },

 {
	type = "custom-input",
	name = "zd-ammo-unload",
	key_sequence = "ALT + M",
	action = "spawn-item",
	item_to_spawn = "zd-ammo-unload",
 },

 {
	type = "shortcut",
	name = "zd-ammo-unload",
	icon = { filename = "__TurretPod__/graphics/icons/minus-machine-gun-magazine-black-64.png", size = 64, mipmap_count = 1 },
	-- https://game-icons.net/1x1/delapouite/machine-gun-magazine.html
	-- CC BY 3.0 license
	action = "spawn-item",
	item_to_spawn = "zd-ammo-unload",
	associated_control_input = "zd-ammo-unload"
 }

})