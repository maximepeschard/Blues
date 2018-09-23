import Foundation

struct Config: Codable {
    var alias: [String: String]
}

class BluesConfig {
    static let shared = BluesConfig()

    private let configFile = ".bluesconf"
    private var aliasToAddress: [String: String] = [:]
    private var addressToAlias: [String: String] = [:]

    private init() {
        load()
    }

    func alias(fromAddress address: String) -> String? {
        return addressToAlias[address]
    }

    func address(fromAlias alias: String) -> String? {
        return aliasToAddress[alias]
    }

    func setAlias(_ alias: String, forAddress address: String) {
        aliasToAddress[alias] = address
        addressToAlias[address] = alias
        save()
    }

    func unsetAlias(_ alias: String) -> String? {
        if let address = aliasToAddress[alias] {
            addressToAlias.removeValue(forKey: address)
        }
        let removed = aliasToAddress.removeValue(forKey: alias)
        save()
        return removed
    }

    func load() {
        let fileManager = FileManager.default
        guard #available(macOS 10.12, *) else {
            return
        }
        let home = fileManager.homeDirectoryForCurrentUser
        let configUrl = home.appendingPathComponent(configFile)
        guard fileManager.fileExists(atPath: configUrl.path) else {
            return
        }
        do {
            let data = try Data(contentsOf: configUrl)
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(Config.self, from: data)
            for (als, addr) in decoded.alias {
                aliasToAddress[als] = addr
                addressToAlias[addr] = als
            }
        } catch {
            printMessage("Couldn't load configuration.", withLevel: Level.WARNING)
        }
    }

    func save() {
        let fileManager = FileManager.default
        guard #available(macOS 10.12, *) else {
            return
        }
        let home = fileManager.homeDirectoryForCurrentUser
        let configUrl = home.appendingPathComponent(configFile)
        do {
            let obj = Config(alias: aliasToAddress)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(obj)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try jsonString.write(to: configUrl, atomically: true, encoding: .utf8)
        } catch {
            printMessage("Couldn't save configuration.", withLevel: Level.WARNING)
        }
    }
}
