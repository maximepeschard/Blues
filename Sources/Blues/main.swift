import SwiftCLI

let bluesCli = CLI(
    name: "blues",
    version: "0.1.0",
    description: "Blues - Manage Bluetooth connections with paired devices"
)
bluesCli.commands = [
    ListCommand(),
    ConnectCommand(),
    DisconnectCommand(),
    AliasGroup(),
    HiddenGroup(),
]
bluesCli.aliases["ls"] = "list"
BluesConfig.shared.load()
bluesCli.goAndExit()
