data:extend(
{

	{
		type = "item",
		name = "turret-pod-gun-t1-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t1-equipment" },
		icons = {
			{ icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/1.png", icon_size = 64, scale = 0.5 }
		},
		icon_size = 32,
		place_as_equipment_result = "turret-pod-gun-t1-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-gun-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-gun-t2-equipment" },
		icons = {
			{ icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/2.png", icon_size = 64, scale = 0.5 }
		},
		icon_size = 32,
		place_as_equipment_result = "turret-pod-gun-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

-- "hidden", "hide-from-bonus-gui"
	{
		type = "item",
		name = "turret-pod-flame-t1-empty-equipment",
		localised_name = { "item-name.turret-pod-flame-t1-equipment" },
		icons = {
			--{ icon = "__TurretPod__/graphics/icons/flamepod1_64.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/personal-flamethrower-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/1.png", icon_size = 64, scale = 0.5 }
		},
		place_as_equipment_result = "turret-pod-flame-t1-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},
	{
		type = "item",
		name = "turret-pod-flame-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-flame-t2-equipment" },
		icons = {
			--{ icon = "__TurretPod__/graphics/icons/flamepod2_64.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/personal-flamethrower-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/2.png", icon_size = 64, scale = 0.5 }
		},
		place_as_equipment_result = "turret-pod-flame-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-shotgun-t1-empty-equipment",
		localised_name = { "item-name.turret-pod-shotgun-t1-equipment" },
		icons = {
			{ icon = "__TurretPod__/graphics/icons/personal-shotgun-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/1.png", icon_size = 64, scale = 0.5 },
		},
		icon_size = 64,
		place_as_equipment_result = "turret-pod-shotgun-t1-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},

	{
		type = "item",
		name = "turret-pod-shotgun-t2-empty-equipment",
		localised_name = { "item-name.turret-pod-shotgun-t2-equipment" },
		icons = {
			{ icon = "__TurretPod__/graphics/icons/personal-shotgun-equipment.png", icon_size = 64 },
			{ icon = "__TurretPod__/graphics/icons/tiers/2.png", icon_size = 64, scale = 0.5 },
		},
		icon_size = 64,
		place_as_equipment_result = "turret-pod-shotgun-t2-empty-equipment",
		subgroup = "military-equipment",
		order = "b[active-defense]-b[turret-pod]",
		stack_size = 10
	},


})

--if ( mods.RampantArsenal ) then
	data:extend ({
		{
			type = "item",
			name = "turret-pod-gun-t3-empty-equipment",
			localised_name = { "item-name.turret-pod-gun-t3-equipment" },
			icons = {
				{ icon = "__TurretPod__/graphics/icons/personal-turret-equipment.png", icon_size = 64 },
				{ icon = "__TurretPod__/graphics/icons/tiers/3.png", icon_size = 64, scale = 0.5 },
			},
			icon_size = 32,
			place_as_equipment_result = "turret-pod-gun-t3-empty-equipment",
			subgroup = "military-equipment",
			order = "b[active-defense]-b[turret-pod]",
			stack_size = 10
		},
		{
			type = "item",
			name = "turret-pod-shotgun-t3-empty-equipment",
			localised_name = { "item-name.turret-pod-shotgun-t3-equipment" },
			icons = {
				{ icon = "__TurretPod__/graphics/icons/personal-shotgun-equipment.png", icon_size = 64 },
				{ icon = "__TurretPod__/graphics/icons/tiers/3.png", icon_size = 64, scale = 0.5 },
			},
			icon_size = 64,
			place_as_equipment_result = "turret-pod-shotgun-t3-empty-equipment",
			subgroup = "military-equipment",
			order = "b[active-defense]-b[turret-pod]",
			stack_size = 10
		},
	})
--end

local entities_filter = {"tank","car","spider-vehicle","cargo-wagon"}
if settings.startup["zd-PlayerArmorSupport"].value then table.insert(entities_filter, "character") end

data:extend ({
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
	hidden = true,
	show_in_library = false,

	select = {
		border_color = {r=0.75, g=0.75},
		cursor_box_type = "entity",
		mode = {"same-force", "entity-with-owner"},
		entity_type_filters = entities_filter,
	},
	alt_select = {
		border_color = {g=1},
		cursor_box_type = "entity",
		mode = {"same-force", "entity-with-owner"},
		entity_type_filters = entities_filter,
	},
	reverse_select = {
		border_color = {b=0.75},
		cursor_box_type = "entity",
		mode = {"same-force", "entity-with-owner"},
		entity_type_filters = entities_filter,
	}
--mouse_cursor = "selection-tool-cursor",
 },

 {
	type = "custom-input",
	name = "zd-ammo-unload",
	key_sequence = "ALT + U",
	action = "spawn-item",
	item_to_spawn = "zd-ammo-unload",
 },

 {
	type = "shortcut",
	name = "zd-ammo-unload",
	icon = "__TurretPod__/graphics/icons/minus-machine-gun-magazine-black-64.png",
	small_icon = "__TurretPod__/graphics/icons/minus-machine-gun-magazine-black-64.png",
	-- https://game-icons.net/1x1/delapouite/machine-gun-magazine.html
	-- CC BY 3.0 license
	action = "spawn-item",
	item_to_spawn = "zd-ammo-unload",
	associated_control_input = "zd-ammo-unload"
 }

})