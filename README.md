# MeCardParser

[![CI Status](https://img.shields.io/travis/kishore-prakash/MeCardParser.svg?style=flat)](https://travis-ci.org/kishore-prakash/MeCardParser)
[![Version](https://img.shields.io/cocoapods/v/MeCardParser.svg?style=flat)](https://cocoapods.org/pods/MeCardParser)
[![License](https://img.shields.io/cocoapods/l/MeCardParser.svg?style=flat)](https://cocoapods.org/pods/MeCardParser)
[![Platform](https://img.shields.io/cocoapods/p/MeCardParser.svg?style=flat)](https://cocoapods.org/pods/MeCardParser)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MeCardParser is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MeCardParser'
```

## Usage

```swift
let qrCodeContent = "MECARD:N:John Doe;SOUND:Name;TEL:555-555-5555;EMAIL:email@example.com;NOTE:Contoso;BDAY:20100811;ADR:No. 56/1094, 8th Main, Vi;URL:https://www.example.com;NICKNAME:Nickname;"

guard let contact = Parser.parserMeCard(data: qrCodeContent) else {
    print("Error while Parsing")
    return
}
```

## Author

Kishore Prakash, kishore.balasa@gmail.com

## License

MeCardParser is available under the MIT license. See the LICENSE file for more info.
