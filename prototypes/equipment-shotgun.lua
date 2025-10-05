local energy_coeff = 1
if ( mods.Krastorio2 ) or ( mods.bobvehicleequipment ) then energy_coeff = 1.5 end

local gunpods = {
  cap = {5000*energy_coeff .. "kJ", 28000*energy_coeff .. "kJ", 238000*energy_coeff .. "kJ"},
  width = {3, 4, 5},
  mag = {1, 2, 5},
  cooldown = {70, 60, 60},
  range = {11, 14, 16},
  min_range = {0, 0, 2},
  dmg = {1.1, 1.3, 1.5},
  grids = { {"zd-turret-pod-equipment-basic-category"}, {"zd-turret-pod-equipment-basic-category"}, {"zd-turret-pod-equipment-basic-category"},  {"zd-turret-pod-equipment-advanced-category"} }
}


local function generate_turret(tier, magazine)
  local gunshoot = require("__base__.prototypes.entity.sounds").gun_turret_gunshot
  local action
  local magazine_size = 1

  local layers = {
    {
      filename = "__TurretPod__/graphics/equipment/personal-shotgun-defense-equipment.png",
      width = 128,
      height = 128,
      priority = "medium",
      scale = 1,
    }
  }

  local magazine_localised_name
  local magazine_item = data.raw.ammo[magazine]
  if magazine_item then
    magazine_localised_name = magazine_item.localised_name
    -- log(serpent.block(magazine_item))

		-- icon of magazine
    if magazine_item.icon then
      table.insert(layers, {filename = magazine_item.icon, size = magazine_item.icon_size or 64, scale = 0.5})
    else
      for _, icon_data in ipairs(magazine_item.icons) do
        icon_data = table.deepcopy(icon_data)
        icon_data.filename = icon_data.icon
        icon_data.size = icon_data.icon_size
        table.insert(layers, icon_data)
      end
    end

    magazine_size = magazine_item.magazine_size or magazine_size
    -- just copy the whole action. This means it will work with multiple complex effects like rampants incendiary ammo etc
    action = table.deepcopy(magazine_item.ammo_type.action)
  else
    table.insert(layers, {filename = '__core__/graphics/icons/alerts/ammo-icon-red.png', size = 64, scale = 0.5}) -- no ammo graphic
    magazine_localised_name = "item-name.no-ammo"
  end
  layers[2].scale = 1 * 64 / layers[2].size

  for i = 3, #layers do
    layers[i].scale = (layers[i].scale or 1) * 0.5 * 64 / layers[2].size -- YES, it's supposed to be layer[2].size and not layer[i].size
    -- scale is bugged, so we need a blank scale 1 image first for icons.
    -- https://forums.factorio.com/viewtopic.php?f=7&t=71480&p=433700&hilit=scale#p433700
    -- which means all other icons will be rescaled according to this value.

    -- layers[i].shift = mul(layers[i].shift or {0, 0}, layers[i].scale)
    -- If they are shifted we might need to adjust those values too by scaling them.
  end
  if magazine_item -- no-magazine check
      --and magazine_item.reload_time
      --and magazine_item.reload_time > 0
    then
    local load_layers = util.table.deepcopy(layers)
    table.insert(load_layers,{
      filename = '__core__/graphics/icons/alerts/no-building-material-icon.png',
      size = 64,
      scale = 0.50,
      shift = { x = 16, y = 16 },
      run_mode = "forward-then-backward",
      frame_count = 2,
      --animation_speed = 30,
      --repeat_count = magazine_item.reload_time / 30
      animation_speed = 2,
      --repeat_count = magazine_item.reload_time / 30
    })
    
    local function load_turret()
      return {
        type = "active-defense-equipment",
        name = "turret-pod-shotgun-t" .. tier .."-" .. magazine .. "-equipment-reload",
        localised_name = {
          "item-name.turret-pod-shotgun-t" .. tier .. "-equipment-info",
          magazine_localised_name or { "item-name." .. magazine }
        },
        localised_description = {"item-description.turret-pod-shotgun-t" .. tier .. "-equipment"},
        take_result = "turret-pod-shotgun-t" .. tier .."-empty-equipment",  --HERE IS THE POINT TO INSERT MULTIPLE magazine items
        sprite =
        {
          layers = load_layers
        },
        shape =
        {
          width = gunpods.width[tier],
          --height = gunpods.width[tier],
          height = 2,
          type = "full"
        },
        energy_source =
        {
          type = "electric",
          usage_priority = "primary-input",
          buffer_capacity = gunpods.cap[tier]
          --input_flow_limit = "900000KW",
        },
        attack_parameters =
        {
          type = "projectile",
          ammo_category = "shotgun-shell",
          cooldown = gunpods.cooldown[tier],
          movement_slow_down_factor = 0.5,
          projectile_creation_distance = 0.75,
           ammo_type =
          {
            category = "shotgun-shell",
            --energy_consumption = ( 1 + magazine_item.reload_time ) .. "J",
            energy_consumption = "1000000kJ",
            action = action
          },
          range = 1,
          sound = gunshoot
        },
    
        automatic = false,
        categories = gunpods.grids[tier]
      }
    end
    
    	data:extend{ load_turret() }

  end 
  
  local turret =
  {
    type = "active-defense-equipment",
    name = "turret-pod-shotgun-t" .. tier .."-" .. magazine .. "-equipment",
    localised_name = {
    	"item-name.turret-pod-shotgun-t" .. tier .. "-equipment-info",
      magazine_localised_name or { "item-name." .. magazine }
    },
    localised_description = {"item-description.turret-pod-shotgun-t" .. tier .. "-equipment"},
    take_result = "turret-pod-shotgun-t" .. tier .."-empty-equipment",  --HERE IS THE POINT TO INSERT MULTIPLE magazine items
    sprite =
    {
      layers = layers
    },
    shape =
    {
      width = gunpods.width[tier],
      --height = gunpods.width[tier],
      height = 2,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      buffer_capacity = magazine_size * gunpods.mag[tier] .. "J",
      input_flow_limit = "0W",
    },
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "shotgun-shell",
      cooldown = gunpods.cooldown[tier],
      movement_slow_down_factor = 0.5,
      projectile_creation_distance = 0.95,
      gun_barrel_length = 0.75,
      --[[projectile_center = {0, -0.0875}, -- same as gun_turret_attack shift
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {-0.0625, 0},
        creation_distance = -1.925,
        starting_frame_speed = 0.2,
        starting_frame_speed_deviation = 0.1
      }, ]]
      ammo_type =
      {
        category = "shotgun-shell",
        energy_consumption = "1J",
        action = action
      },
      range = gunpods.range[tier],
      min_range = gunpods.min_range[tier],
      damage_modifier = gunpods.dmg[tier],
      sound =
      --[[{
        {
            filename = "__base__/sound/pump-shotgun.ogg",
            volume = 0.5
        }
      }]]
