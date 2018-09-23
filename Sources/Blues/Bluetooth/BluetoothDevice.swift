import IOBluetooth

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
