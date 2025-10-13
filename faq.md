# Intro

Two reasons this mod can be required:

- Vanilla Factorio doesn't make vehicles much useful: car is good until armor-MK2 and fusion reactor are made, tank is almost never used. Factorio has a lot of ways of play, but some are not motivated (except driving through creep in tank is much better than by foot+exo).
This mod gives these vehicles some advantages. And keep game balance (some challenge, I'm not a fan of spidertrons at game start).
Building Time mod fan? - I welcome you!

- Love for vehicle-based nests clearing, but even in multiplayer one player controls all weapons and can use only one at a moment (switching weapons also returns weapon barrel to default position loosing precious time).

## Requirements

1. _Tank, car, spidertron, cargo wagon._ Or any derivative vehicle.
Character armor is a low priority, but can be added.

1. _Equipment grid._
Vanilla car, cargon wagon and tank do not have equipment, so if no other mod added grids, then default is added for car and cargo wagon. VehicleGrid or RampantArsenal will do it better. Other vehicles usually have grids for equipment.

1. _Electrical energy source and battery in equipment._
For vanilla it can be only solar panels and fusion reactor. Other mods add other sources (some are breaking game balance). But personal battery is also a must here, because power consumption is not flat. Not enough power - pods won't reload in time. Power is consumed when reloading only, not when shooting. Higher tier pods load more ammo at once, do it less often, but consume much more power. Therefore even powerful fusion reactor(s) will reload too slow without batteries.

## How it works

- Research technologies for interesting turret pods.

- Craft turret pods (by hand is allowed).

- Deploy a vehicle on the ground.

- Insert energy source into vehicle equipment.

- Insert a turret pod (only one at once if you want to use different ammo combo by the same turret pods type - that is actual if using warfare mods like Rampant Arsenal with different damage type ammo).

- Put some ammo in the vehicle inventory (your char inventory is NOT used by vehicle intentionally - to make combo possible without adding more items. Less items -> better game).

- If you need other turret to be loaded with other ammo type (e.g. two gun turret pods - one with poison ammo magazines and other with fire ammo magazines), then wait for first turret loading, remove ammo from inventory and then it's time to insert a second turret and adding required ammo to inventory

- Add all ammo reserves to vehicle inventory after turret pods have loaded required ammo subtypes. They won't mix, every turret will keep using the same ammo type till out of stock and only if mod option allows to switch ammo.

- Ready for battle! Keep an eye on vehicle battery level and get out of big fights when energy level is low to replenish batteries level. For vehicles left by driver you need battery level hint - BatteryVehicleDisplay mod can do the trick for you. Maybe I will add a feature in this mod to show charge level when no driver is in vehicle.

- If pods need to be extracted from equipment grid please use Unload Ammo (Alt+U) shortcut selection over your vehicle first to return loaded ammo back into vehicle inventory.

## Turret pod types

### MiniGun turret pod

Consumes bullet-type magazines. In Vanilla it is firearm, piercing and uranium magazines. Any other bullet-type ammo added by any mod should be supported. Number of bullets in a magazine is correctly processed, no power consumption penalty for bigger magazine size.

![Alt text](https://wiki.factorio.com/images/thumb/Firearm_magazine.png/32px-Firearm_magazine.png)

### ShotGun turret pod

Consumes shotgun shell magazines. In Vanilla it is shotgun shell and piercing shotgun shell. Any other shotgun shell ammo added by any mod should be supported.

![Alt text](https://wiki.factorio.com/images/thumb/Shotgun_shells.png/32px-Shotgun_shells.png)

### Flame turret pod

Consumes flamethrower ammo. In Vanilla it is... flamethrower ammo ! Other mods can add more, e.g. Napalm ammo added by Rampant Arsenal mod.

![Alt text](https://wiki.factorio.com/images/thumb/Flamethrower_ammo.png/32px-Flamethrower_ammo.png)

## Additional info from mod changelog notes

- Every reload consumes electrical power. Tier-1 goes ok with solar+battery, Tier-2 needs reactor+batteries mk2, Tier-3 demands nuclear/K2-fusion energy. Like energy shield and nightvision equipment turret pods are a primary-class energy consumer. Acid stickers applied with multiple shields can completely stop reloading if batteries ran out, drive out of big fights back to turrets defense line when battery level is low!

- Technically any weapon type turret pod can be added (cannons, sniper/anti-material rifles) with small efforts, but...
Turret pods are for passive self-defense only to make tanks/cars a preferable choice in endgame vs char armor mk2/mk3.
Vehicles (e.g. in Rampant Arsenal or K2) do have all the high-range weapons on-board in player's manual control for assault tactics.

- Support for char armor is to be added later as an option (low priority) and it still doesn't help player before sulphuric acid production setup, while in later game it will ruin balance again.

- For trains only cargo-wagon is supported. Trains smart support (locomotive and artillery using ammo from cargo wagon) is under question (Low priority, but may give some fun in result). There is another mod for it (has some pros and cons).

- Aircraft support is accidental (may not work, Low priority). Tested with HelicopterRevival successfully (that mod needs a small fix for it).

- VehicleWagon2 mod is supported. I love when tank isn't put back into pocket. Do you?

- Still testing balance now. Feedback will be highly appreciated, especially for endgame.
