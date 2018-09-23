import Foundation
import SwiftCLI

class ListCommand: Command {
    let name = "list"
    let shortDescription = "List paired devices"
    let jsonOutput = Flag("-j", "--json", description: "Output JSON data")

    func execute() throws {
        let devices = BluetoothUtils.pairedDevices()
        if jsonOutput.value {
            var devicesJson: [[String: Any]] = []
            for device in devices {
                var deviceJson: [String: Any] = [
                    "name": device.name,
                    "address": device.address,
                    "connected": device.status == DeviceStatus.connected,
                ]
                if let batteryUnits = device.battery {
                    if batteryUnits.count == 1 {
                        deviceJson["battery"] = batteryUnits[0].level
                    } else {
                        deviceJson["battery"] = Dictionary(
                            uniqueKeysWithValues: batteryUnits.map { ($0.name, $0.level) }
                        )
                    }
                }
                devicesJson.append(deviceJson)
            }
            let jsonData = try? JSONSerialization.data(withJSONObject: devicesJson, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            stdout <<< jsonString
        } else {
            for device in devices {
                printInfo(
                    forDevice: device,
                    withAlias: BluesConfig.shared.alias(fromAddress: device.address)
                )
            }
        }
    }
}
