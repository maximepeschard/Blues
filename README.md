# Blues

:satellite: A command line tool written in Swift to manage Bluetooth connections with paired devices on macOS.

```
$ blues list
• Maxime's Keyboard (XX-XX-XX-XX-XX-XX)
• Maxime's Mouse (YY-YY-YY-YY-YY-YY)
• Maxime's Beats Solo³ (ZZ-ZZ-ZZ-ZZ-ZZ-ZZ) [@ -> beats]

$ blues toggle on
Success => Bluetooth is now on

$ blues connect beats
Success => Connected device 'beats'

$ blues list
• Maxime's Keyboard (XX-XX-XX-XX-XX-XX)
• Maxime's Mouse (YY-YY-YY-YY-YY-YY)
* Maxime's Beats Solo³ (ZZ-ZZ-ZZ-ZZ-ZZ-ZZ) (battery: 85%) [@ -> beats]
```

## :arrow_down: Installing

### From releases (recommended)

Grab the [latest release](https://github.com/maximepeschard/Blues/releases/latest) from GitHub, and put it somewhere on your `$PATH`.

### From source

```sh
git clone https://github.com/maximepeschard/Blues
cd Blues
swift build -c release
# + move `.build/release/blues` to somewhere on your $PATH
```

## :question: Usage

```
$ blues -h

Usage: blues <command> [options]

Blues - Manage Bluetooth connections with paired devices

Groups:
  toggle          Toggle Bluetooth on/off
  alias           Manage aliases for devices

Commands:
  list            List paired devices
  connect         Connect to a paired device
  disconnect      Disconnect a paired device
  help            Prints help information
  version         Prints the current version of this app
```

### Toggle

Use `blues toggle on` and `blues toggle off` to enable and disable Bluetooh.

### List

Use `blues list` to list all paired devices. Provide the `-j` or `--json` flag to get a JSON output that can be used by other scripts or programs :

```
$ blues ls -j | jq '.'
[
  {
    "name": "Maxime's Keyboard",
    "connected": false,
    "address": "XX-XX-XX-XX-XX-XX"
  },
  {
    "name": "Maxime's Mouse",
    "connected": false,
    "address": "YY-YY-YY-YY-YY-YY"
  },
  {
    "name": "Maxime's Beats Solo³",
    "connected": true,
    "address": "ZZ-ZZ-ZZ-ZZ-ZZ-ZZ",
    "battery": 85
  }
]
```


### Connect & Disconnect

Use `blues connect deviceIdentifier` and `blues disconnect deviceIdentifier` to connect and disconnect a device, where `deviceIdentifier` is either a MAC address or an alias.

### Alias

Set aliases for devices by using `blues alias set myAlias macAddress`. Aliases can be removed with `blues alias unset myAlias`. 


## :wrench: Configuration

*Blues* stores its configuration in the `~/.bluesconf` as soon as you define an alias. This file is a JSON file with the following format :

```json
{
    "alias": {
        "alias1": "address1",
        ...
    }
}
```

Editing this file manually is OK, although you probably shouldn't write JSON if you're human.

## :battery: Built with

* [SwiftCLI](https://github.com/jakeheis/SwiftCLI) - A CLI framework for Swift
* [Rainbow](https://github.com/onevcat/Rainbow) - Styled console output for Swift

## :book: License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

