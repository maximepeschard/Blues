import IOBluetooth

enum BluesError: Error {
    case deviceNotFound(identifier: String)
    case connectionError(identifier: String)
}

enum DeviceStatus {
    case connected
    case disconnected
}

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
}

class Bluetooth {
    private static func getPairedIOBluetoothDevices() -> [IOBluetoothDevice] {
        if let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            return devices
        } else {
            return [IOBluetoothDevice]()
        }
    }

    static func pairedDevices() -> [Device] {
        return getPairedIOBluetoothDevices().map { Device(fromIOBluetoothDevice: $0) }
    }

    static func searchPairedDevice(identifier: String) -> Device? {
        for device in pairedDevices() {
            if device.name == identifier || device.address == identifier {
                return device
            }
        }
        return nil
    }

    static func connectDevice(identifier: String) throws -> Bool {
        if let device = searchPairedDevice(identifier: identifier) {
            return try device.connect()
        } else {
            throw BluesError.deviceNotFound(identifier: identifier)
        }
    }

    static func disconnectDevice(identifier: String) throws -> Bool {
        if let device = searchPairedDevice(identifier: identifier) {
            return try device.disconnect()
        } else {
            throw BluesError.deviceNotFound(identifier: identifier)
        }
    }
}
