import Foundation
import Rainbow

enum Level {
    case SUCCESS
    case WARNING
    case ERROR
}

func printMessage(_ message: String, withLevel level: Level, andQuit quit: Bool? = false) {
    var prefix: String, coloredMessage: String
    switch level {
    case Level.SUCCESS:
        prefix = "Success =>".bold.green
        coloredMessage = message.green
    case Level.WARNING:
        prefix = "Warning =>".bold.yellow
        coloredMessage = message.yellow
    case Level.ERROR:
        prefix = "Error =>".bold.red
        coloredMessage = message.red
    }
    print(prefix, coloredMessage)
    if quit ?? false {
        exit(-1)
    }
}

func printInfo(forDevice device: Device, withAlias alias: String?) {
    let statusIcon = device.status == DeviceStatus.connected ? "*".bold : "•"
    let addressPart = "(\(device.address))"
    let namePart = device.status == DeviceStatus.connected ? device.name.bold.green : device.name.bold
    var output = "\(statusIcon) \(namePart) \(addressPart)"

    if let batteryUnits = device.battery {
        if batteryUnits.count == 1 {
            output += " (battery: \(batteryUnits[0].level)%)"
        } else {
            output += " (" + (batteryUnits.map { "\($0.name): \($0.level)%" }).joined(separator: ", ") + ")"
        }
    }
    if let aliasUnwrapped = alias {
        output += " [@ -> " + "\(aliasUnwrapped)".magenta + "]"
    }
    print(output)
}
