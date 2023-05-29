#if os(iOS) || os(tvOS)

@_implementationOnly import class UIKit.UIViewController
@_implementationOnly import class UIKit.UINavigationController
@_implementationOnly import class UIKit.UITabBarController
@_implementationOnly import class UIKit.UIWindow

extension UIWindow: TransitionWindowAnchor {

	@inline(__always) @_transparent
	internal nonisolated final var identifier: TransitionIdentifier {
		get {
			objc_getAssociatedObject(
				self,
				&transitionIdentifierAssociationKey
			) as? TransitionIdentifier
				?? .init(ObjectIdentifier(self))
		}
		set {
			objc_setAssociatedObject(
				self,
				&transitionIdentifierAssociationKey,
				newValue,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC
			)
		}
	}

	@MainActor internal final func stackAnchor() -> TransitionStackAnchor? {
		self.rootViewController?.stackAnchor()
	}

	@MainActor internal final func tabsAnchor() -> TransitionTabsAnchor? {
		self.rootViewController?.tabsAnchor()
	}

	@MainActor internal final func activeLeaf() -> TransitionAnchor {
		self.rootViewController?.activeLeaf() ?? self
	}

	@MainActor internal final func first(
		with identifier: TransitionIdentifier
	) -> TransitionAnchor? {
		if self.identifier == identifier {
			return self
		}
		else {
			return self.rootViewController?.first(with: identifier)
		}
	}

	@MainActor internal final func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws {
		throw
			InternalInconsistency
			.error(message: "Attempting to dismiss a window. This operation is not supported, ignoring...")
			.asRuntimeWarning(
				file: file,
				line: line
			)
	}

	@MainActor public final func setContent<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView {
		let contentRoot: UIViewController
		if embeddedInStack {
			contentRoot = UINavigationController(rootViewController: UIHostingController(rootView: view))
		}
		else {
			contentRoot = UIHostingController(rootView: view)
		}
		contentRoot.identifier = identifier
		let currentView: UIView? = self.rootViewController?.view
		self.rootViewController = contentRoot
		if animated {
			await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
				UIView.transition(
					with: self,
					duration: 0.3,
					options: [.transitionCrossDissolve],
					animations: {
						currentView?.alpha = 0
					},
					completion: { _ in
						continuation.resume()
						currentView?.alpha = 1
					}
				)
			}
		}  // else ignore transition animation
	}

	@MainActor internal final func present<View>(
		sheet view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView {
		if let anchor: TransitionAnchor = self.rootViewController {
			try await anchor
				.present(
					sheet: view,
					with: identifier,
					embeddedInStack: embeddedInStack,
					animated: animated,
					file: file,
					line: line
				)
		}
		else {
			InternalInconsistency
				.error(message: "Can't present a view without root in window! Using it as window root instead...")
				.with(View.self, for: "view")
				.asRuntimeWarning(
					file: file,
					line: line
				)

			let contentRoot: UIViewController
			if embeddedInStack {
				contentRoot = UINavigationController(rootViewController: UIHostingController(rootView: view))
			}
			else {
				contentRoot = UIHostingController(rootView: view)
			}
			contentRoot.identifier = identifier
			self.rootViewController = contentRoot
		}
	}
}

extension UIViewController: TransitionAnchor {

	@inline(__always) @_transparent
	internal nonisolated var identifier: TransitionIdentifier {
		get {
			objc_getAssociatedObject(
				self,
				&transitionIdentifierAssociationKey
			) as? TransitionIdentifier
				?? .init(ObjectIdentifier(self))
		}
		set {
			objc_setAssociatedObject(
				self,
				&transitionIdentifierAssociationKey,
				newValue,
				.OBJC_ASSOCIATION_RETAIN_NONATOMIC
			)
		}
	}

	@MainActor internal final func stackAnchor() -> TransitionStackAnchor? {
		if let anchor: TransitionStackAnchor = self as? TransitionStackAnchor {
			return anchor
		}
		else if let stack: TransitionStackAnchor = self.navigationController {
			return stack
		}
		else {
			return .none
		}
	}

	@MainActor internal final func tabsAnchor() -> TransitionTabsAnchor? {
		if let anchor: TransitionTabsAnchor = self as? TransitionTabsAnchor {
			return anchor
		}
		else if let tabs: TransitionTabsAnchor = self.tabBarController {
			return tabs
		}
		else {
			return .none
		}
	}

	@MainActor internal final func first(
		with identifier: TransitionIdentifier
	) -> TransitionAnchor? {
		if self.identifier == identifier {
			return self
		}
		else if let presented: TransitionAnchor = self.presentedViewController {
			return presented.first(with: identifier)
		}
		else if let stack: UINavigationController = self as? UINavigationController ?? self.navigationController {
			return stack.viewControllers
				.first(where: { $0.identifier == identifier })
		}
		else if let tabs: UITabBarController = self as? UITabBarController ?? self.tabBarController {
			unimplemented("TODO: FIXME: UITabBarController support is not finished yet!")
		}
		else {
			return .none
		}
	}

