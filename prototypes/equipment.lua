local energy_coeff = 1
if ( mods.Krastorio2 ) then energy_coeff = 1.8 end
local gunpod_t1_cap = 360*energy_coeff .. "KJ"
local gunpod_t2_cap = 2400*energy_coeff .. "KJ"

PodEqupment_Grids = {}
table.insert(PodEqupment_Grids, "armor") --TO-REPLACE-

if ( mods.Krastorio2 ) then
  table.insert(PodEqupment_Grids, "vehicle-motor")
end
if ( mods.bobvehicleequipment ) then
  table.insert(PodEqupment_Grids, "car")
  table.insert(PodEqupment_Grids, "tank")
end
local function generate_turret(tier, magazine)
  local gunshoot = require("__base__.prototypes.entity.sounds").gun_turret_gunshot
  local action
  local magazine_size = 1

  local gun_turret = data.raw['ammo-turret']['gun-turret']
  local prep_layer_1 = gun_turret.preparing_animation.layers[1]

  local function use_layer(layer) return
    {
      filename = layer.filename,
      width = layer.width,
      height = layer.height,
      priority = layer.priority,
      scale = (layer.scale or 1) * 1.2,
      x = 0 * (layer.width),
      y = 3 * (layer.height),
    }
  end

  local layers = {
    use_layer(prep_layer_1)
  }
  layers[1].hr_version = use_layer(prep_layer_1.hr_version)

  local magazine_localised_name
  local magazine_item = data.raw.ammo[magazine]
  if magazine_item then
    magazine_localised_name = magazine_item.localised_name
    -- log(serpent.block(magazine_item))

		-- icon of magazine
    if magazine_item.icon then
      table.insert(layers, {filename = magazine_item.icon, size = magazine_item.icon_size})
    else
      for _, icon_data in ipairs(magazine_item.icons) do
        icon_data = table.deepcopy(icon_data)
        icon_data.filename = icon_data.icon
        icon_data.size = icon_data.icon_size
        table.insert(layers, icon_data)
      end
    end

    magazine_size = magazine_item.magazine_size
    -- just copy the whole action. This means it will work with multiple complex effects like rampants incendiary ammo etc
    action = table.deepcopy(magazine_item.ammo_type.action)
  else
    table.insert(layers, {filename = '__core__/graphics/icons/alerts/ammo-icon-red.png', size = 64}) -- no ammo graphic
    magazine_localised_name = "item-name.no-ammo"
  end
  layers[2].scale = 0.5 * 64 / layers[2].size

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
      animation_speed = 0.5,
      --repeat_count = magazine_item.reload_time / 30
    })
    
    local function load_turret()
      return {
        type = "active-defense-equipment",
        name = "turret-pod-gun-t" .. tier .."-" .. magazine .. "-equipment-reload",
        localised_name = {
          "item-name.turret-pod-gun-t" .. tier .. "-equipment-info",
          magazine_localised_name or { "item-name." .. magazine }
        },
        localised_description = {"item-description.turret-pod-gun-t" .. tier .. "-equipment"},
        take_result = "turret-pod-gun-t" .. tier .."-empty-equipment",  --HERE IS THE POINT TO INSERT MULTIPLE magazine items
        sprite =
        {
          layers = load_layers
        },
        shape =
        {
          width = 2,
          height = 2,
          type = "full"
        },
        energy_source =
        {
          type = "electric",
          usage_priority = "primary-input",
          --buffer_capacity = magazine_item.reload_time .. "J",
          buffer_capacity = tier == 1 and gunpod_t1_cap or tier == 2 and gunpod_t2_cap,
          --input_flow_limit = "900000KW",
        },
        attack_parameters =
        {
          type = "projectile",
          ammo_category = "bullet",
          cooldown = 6,
          movement_slow_down_factor = 0.1,
          projectile_creation_distance = 1.39375,
          projectile_center = {0, -0.0875}, -- same as gun_turret_attack shift
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
          },
          ammo_type =
          {
            category = "bullet",
            --energy_consumption = ( 1 + magazine_item.reload_time ) .. "J",
            energy_consumption = "1000000KJ",
            action = action
          },
          range = 12,
          sound = gunshoot
        },
    
        automatic = false,
        categories = util.table.deepcopy( PodEqupment_Grids )
      }
    end
    
    	data:extend{ load_turret() }

  end 
  
  local turret =
  {
    type = "active-defense-equipment",
    name = "turret-pod-gun-t" .. tier .."-" .. magazine .. "-equipment",
    localised_name = {
    	"item-name.turret-pod-gun-t" .. tier .. "-equipment-info",
      magazine_localised_name or { "item-name." .. magazine }
    },
    localised_description = {"item-description.turret-pod-gun-t" .. tier .. "-equipment"},
    take_result = "turret-pod-gun-t" .. tier .."-empty-equipment",  --HERE IS THE POINT TO INSERT MULTIPLE magazine items
    sprite =
    {
      layers = layers
    },
    shape =
    {
      width = 2,
      height = 2,
      type = "full"
    },
    energy_source =
    {
      type = "electric",
      usage_priority = "secondary-input",
      buffer_capacity = magazine_size * tier .. "J",
      input_flow_limit = "0W",
    },
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "bullet",
      cooldown = tier == 1 and 8 or tier == 2 and 6,
      movement_slow_down_factor = 0.1,
      projectile_creation_distance = 1.39375,
      projectile_center = {0, -0.0875}, -- same as gun_turret_attack shift
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
      },
      ammo_type =
      {
        category = "bullet",
        energy_consumption = "1J",
        action = action
      },
      range = tier == 1 and 12 or tier == 2 and 16,
      sound = gunshoot
    },

    automatic = true,
    categories = util.table.deepcopy( PodEqupment_Grids )
  }
  if not data.raw.ammo[magazine] then
    turret.localised_name = {"item-name.turret-pod-gun-t" .. tier .. "-empty-equipment", { "description.no-ammo" } }
  end
  -- log (serpent.block( turret ))
  data:extend{ turret }
end

--data.raw.ammo["uranium-rounds-magazine"].reload_time = 2 * 60 -- 2 seconds

generate_turret(1, "empty")
generate_turret(2, "empty")
for ammo_name, ammo in pairs(data.raw.ammo) do
  -- log("[" .. ammo_name .. "].ammo_type.category" .. ammo.ammo_type.category)
  if ammo.ammo_type.category == "bullet" then
    generate_turret(1, ammo_name)
    generate_turret(2, ammo_name)
  elseif ammo.ammo_type.category == nil then
    for _,ammo_type in pairs( ammo.ammo_type ) do
      if ammo.ammo_type.category == "bullet" then
        generate_turret(1, ammo_name)
        generate_turret(2, ammo_name)
      end
    end
  end
end
