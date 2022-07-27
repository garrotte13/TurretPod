data:extend(
{
  {
    type = "technology",
    name = "turret-pod-gun1",
    icons = {
			{ icon = "__TurretPod__/graphics/technology/personal-turret-equipment.png", icon_size = 128 },
			{ icon = "__TurretPod__/graphics/icons/tiers/1.png", icon_size = 64, scale = 1, shift = {30, -40} },
		},
    icon_size = 128,
    prerequisites = { "modular-armor", "gun-turret", "tank" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-gun-t1-empty-equipment"
      },
      {
        type = "unlock-recipe",
        recipe = "turret-pod-shotgun-t1-empty-equipment"
      }
    },
    unit = {
      count = 150,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
      },
      time = 30
    },
    order = "a-b-c"
  },

  {
    type = "technology",
    name = "turret-pod-gun2",
    icons = {
			{ icon = "__TurretPod__/graphics/technology/personal-turret-equipment.png", icon_size = 128 },
			{ icon = "__TurretPod__/graphics/icons/tiers/2.png", icon_size = 64, scale = 1, shift = {30, -40} },
		},
    icon_size = 128,
    prerequisites = { "power-armor", "turret-pod-gun1", "military-4" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-gun-t2-empty-equipment"
      },
      {
        type = "unlock-recipe",
        recipe = "turret-pod-shotgun-t2-empty-equipment"
      }
    },
    unit = {
      count = 250,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 30
    },
    order = "a-b-c"
  },


  {
    type = "technology",
    name = "turret-pod-flame1",
    icons =
    {
      {
        icon_size = 256, icon_mipmaps = 4,
        icon = "__base__/graphics/technology/flamethrower.png",
      },
      { icon = "__TurretPod__/graphics/icons/tiers/1.png", icon_size = 64, scale = 2, shift = {65, -65} },
      {
        icon = "__core__/graphics/icons/technology/constants/constant-equipment.png",
        icon_size = 128,
        icon_mipmaps = 3,
        shift = {-70, 80},
        --scale = 0.25
      }
    },
    prerequisites = { "modular-armor", "flamethrower", "military-3" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-flame-t1-empty-equipment"
      }
    },
    unit = {
      count = 150,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
      },
      time = 30
    },
    order = "a-b-c"
  },
  {
    type = "technology",
    name = "turret-pod-flame2",
    icons =
    {
      {
        icon_size = 256, icon_mipmaps = 4,
        icon = "__base__/graphics/technology/flamethrower.png",
      },
      { icon = "__TurretPod__/graphics/icons/tiers/2.png", icon_size = 64, scale = 2, shift = {65, -65} },
      {
        icon = "__core__/graphics/icons/technology/constants/constant-equipment.png",
        icon_size = 128,
        icon_mipmaps = 3,
        shift = {-70, 80},
        --scale = 0.25
      }
    },
    prerequisites = { "power-armor", "turret-pod-flame1", "military-4" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-flame-t2-empty-equipment"
      }
    },
    unit = {
      count = 700,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"military-science-pack", 1},
        {"chemical-science-pack", 1},
        --{"production-science-pack", 1},
        {"utility-science-pack", 1}
      },
      time = 30
    },
    order = "a-b-c"
  },
})

if ( mods.RampantArsenal ) then
  data:extend(
  {

    {
      type = "technology",
      name = "turret-pod-gun3",
      icons = {
        { icon = "__TurretPod__/graphics/technology/personal-turret-equipment.png", icon_size = 128 },
        { icon = "__TurretPod__/graphics/icons/tiers/3.png", icon_size = 64, scale = 1, shift = {30, -40} },
      },
      icon_size = 128,
      prerequisites = { "rocket-silo", "turret-pod-gun2", "rampant-arsenal-technology-nuclear-tanks" },
      effects =
      {
        {
          type = "unlock-recipe",
          recipe = "turret-pod-gun-t3-empty-equipment"
        },
        {
          type = "unlock-recipe",
          recipe = "turret-pod-shotgun-t3-empty-equipment"
        }
      },
      unit = {
        count = 500,
        ingredients =
        {
          {"automation-science-pack", 1},
          {"logistic-science-pack", 1},
          {"military-science-pack", 1},
          {"chemical-science-pack", 1},
          {"production-science-pack", 1},
          {"utility-science-pack", 1}
        },
        time = 30
      },
      order = "a-b-c"
    },


  })
end