#if os(iOS) || os(tvOS)

import MQDo
import SwiftUI

@_implementationOnly import class UIKit.UIWindow
@_implementationOnly import class UIKit.UIWindowScene

public struct SwiftUIExperimentalWindow<ContentView>: View
where ContentView: ControlledView, ContentView.Controller.Context == Void {

	// store to ensure proper lifetime
	private var windowFeatures: FeaturesContainer!
	private let contentView: ContentView

	public init<ContentView>(
		content: ContentView.Type,
		using features: Features,
		file: StaticString = #fileID,
		line: UInt = #line
	) throws {
		let windowFeatures: FeaturesContainer =
			try features
			.branch(
				UIRootScope.self,
				context: {
					UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).flatMap({ $0.windows }).first!
				},
				file: file,
				line: line
			)
		self.contentView = try .init(controller: windowFeatures.instance())
		self.windowFeatures = windowFeatures
	}

	public var body: some View {
		self.contentView
	}
}

#endif
