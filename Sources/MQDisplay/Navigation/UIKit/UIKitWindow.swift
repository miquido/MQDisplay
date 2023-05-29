#if os(iOS) || os(tvOS)

import MQDo

@_implementationOnly import class UIKit.UIWindow
@_implementationOnly import class UIKit.UIWindowScene

public final class UIKitWindow: UIWindow {

	// store to ensure proper lifetime
	private var windowFeatures: FeaturesContainer!

	public init<ContentView>(
		content: ContentView.Type,
		embeddedInStack: Bool = false,
		using features: Features,
		in scene: UIWindowScene? = .none,
		file: StaticString = #fileID,
		line: UInt = #line
	) throws
	where ContentView: ControlledView, ContentView.Controller.Context == Void {
		if let scene {
			super.init(windowScene: scene)
		}
		else {
			super.init(frame: .zero)
		}
		let windowFeatures: FeaturesContainer =
			try features
			.branch(
				UIRootScope.self,
				context: { self },
				file: file,
				line: line
			)
		self.windowFeatures = windowFeatures
		let contentView: ContentView = try .init(controller: windowFeatures.instance())
		if embeddedInStack {
			self.rootViewController = UINavigationController(rootViewController: UIHostingController(rootView: contentView))
		}
		else {
			self.rootViewController = UIHostingController(rootView: contentView)
		}
	}

	@available(*, unavailable)
	public required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
#endif
