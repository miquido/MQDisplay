import SwiftUI

#if os(iOS) || os(tvOS)

public final class BridgingViewController<HostedView: ControlledView>: UIHostingController<HostedView> {

	public static func bridging(
		_ view: HostedView.Type,
		controller: HostedView.Controller
	) -> Self {
		Self.init(
			rootView:
				view
				.init(
					controller: controller
				)
		)
	}
}

extension UIViewController {

	public static func bridging<HostedView: ControlledView>(
		_ view: HostedView.Type,
		controller: HostedView.Controller
	) -> BridgingViewController<HostedView> {
		BridgingViewController<HostedView>
			.bridging(
				view,
				controller: controller
			)
	}
}

#elseif os(macOS)

public final class BridgingViewController<HostedView: ControlledView>: NSHostingController<HostedView> {

	public static func bridging(
		_ view: HostedView.Type,
		controller: HostedView.Controller
	) -> Self {
		Self.init(
			rootView:
				view
				.init(
					controller: controller
				)
		)
	}
}

#elseif os(watchOS)

// nothing to bridge

#else

#error("Unsupported platform!")

#endif
