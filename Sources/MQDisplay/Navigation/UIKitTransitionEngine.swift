#if os(iOS) || os(tvOS)

import MQDo

@_implementationOnly import class UIKit.UIWindow

@MainActor
internal final class UIKitTransitionEngine: ImplementationOfStaticFeature {

	private lazy var window: UIWindow = self.lazyWindow()
	private let lazyWindow: () -> UIWindow

	internal init(
		with configuration: @escaping () -> UIWindow
	) {
		self.lazyWindow = configuration
	}

  @MainActor internal func activeAnchor() -> TransitionAnchor {
		self.window.leafAnchor(with: .none) ?? self.window
  }

  @MainActor internal func revertTransition(
    with identifier: TransitionIdentifier,
    animated: Bool,
		file: StaticString,
		line: UInt
  ) async {
		if let anchorToDismiss: TransitionAnchor = self.window.leafAnchor(with: identifier) {
			await anchorToDismiss
				.dismiss(
					animated: animated,
					file: file,
					line: line
				)
		}
		else { // do nothing
			InternalInconsistency
				.error(message: "Attempting to revert non existing transition. Ignoring...")
				.with(identifier, for: "identifier")
				.asRuntimeWarning(
					file: file,
					line: line
				)
		}
  }

  nonisolated var instance: TransitionEngine {
    .init(
      activeAnchor: self.activeAnchor,
			revertTransition: self.revertTransition(with:animated:file:line:)
    )
  }
}

#endif
