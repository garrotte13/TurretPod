data:extend({

    {
        type = "bool-setting",
        name = "zd-AllVehiclesSupport",
        description = "zd-AllVehiclesSupport",
        setting_type = "startup",
        default_value = true,
        hidden = true,
        --order = "m[total]-a[ai]",

    },

    {
        type = "bool-setting",
        name = "zd-PlayerArmorSupport",
        description = "zd-PlayerArmorSupport",
        setting_type = "startup",
        default_value = false,
        hidden = true,
        --order = "m[total]-a[ai]",

    },

    {
        type = "bool-setting",
        name = "zd-AllowChangeAmmo",
        description = "zd-AllowChangeAmmo",
        setting_type = "runtime-global",
        default_value = true,
        --order = "m[total]-a[ai]",

    },

})