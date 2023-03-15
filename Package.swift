// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "MQDisplay",
	platforms: [
		.iOS(.v14),
		.macOS(.v12),
		.macCatalyst(.v14),
		.watchOS(.v7),
		.tvOS(.v14),
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
			from: "0.9.1"
		)
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
				"MQDisplay",
			]
		),
	]
)
