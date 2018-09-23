import SwiftCLI

class HiddenAddCommand: Command {
    let name = "add"
    let shortDescription = "Add a device to the hidden devices"

    let deviceIdentifier = Parameter()

    func execute() throws {
        let address = BluesConfig.shared.address(fromAlias: deviceIdentifier.value) ?? deviceIdentifier.value
        let didAdd = BluesConfig.shared.addToHidden(address)
        if didAdd {
            printMessage("Added device '\(deviceIdentifier.value)' to the hidden devices", withLevel: Level.SUCCESS)
        }
    }
}

class HiddenRemoveCommand: Command {
    let name = "remove"
    let shortDescription = "Remove a device from the hidden devices"

    let deviceIdentifier = Parameter()

    func execute() throws {
        let address = BluesConfig.shared.address(fromAlias: deviceIdentifier.value) ?? deviceIdentifier.value
        let didRemove = BluesConfig.shared.removeFromHidden(address)
        if didRemove {
            printMessage("Removed device '\(deviceIdentifier.value)' from the hidden devices", withLevel: Level.SUCCESS)
        }
    }
}

class HiddenListCommand: Command {
    let name = "list"
    let shortDescription = "List hidden devices"

    func execute() throws {
        for device in BluetoothUtils.pairedDevices().filter({ BluesConfig.shared.hidden.contains($0.address) }) {
            printInfo(forDevice: device, withAlias: BluesConfig.shared.alias(fromAddress: device.address))
        }
    }
}

class HiddenGroup: CommandGroup {
    let name = "hidden"
    let shortDescription = "Manage hidden devices"
    let children: [Routable] = [HiddenListCommand(), HiddenAddCommand(), HiddenRemoveCommand()]
}