-- if we want changing sounds in cycle
      {
        {
          filename = "__base__/sound/fight/pump-shotgun-1.ogg",
          volume = 0.37
        },
        {
          filename = "__base__/sound/fight/pump-shotgun-2.ogg",
          volume = 0.37
        },
        {
          filename = "__base__/sound/fight/pump-shotgun-3.ogg",
          volume = 0.37
        },
        {
          filename = "__base__/sound/fight/pump-shotgun-4.ogg",
          volume = 0.37
        },
        {
          filename = "__base__/sound/fight/pump-shotgun-5.ogg",
          volume = 0.37
        }
      }

    },

    automatic = true,
    categories = gunpods.grids[tier]
  }
  if not data.raw.ammo[magazine] then
    turret.localised_name = {"item-name.turret-pod-shotgun-t" .. tier .. "-empty-equipment", { "description.no-ammo" } }
  end
  -- log (serpent.block( turret ))
  data:extend{ turret }
end

generate_turret(1, "empty")
generate_turret(2, "empty")
--if ( mods.RampantArsenal ) then
  generate_turret(3, "empty")
--end
for ammo_name, ammo in pairs(data.raw.ammo) do
  -- log("[" .. ammo_name .. "].ammo_type.category" .. ammo.ammo_type.category)
  if ammo.ammo_category == "shotgun-shell" then
    generate_turret(1, ammo_name)
    generate_turret(2, ammo_name)
    --if ( mods.RampantArsenal ) then
      generate_turret(3, ammo_name)
    --end
  elseif ammo.ammo_category == nil then
    for _,ammo_type in pairs( ammo.ammo_type ) do
      if ammo.ammo_category == "shotgun-shell" then
        generate_turret(1, ammo_name)
        generate_turret(2, ammo_name)
        --if ( mods.RampantArsenal ) then
          generate_turret(3, ammo_name)
        --end
      end
    end
  end
end
