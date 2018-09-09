import SwiftCLI

class ConnectCommand: Command {
    let name = "connect"
    let shortDescription = "Connect to a paired device"

    let deviceIdentifier = Parameter()

    func execute() throws {
        do {
            var didConnect: Bool
            if let address = BluesConfig.shared.address(fromAlias: deviceIdentifier.value) {
                didConnect = try Bluetooth.connectDevice(identifier: address)
            } else {
                didConnect = try Bluetooth.connectDevice(identifier: deviceIdentifier.value)
            }
            if didConnect {
                printMessage("Connected device '\(deviceIdentifier.value)'", withLevel: Level.SUCCESS)
            }
        } catch {
            printMessage("Failed to connect device '\(deviceIdentifier.value)'", withLevel: Level.ERROR, andQuit: true)
        }
    }
}

class DisconnectCommand: Command {
    let name = "disconnect"
    let shortDescription = "Disconnect a paired device"

    let deviceIdentifier = Parameter()

    func execute() throws {
        do {
            var didDisconnect: Bool
            if let address = BluesConfig.shared.address(fromAlias: deviceIdentifier.value) {
                didDisconnect = try Bluetooth.disconnectDevice(identifier: address)
            } else {
                didDisconnect = try Bluetooth.disconnectDevice(identifier: deviceIdentifier.value)
            }
            if didDisconnect {
                printMessage("Disconnected device '\(deviceIdentifier.value)'", withLevel: Level.SUCCESS)
            }
        } catch {
            printMessage(
                "Failed to disconnect device '\(deviceIdentifier.value)'",
                withLevel: Level.ERROR,
                andQuit: true
            )
        }
    }
}
