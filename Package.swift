// swift-tools-version: 5.8

import PackageDescription

let package = Package(
	name: "MQDisplay",
	platforms: [
		.iOS(.v15),
		.macOS(.v13),
		.macCatalyst(.v15),
		.watchOS(.v8),
		.tvOS(.v15),
	],
	products: [
		.library(
			name: "MQDisplay",
			targets: [
				"MQDisplay"
			]
		),
		.library(
			name: "MQDisplayAssert",
			targets: [
				"MQDisplayAssert"
			]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/miquido/MQDo.git",
			from: "0.10.0"
		),
		.package(
			url: "https://github.com/miquido/MQ-iOS.git",
			from: "0.11.0"
		),
	],
	targets: [
		.target(
			name: "MQDisplay",
			dependencies: [
				"MQDo",
				.product(
					name: "MQDummy",
					package: "MQDo"
				),
				.product(
					name: "MQ",
					package: "mq-ios"
				),
			]
		),
		.testTarget(
			name: "MQDisplayTests",
			dependencies: [
				"MQDisplay",
				"MQDo",
				.product(
					name: "MQDummy",
					package: "MQDo"
				),
				.product(
					name: "MQ",
					package: "mq-ios"
				),
			]
		),
		.target(
			name: "MQDisplayAssert",
			dependencies: [
				"MQDo",
				.product(
					name: "MQDummy",
					package: "MQDo"
				),
				.product(
					name: "MQAssert",
					package: "MQDo"
				),
				.product(
					name: "MQ",
					package: "mq-ios"
				),
				"MQDisplay",
			]
		),
	]
)
