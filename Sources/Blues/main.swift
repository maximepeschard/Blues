import SwiftCLI

let bluesCli = CLI(
    name: "blues",
    version: "0.2.0",
    description: "Blues - Manage Bluetooth connections with paired devices"
)
bluesCli.commands = [
    ToggleGroup(),
    ListCommand(),
    ConnectCommand(),
    DisconnectCommand(),
    AliasGroup(),
]
bluesCli.aliases["ls"] = "list"
BluesConfig.shared.load()
bluesCli.goAndExit()
