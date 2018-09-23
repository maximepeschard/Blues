import IOBluetooth

class BluetoothUtils {
    private static func getPairedIOBluetoothDevices() -> [IOBluetoothDevice] {
        if let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] {
            // the following filter should suffice to remove unwanted devices
            return devices.filter { $0.deviceClassMajor != kBluetoothDeviceClassMajorMiscellaneous }
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
