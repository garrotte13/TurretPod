data:extend {
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
    energy_required = 10,
    ingredients =
    {
      {"electric-engine-unit", 3},
      {"turret-pod-gun-t1-empty-equipment", 1},
      {"advanced-circuit", 5}
    },
    result = "turret-pod-gun-t2-empty-equipment"
  },
}