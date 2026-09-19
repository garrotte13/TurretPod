--local energy_coeff = 1
local item_sounds = require("__base__.prototypes.item_sounds")
local gunpods = {
    --cap = {12000*energy_coeff .. "kJ", 16000*energy_coeff .. "kJ", 22000*energy_coeff .. "kJ", 28000*energy_coeff .. "kJ"},
    --width = {3, 4, 5},
    mag = {1, 1, 1, 1},
    --cooldown = {70, 60, 60},
    --range = {11, 14, 16},
    --min_range = {0, 0, 2},
    --dmg = {1.1, 1.3, 1.5},
    --grids = { {"zd-turret-pod-equipment-basic-category"}, {"zd-turret-pod-equipment-basic-category"}, {"zd-turret-pod-equipment-basic-category"},  {"zd-turret-pod-equipment-advanced-category"} }
  }

if not data.raw["ammo"]["bob-plasma-mn"] then
  data:extend({
    {
      type = "ammo-category",
      name = "bob-plasma-category-mn",
    },
    {
      type = "ammo",
      name = "bob-plasma-mn",
      icon = "__TurretPod__/graphics/icons/part-specimin-1.png",
      icon_size = 64,
      magazine_size = 1,
      subgroup = "bob-ammo",
      order = "g[plasma]",
      stack_size = 50,
      ammo_category = "bob-plasma-category-mn",
      ammo_type = {
          category = "bob-plasma-category-mn",
          target_type = "position",
          clamp_position = true,
          action = 
          {
              type = "direct",
              action_delivery = {
                {
                  type = "projectile",
                  projectile = "bob-plasma-projectile",
                  starting_speed = 1,
                  direction_deviation = 0,
                  range_deviation = 0,
                  max_range = 50 * 2,
                },
              }
          }
      }
    },
    {
      type = "recipe",
      name = "bob-plasma-mn",
      energy_required = 20,
      category = "advanced-crafting",
      enabled = false,
      ingredients = {
          {type = "item", name = "bob-cobalt-steel-alloy", amount = 2},
          {type = "item", name = "bob-aluminium-plate", amount = 2},
          { type = "item", name = "advanced-circuit", amount = 1 },
          {type = "fluid", name = "bob-nitrogen", amount = 45},
          {type = "item", name = "bob-alien-artifact", amount = 1},
          {type = "item", name = "explosives", amount = 1}
      },
      results = { { type = "item", name = "bob-plasma-mn", amount = 1 } },
    },

  })
  table.insert(data.raw.technology["bob-vehicle-big-turret-equipment-1"].effects, { recipe = "bob-plasma-mn", type = "unlock-recipe" })
end


local function generate_turret(tier, magazine)

    local old_plasma = data.raw["active-defense-equipment"]["bob-vehicle-big-turret-equipment-".. tier]
    local load_plasma = table.deepcopy(old_plasma)
    load_plasma.name = "turret-pod-bobplasma-t" .. tier .."-" .. magazine .. "-equipment-reload"
    load_plasma.attack_parameters.ammo_type.energy_consumption = "1000000kJ"
    load_plasma.take_result = old_plasma.name
    load_plasma.automatic = false
    local sprite_basic = table.deepcopy(load_plasma.sprite)
    load_plasma.sprite.layers =  {
      sprite_basic,
      {
        filename = '__core__/graphics/icons/alerts/no-building-material-icon.png',
        size = 64,
        --scale = 0.50,
        shift = { x = 16, y = 16 },
        run_mode = "forward-then-backward",
        frame_count = 2,
        animation_speed = 2,
      }
    }
    load_plasma.localised_name = {"item-name.bob-vehicle-big-turret-equipment-" .. tier}
    load_plasma.localised_description = {"item-description.bob-vehicle-big-turret-equipment-" .. tier}
    local magazine_size = 1
    old_plasma.energy_source.input_flow_limit = "0W"
    old_plasma.energy_source.usage_priority = "secondary-input"
    --old_plasma.attack_parameters.ammo_type.energy_consumption =
    old_plasma.energy_source.buffer_capacity = old_plasma.attack_parameters.ammo_type.energy_consumption
    --old_plasma.energy_source.buffer_capacity = magazine_size * gunpods.mag[tier] .. "J"
    --old_plasma.attack_parameters.ammo_type.energy_consumption = "1J"
    old_plasma.attack_parameters.health_penalty = -10
    --old_plasma.automatic = false
    
    data:extend{ load_plasma }
end

generate_turret(1, "bob-plasma-mn")
generate_turret(2, "bob-plasma-mn")
generate_turret(3, "bob-plasma-mn")
generate_turret(4, "bob-plasma-mn")


--[[
data:extend({
{
  type = "capsule",
  name = "discharge-bob-cannon-remote",
  icon = "__base__/graphics/icons/discharge-defense-equipment-controller.png",
  flags = {"only-in-cursor", "not-stackable", "spawnable"},
  auto_recycle = false,
  capsule_action =
  {
    type = "equipment-remote",
    equipment = "bob-vehicle-big-turret-equipment-1"
  },
  subgroup = "spawnables",
  order = "b[active-defense]-b[discharge-defense-equipment]-b[remote]",
  inventory_move_sound = item_sounds.electric_small_inventory_move,
  pick_sound = item_sounds.electric_small_inventory_pickup,
  drop_sound = item_sounds.electric_small_inventory_move,
  stack_size = 1
},
{
  type = "shortcut",
  name = "bob-cannon-strike-remote",
  order = "e[spidertron-remote]",
  action = "spawn-item",
  localised_name = {"shortcut.make-bob-discharge-remote"},
  associated_control_input = "give-bob-cannon-remote",
  technology_to_unlock = "discharge-defense-equipment",
  unavailable_until_unlocked = true,
  item_to_spawn = "discharge-bob-cannon-remote",
  icon = "__base__/graphics/icons/shortcut-toolbar/mip/discharge-defense-remote-x56.png",
  icon_size = 56,
  small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/discharge-defense-remote-x30.png",
  small_icon_size = 30
},
{
  type = "custom-input",
  name = "give-bob-cannon-remote",
  key_sequence = "ALT + Y",
  consuming = "game-only",
  item_to_spawn = "discharge-bob-cannon-remote",
  action = "spawn-item"
},
})
]]