import SwiftCLI

class SetAliasCommand: Command {
    let name = "set"
    let shortDescription = "Set an alias for a device"

    let alias = Parameter()
    let address = Parameter()

    func execute() throws {
        BluesConfig.shared.setAlias(alias.value, forAddress: address.value)
        printMessage("Set alias '\(alias.value)' for device with address \(address.value)", withLevel: Level.SUCCESS)
    }
}

class UnsetAliasCommand: Command {
    let name = "unset"
    let shortDescription = "Unset an alias"

    let alias = Parameter()

    func execute() throws {
        if BluesConfig.shared.unsetAlias(alias.value) != nil {
            printMessage("Unset alias '\(alias.value)'", withLevel: Level.SUCCESS)
        }
    }
}

class AliasGroup: CommandGroup {
    let name = "alias"
    let shortDescription = "Manage aliases for devices"
    let children: [Routable] = [SetAliasCommand(), UnsetAliasCommand()]
}
