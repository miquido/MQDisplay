# MQDisplay

[![Platforms](https://img.shields.io/badge/platform-iOS%20|%20iPadOS%20|%20macOS-gray.svg?style=flat)]()
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![SwiftVersion](https://img.shields.io/badge/Swift-5.7-brightgreen.svg)]()

Testable and composable UI based on MQDo and SwiftUI.

## Features

MQDisplay provides extensions to both MQDo and SwiftUI allowing to build testable and composable UI. Basic MVC pattern is followed to clearly distinct layers and ensure testability.
- `ViewController` and `ControlledView` interfaces allow building testable controllers managing SwiftUI views. It is done be utilizing `MQDo.Features` to allow easy access to DI mechanisms. `Embed` view adds support for embeding multiple views with dedicated controllers allowing easier split of view controller logic.
- `MutableViewState` adds automatic view updates which can be used to selectively update parts of views by using dedicated View called `WithViewState`.
- Extensions for SwiftUI allow direct usage of `MQ.DisplayableString` and improve ergonomics of commonly used modifiers.

## License

Copyright 2023 Miquido

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
