data:extend ({
  {
    type = "recipe",
    name = "turret-pod-gun-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"engine-unit", 1},
      {"gun-turret", 1},
      {"electronic-circuit", 3},
      {"advanced-circuit", 2}
    },
    result = "turret-pod-gun-t1-empty-equipment"
  },

  {
    type = "recipe",
    name = "turret-pod-gun-t2-empty-equipment",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {"electric-engine-unit", 3},
      {"turret-pod-gun-t1-empty-equipment", 1},
      {"advanced-circuit", 5}
    },
    result = "turret-pod-gun-t2-empty-equipment"
  },

  {
    type = "recipe",
    name = "turret-pod-flame-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"iron-gear-wheel", 2},
      {"flamethrower-turret", 1},
      {"electronic-circuit", 5},
      {"advanced-circuit", 3}
    },
    result = "turret-pod-flame-t1-empty-equipment"
  },



  {
    type = "recipe",
    name = "turret-pod-shotgun-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {"engine-unit", 1},
      {"gun-turret", 1},
      {"electronic-circuit", 3},
      {"advanced-circuit", 2}
    },
    result = "turret-pod-shotgun-t1-empty-equipment"
  },

  {
    type = "recipe",
    name = "turret-pod-shotgun-t2-empty-equipment",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {"electric-engine-unit", 3},
      {"turret-pod-gun-t1-empty-equipment", 1},
      {"advanced-circuit", 5}
    },
    result = "turret-pod-shotgun-t2-empty-equipment"
  },


})

if ( mods.RampantArsenal ) then
  data:extend ({

    {
      type = "recipe",
      name = "turret-pod-gun-t3-empty-equipment",
      enabled = false,
      energy_required = 40,
      ingredients =
      {
        {"electric-engine-unit", 2},
        {"low-density-structure", 5},
        {"turret-pod-gun-t2-empty-equipment", 1},
        {"gun-item-rampant-arsenal", 1},
        {"advanced-circuit", 7}
      },
      result = "turret-pod-gun-t3-empty-equipment"
    },
    {
      type = "recipe",
      name = "turret-pod-flame-t2-empty-equipment",
      enabled = false,
      energy_required = 10,
      ingredients =
      {
        {"electric-engine-unit", 2},
        {"turret-pod-flame-t1-empty-equipment", 1},
        {"low-density-structure", 5},
        {"advanced-circuit", 7}
      },
      result = "turret-pod-flame-t2-empty-equipment"
    },
    {
      type = "recipe",
      name = "turret-pod-shotgun-t3-empty-equipment",
      enabled = false,
      energy_required = 40,
      ingredients =
      {
        {"electric-engine-unit", 2},
        {"low-density-structure", 5},
        {"turret-pod-gun-t2-empty-equipment", 1},
        {"shotgun-item-rampant-arsenal", 2},
        {"advanced-circuit", 7}
      },
      result = "turret-pod-shotgun-t3-empty-equipment"
    },
  })
end