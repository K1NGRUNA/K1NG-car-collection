Config = {}

-- General Settings
Config.RenderDistance = 50.0 -- Distance for vehicles to become visible
Config.DriveInSpeed = 10.0   -- Speed of vehicles driving to parking spot
Config.UseKeyPress = true    -- Enable/disable key press to trigger animation
Config.TriggerKey = 38      -- Key 'E' to trigger vehicle drive-in. non changeble

-- VIP Vehicle Displays
Config.VIPDisplays = {
    {
        spawnPoint = vector4(-386.07, -133.58, 38.69, 299.13),  -- Where vehicle starts driving from
        parkingSpot = vector4(-386.07, -133.58, 38.69, 299.13), -- Final parking position
        model = 'nero',                                     -- Vehicle model
        colors = {
            primary = {r = 0, g = 0, b = 0},    -- RGB values
            secondary = {r = 0, g = 0, b = 0},
            pearlescent = 0
        },
        extras = {
            neonEnabled = {1,1,1,1},            -- Neon layout
            neonColor = {r = 255, g = 0, b = 255},
            xenonColor = 1,                     -- Xenon headlight color
            wheelColor = 0,
            windowTint = 1
        }
    },
    -- Add more display configurations here
}