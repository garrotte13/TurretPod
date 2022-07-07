data:extend(
{
  {
    type = "technology",
    name = "turret-pod-gun-t1",
    icon = "__TurretPod__/graphics/technology/personal-turret-equipment.png",
    icon_size = 128,
    prerequisites = { "modular-armor", "gun-turret", "tank" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-gun-t1-empty-equipment"
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
    name = "turret-pod-gun-t2",
    icon = "__TurretPod__/graphics/technology/personal-turret-equipment.png",
    icon_size = 128,
    prerequisites = { "power-armor", "turret-pod-gun-t1", "military-4" },
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "turret-pod-gun-t2-empty-equipment"
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
})