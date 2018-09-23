import SwiftCLI

class ToggleCommand: Command {
    private var targetState: BluetoothState
    var name: String
    var shortDescription: String {
        return "Toggle Bluetooth \(name)"
    }

    init(withName name: String, andTargetState targetState: BluetoothState) {
        self.name = name
        self.targetState = targetState
    }

    func execute() throws {
        let state = BluetoothUtils.state
        if state != targetState {
            BluetoothUtils.state = targetState
            printMessage("Bluetooth is now \(name)", withLevel: Level.SUCCESS)
        }
    }
}

class ToggleGroup: CommandGroup {
    let name = "toggle"
    let shortDescription = "Toggle Bluetooth on/off"
    let children: [Routable] = [
        ToggleCommand(withName: "on", andTargetState: BluetoothState.enabled),
        ToggleCommand(withName: "off", andTargetState: BluetoothState.disabled),
    ]
}
