Config = {}
Config.Locale = 'en'

Config.Payment = {
    item = 'money',
    modifier = 0.4,
    policeCountModifier = 350,
}

Config.MinDeliveryDistance = 1000.0 -- How far away should delivery be from pickup - Must be float
Config.MPS = 21 -- Meters Per Second - Determines amount of time for delivery
Config.RestartOnDelivery = true -- Start new mission if successfully delivered
Config.NotifyPolice = true -- wf-alerts notify on package spawn and drop-off
Config.NotifyChance = 35 -- Not needed if NotifyPolice is false
Config.PackageSpawnPoliceMessage = _U('police_package') -- Not needed if NotifyPolice is false

Config.MissionText = {
    [0] = {
        introText = _U('intro_msg_0'),
        confirmText = _U('confirm_msg_0')
    },
    [1] = {
        introText = _U('intro_msg_1'),
        confirmText = _U('confirm_msg_1')
    },
}

Config.RestartText = {
    [0] = {
        introText = _U('restart_msg_0'),
        confirmText = _U('restart_confirm_0')
    },
}