import Foundation
import SwiftCLI

class ListCommand: Command {
    let name = "list"
    let shortDescription = "List paired devices"
    let jsonOutput = Flag("-j", "--json", description: "Output JSON data")

    func execute() throws {
        let devices = Bluetooth.pairedDevices()
        if jsonOutput.value {
            let devicesDict = devices
                .filter({ !BluesConfig.shared.hidden.contains($0.address) })
                .map {
                    ["name": $0.name, "address": $0.address, "connected": $0.status == DeviceStatus.connected]
                }
            let jsonData = try? JSONSerialization.data(withJSONObject: devicesDict, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            stdout <<< jsonString
        } else {
            for device in devices.filter({ !BluesConfig.shared.hidden.contains($0.address) }) {
                printDevice(
                    name: device.name,
                    address: device.address,
                    connected: device.status == DeviceStatus.connected,
                    alias: BluesConfig.shared.alias(fromAddress: device.address)
                )
            }
        }
    }
}
