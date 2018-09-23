import BluetoothObjC
import IOBluetooth

enum DeviceStatus {
    case connected
    case disconnected
}

struct DeviceBatteryUnit {
    var name: String
    var level: Int
}

typealias DeviceBattery = [DeviceBatteryUnit]

struct Device {
    private var device: IOBluetoothDevice

    var name: String {
        return device.name
    }

    var address: String {
        return device.addressString.uppercased()
    }

    var status: DeviceStatus {
        return device.isConnected() ? DeviceStatus.connected : DeviceStatus.disconnected
    }

    var battery: DeviceBattery? {
        guard device.isConnected() else {
            return nil
        }
        var output = DeviceBattery()
        if device.batteryPercentSingle != 0 {
            output.append(DeviceBatteryUnit(name: "single", level: Int(device.batteryPercentSingle)))
        }
        if device.batteryPercentLeft != 0 {
            output.append(DeviceBatteryUnit(name: "left", level: Int(device.batteryPercentLeft)))
        }
        if device.batteryPercentRight != 0 {
            output.append(DeviceBatteryUnit(name: "right", level: Int(device.batteryPercentRight)))
        }
        if device.batteryPercentCombined != 0 {
            output.append(DeviceBatteryUnit(name: "combined", level: Int(device.batteryPercentCombined)))
        }
        if device.batteryPercentCase != 0 {
            output.append(DeviceBatteryUnit(name: "case", level: Int(device.batteryPercentCase)))
        }
        if output.count == 0, let batteryIOReg = self.getBatteryFromIOReg() {
            output.append(DeviceBatteryUnit(name: "battery", level: batteryIOReg))
        }
        return output.count == 0 ? nil : output
    }

    init(fromIOBluetoothDevice device: IOBluetoothDevice) {
        self.device = device
    }

    func connect() throws -> Bool {
        if device.isConnected() {
            return false
        }
        let result = device.openConnection()
        if result != kIOReturnSuccess {
            throw BluesError.connectionError(identifier: device.name)
        }
        return true
    }

    func disconnect() throws -> Bool {
        if !device.isConnected() {
            return false
        }
        let result = device.closeConnection()
        if result != kIOReturnSuccess {
            throw BluesError.connectionError(identifier: device.name)
        }
        return true
    }

    private func getBatteryFromIOReg() -> Int? {
        var iter: io_iterator_t = io_iterator_t()
        let matchingServicesResult = IOServiceGetMatchingServices(
            kIOMasterPortDefault,
            IOServiceNameMatching("AppleDeviceManagementHIDEventService"),
            &iter
        )
        if matchingServicesResult != kIOReturnSuccess {
            return nil
        }
        while case let service = IOIteratorNext(iter), service != 0 {
            guard let address = IORegistryEntryCreateCFProperty(
                service, "DeviceAddress" as CFString, kCFAllocatorDefault, 0
            ) else {
                continue
            }
            guard let addressString = address.takeUnretainedValue() as? String else {
                continue
            }
            if addressString.uppercased() == self.address {
                guard let batteryProp = IORegistryEntryCreateCFProperty(
                    service, "BatteryPercent" as CFString, kCFAllocatorDefault, 0
                ) else {
                    return nil
                }
                if let battery = batteryProp.takeUnretainedValue() as? Int {
                    return battery
                } else {
                    return nil
                }
            }
        }
        return nil
    }
}
