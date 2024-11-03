# K1NG Car Collection Display Script

A QBCore-based FiveM resource that creates an animated VIP garage display with driving animations and protected vehicles.

## Dependencies

- QBCore Framework

## Installation

1. Download the resource
2. Place it in your server's `resources` folder
3. Add `ensure K1NG-VIPGARAGE` to your `server.cfg`
4. Configure your VIP displays in `config.lua`

## Configuration

Edit `config.lua` to customize:
- Render distance
- Vehicle drive-in speed
- Key bindings
- Vehicle display locations
- Vehicle models and customizations

### Display Configuration Example

```lua
Config.VIPDisplays = {
    {
        spawnPoint = vector4(x, y, z, heading),  -- Where vehicle starts
        parkingSpot = vector4(x, y, z, heading), -- Where vehicle parks
        model = 'vehiclename',
        colors = {
            primary = {r = 0, g = 0, b = 0},
            secondary = {r = 0, g = 0, b = 0},
            pearlescent = 0
        },
        extras = {
            neonEnabled = {1,1,1,1},
            neonColor = {r = 255, g = 0, b = 255},
            xenonColor = 1,
            wheelColor = 0,
            windowTint = 1
        }
    }
}
```

## Features

1. **Animated Drive-In**
   - Vehicles drive themselves to parking spots
   - Smooth animations with proper pathing
   - Temporary NPC driver that disappears after parking

2. **Vehicle Protection**
   - Vehicles cannot be entered
   - Trunk and glovebox access disabled
   - Vehicles are invincible
   - No unauthorized modifications possible

3. **Optimization**
   - Vehicles only spawn when players are nearby
   - Resource-efficient with minimal performance impact
   - Smart thread management

4. **Customization**
   - Fully customizable vehicle appearances
   - Configurable animations and timing
   - Adjustable trigger distances and key bindings

## Known Issues

- Vehicles may occasionally spawn incorrectly on server restart
- Animation may glitch on high server load

## Support

For support, please create an ticket in my discord server: https://discord.gg/FwtcbmCJ4B

