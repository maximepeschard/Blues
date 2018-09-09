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

func printDevice(name: String, address: String, connected: Bool, alias: String?) {
    let statusIcon = connected ? "*".bold : "•"
    let addressPart = "(\(address))"
    let namePart = connected ? name.bold.green : name.bold
    if let aliasUnwrapped = alias {
        let aliasPart = "[@ -> " + "\(aliasUnwrapped)".magenta + "]"
        print(statusIcon, namePart, addressPart, aliasPart)
    } else {
        print(statusIcon, namePart, addressPart)
    }
}
