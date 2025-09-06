data:extend ({
  {
    type = "recipe",
    name = "turret-pod-gun-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {type="item", name="engine-unit", amount=1},
      {type="item", name="gun-turret", amount=1},
      {type="item", name="electronic-circuit", amount=3},
      {type="item", name="advanced-circuit", amount=2}
    },
    results = {{type="item", name="turret-pod-gun-t1-empty-equipment", amount=1}}
  },

  {
    type = "recipe",
    name = "turret-pod-gun-t2-empty-equipment",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {type="item", name="electric-engine-unit", amount=3},
      {type="item", name="turret-pod-gun-t1-empty-equipment", amount=1},
      {type="item", name="efficiency-module-2", amount=3}
    },
    results = {{type="item", name="turret-pod-gun-t2-empty-equipment", amount=1}}
  },

  {
    type = "recipe",
    name = "turret-pod-flame-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {type="item", name="iron-gear-wheel", amount=2},
      {type="item", name="flamethrower-turret", amount=1},
      {type="item", name="electronic-circuit", amount=5},
      {type="item", name="advanced-circuit", amount=3}
    },
    results = {{type="item", name="turret-pod-flame-t1-empty-equipment", amount=1}}
  },
  {
    type = "recipe",
    name = "turret-pod-flame-t2-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {type="item", name="electric-engine-unit", amount=2},
      {type="item", name="turret-pod-flame-t1-empty-equipment", amount=1},
      {type="item", name="low-density-structure", amount=5},
      {type="item", name="efficiency-module-2", amount=3}
    },
    results = {{type="item", name="turret-pod-flame-t2-empty-equipment", amount=1}}
  },


  {
    type = "recipe",
    name = "turret-pod-shotgun-t1-empty-equipment",
    enabled = false,
    energy_required = 10,
    ingredients =
    {
      {type="item", name="engine-unit", amount=1},
      {type="item", name="gun-turret", amount=1},
      {type="item", name="electronic-circuit", amount=3},
      {type="item", name="advanced-circuit", amount=2}
    },
    results = {{type="item", name="turret-pod-shotgun-t1-empty-equipment", amount=1}}
  },

  {
    type = "recipe",
    name = "turret-pod-shotgun-t2-empty-equipment",
    enabled = false,
    energy_required = 20,
    ingredients =
    {
      {type="item", name="electric-engine-unit", amount=3},
      {type="item", name="turret-pod-shotgun-t1-empty-equipment", amount=1},
      {type="item", name="efficiency-module-2", amount=3}
    },
    results = {{type="item", name="turret-pod-shotgun-t2-empty-equipment", amount=1}}
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
        {type="item", name="electric-engine-unit", amount=2},
        {type="item", name="low-density-structure", amount=5},
        {type="item", name="turret-pod-gun-t2-empty-equipment", amount=1},
        {type="item", name="gun-item-rampant-arsenal", amount=1},
        {type="item", name="efficiency-module-2", amount=12}
      },
      results = {{type="item", name="turret-pod-gun-t3-empty-equipment", amount=1}}
    },

    {
      type = "recipe",
      name = "turret-pod-shotgun-t3-empty-equipment",
      enabled = false,
      energy_required = 40,
      ingredients =
      {
        {type="item", name="electric-engine-unit", amount=2},
        {type="item", name="low-density-structure", amount=5},
        {type="item", name="turret-pod-shotgun-t2-empty-equipment", amount=1},
        {type="item", name="shotgun-item-rampant-arsenal", amount=2},
        {type="item", name="efficiency-module-2", amount=12}
      },
      results = {{type="item", name="turret-pod-shotgun-t3-empty-equipment", amount=1}}
    },
  })
end