	@MainActor internal final func activeLeaf() -> TransitionAnchor {
		if let presented: TransitionAnchor = self.presentedViewController {
			return presented.activeLeaf()
		}
		else if let stack: UINavigationController = self as? UINavigationController ?? self.navigationController {
			return stack.viewControllers.last ?? self
		}
		else if let tabs: UITabBarController = self as? UITabBarController ?? self.tabBarController {
			unimplemented("TODO: FIXME: UITabBarController support is not finished yet!")
		}
		else {
			return self
		}
	}

	@MainActor func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws {
		if let presenting: UIViewController = self.presentingViewController {
			return await withUnsafeContinuation { continuation in
				CATransaction.begin()
				CATransaction.setCompletionBlock(continuation.resume)
				presenting.dismiss(animated: animated)
				CATransaction.commit()
			}
		}
		else if let stack: UINavigationController = self.navigationController {
			if let index: Int = stack.viewControllers.firstIndex(of: self),
				index != stack.viewControllers.startIndex
			{
				let indexBefore: Int = stack.viewControllers.index(before: index)

				return await withUnsafeContinuation { continuation in
					CATransaction.begin()
					CATransaction.setCompletionBlock(continuation.resume)
					stack.popToViewController(
						stack.viewControllers[indexBefore],
						animated: animated
					)
					CATransaction.commit()
				}
			}
			else {
				// what else to do really? it seems to be root
				return await withUnsafeContinuation { continuation in
					CATransaction.begin()
					CATransaction.setCompletionBlock(continuation.resume)
					stack.dismiss(animated: animated)
					CATransaction.commit()
				}
			}
		}
		else if let tabs: UITabBarController = self.tabBarController {
			unimplemented("TODO: FIXME: UITabBarController support is not finished yet!")
		}
		else {
			InternalInconsistency
				.error(message: "Attempting to revert unknown type of UI transition, ignoring...")
				.asRuntimeWarning(
					file: file,
					line: line
				)
		}
	}

	@MainActor internal func present<View>(
		sheet view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView {
		if let anchor: TransitionAnchor = self.tabBarController ?? self.navigationController {
			try await anchor
				.present(
					sheet: view,
					with: identifier,
					embeddedInStack: embeddedInStack,
					animated: animated,
					file: file,
					line: line
				)
		}
		else {
			let presentedAnchor: UIViewController
			if embeddedInStack {
				presentedAnchor = UINavigationController(rootViewController: UIHostingController(rootView: view))
			}
			else {
				presentedAnchor = UIHostingController(rootView: view)
			}
			presentedAnchor.identifier = identifier
			presentedAnchor.modalPresentationStyle = .pageSheet
			await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
				CATransaction.begin()
				CATransaction.setCompletionBlock(continuation.resume)
				self.present(
					presentedAnchor,
					animated: animated
				)
				CATransaction.commit()
			}
		}
	}
}

extension UINavigationController: TransitionStackAnchor {

	@MainActor internal final func push<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView {
		let pushedAnchor: UIHostingController = .init(rootView: view)
		pushedAnchor.identifier = identifier
		await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
			CATransaction.begin()
			CATransaction.setCompletionBlock(continuation.resume)
			self.pushViewController(
				pushedAnchor,
				animated: animated
			)
			CATransaction.commit()
		}
	}
}

extension UITabBarController: TransitionTabsAnchor {

	@MainActor internal final func add<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView {
		unimplemented("TODO: FIXME: UITabBarController support is not finished yet!")
		let addedAnchor: UIViewController
		if embeddedInStack {
			addedAnchor = UINavigationController(rootViewController: UIHostingController(rootView: view))
		}
		else {
			addedAnchor = UIHostingController(rootView: view)
		}
		addedAnchor.identifier = identifier
		var viewControllers: Array<UIViewController> = self.viewControllers ?? .init()
		viewControllers.append(addedAnchor)
		await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
			CATransaction.begin()
			CATransaction.setCompletionBlock(continuation.resume)
			self.setViewControllers(
				viewControllers,
				animated: animated
			)
			CATransaction.commit()
		}
	}

	@MainActor internal final func remove(
		tab identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws {
		guard let idx = self.viewControllers?.firstIndex(where: { $0.identifier == identifier })
		else {
			InternalInconsistency
				.error(message: "Attempting to remove unknown tab, ignoring...")
				.asRuntimeWarning(
					file: file,
					line: line
				)
			return void
		}

		var viewControllers: Array<UIViewController> = self.viewControllers ?? .init()
	}

	@MainActor internal final func select(
		tab identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws {
		guard let idx = self.viewControllers?.firstIndex(where: { $0.identifier == identifier })
		else {
			InternalInconsistency
				.error(message: "Attempting to select unknown tab, ignoring...")
				.asRuntimeWarning(
					file: file,
					line: line
				)
			return void
		}

		self.selectedIndex = idx
	}
}

private var transitionIdentifierAssociationKey: Int = 0

#endif
