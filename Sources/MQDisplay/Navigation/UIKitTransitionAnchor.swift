#if os(iOS) || os(tvOS)

@_implementationOnly import class UIKit.UIViewController
@_implementationOnly import class UIKit.UINavigationController
@_implementationOnly import class UIKit.UITabBarController
@_implementationOnly import class UIKit.UIWindow

extension UIWindow: TransitionAnchor {

	internal nonisolated var identifier: TransitionIdentifier {
		.init(ObjectIdentifier(self))
	}

	@MainActor internal var parentAnchor: TransitionAnchor? { .none }

	@MainActor internal func leafAnchor(
		with identifier: TransitionIdentifier?
	) -> TransitionAnchor? {
		if self.identifier == identifier {
			return self
		}
		else if let identifier {
			return self.rootViewController?.leafAnchor(with: identifier)
		}
		else {
			return self.rootViewController?.leafAnchor(with: identifier) ?? self
		}
	}

	@MainActor func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async {
		InternalInconsistency
			.error(message: "Attempting to dismiss a window. This operation is not supported, ignoring...")
			.asRuntimeWarning(
				file: file,
				line: line
			)
	}

	@MainActor internal func replace<View>(
		with view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View: ControlledView {
		let contentRoot: UIHostingController = .init(rootView: view)
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
		} // else ignore transition animation
		return contentRoot.identifier
	}

	@MainActor internal func push<View>(
		_ view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View : ControlledView {
		if let anchor: TransitionAnchor = self.rootViewController {
			return await anchor
				.push(
					view,
					animated: animated,
					file: file,
					line: line
				)
		}
		else {
			InternalInconsistency
				.error(message: "Can't push a view without root in window! Using it as window root instead...")
				.with(View.self, for: "view")
				.asRuntimeWarning(
					file: file,
					line: line
				)

			let contentRoot: UIHostingController = .init(rootView: view)
			let navigationRoot: UINavigationController = .init(rootViewController: contentRoot)
			// can't really animate that...
			self.rootViewController = navigationRoot
			return contentRoot.identifier
		}
	}

	@MainActor internal func present<View>(
		sheet view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View : ControlledView {
		if let anchor: TransitionAnchor = self.rootViewController {
			return await anchor
				.present(
					sheet: view,
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

			let contentRoot: UIHostingController = .init(rootView: view)
			self.rootViewController = contentRoot
			return contentRoot.identifier
		}
	}
}

extension UIViewController: TransitionAnchor {

	internal nonisolated var identifier: TransitionIdentifier {
		.init(ObjectIdentifier(self))
	}

	@MainActor internal var parentAnchor: TransitionAnchor? {
		self.parent
		?? self.presentingViewController
		?? self.navigationController
		?? self.tabBarController
		?? self.viewIfLoaded?.window // TODO: verify if that is a good idea...
	}

	@MainActor internal func leafAnchor(
		with identifier: TransitionIdentifier?
	) -> TransitionAnchor? {
		if self.identifier == identifier {
			return self
		}
		else if let presented: TransitionAnchor = self.presentedViewController{
			return presented.leafAnchor(with: identifier)
		}
		else if let tabs: UITabBarController = self as? UITabBarController ?? self.tabBarController {
			if let viewControllers: Array<UIViewController> = tabs.viewControllers {
				if let identifier {
					return viewControllers
						.flatMap { ($0 as? UINavigationController)?.viewControllers ?? [$0] }
						.first(where: { $0.identifier == identifier })
				}
				else {
					let selected: UIViewController = viewControllers[tabs.selectedIndex]
					if let stack: UINavigationController = selected as? UINavigationController ?? selected.navigationController {
						if let identifier {
							return stack.viewControllers
								.first(where: { $0.identifier == identifier })
						}
						else {
							return stack.viewControllers.last ?? stack
						}
					}
					else {
						return selected
					}
				}
			}
			else if let identifier {
				return .none
			}
			else {
				return tabs
			}
		}
		else if let stack: UINavigationController = self as? UINavigationController ?? self.navigationController {
			if let identifier {
				return stack.viewControllers
					.first(where: { $0.identifier == identifier })
			}
			else {
				return stack.viewControllers.last ?? stack
			}
		}
		else if let identifier {
			return .none
		}
		else {
			return self
		}
	}

	@MainActor func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async {
		if let presenting: UIViewController = self.presentingViewController {
			return await withUnsafeContinuation { continuation in
				presenting.dismiss(
					animated: animated,
					completion: continuation.resume
				)
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
					stack.dismiss(
						animated: animated,
						completion: continuation.resume
					)
				}
			}
		}
		else if let tabs: UITabBarController = self.tabBarController {
			#warning("TODO: to implement in future - search through all tabs")
			unimplemented("TODO: FIXME: to complete!")
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

	@MainActor internal func replace<View>(
		with view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View: ControlledView {
		let replacingView: UIHostingController = .init(rootView: view)
		unimplemented("TODO: FIXME: to complete!")
		return replacingView.identifier
	}

	@MainActor internal func push<View>(
		_ view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View : ControlledView {
		let pushedAnchor: UIHostingController = .init(rootView: view)
		if let navigationStack: UINavigationController = self as? UINavigationController ?? self.navigationController {
			await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
				CATransaction.begin()
				CATransaction.setCompletionBlock(continuation.resume)
				navigationStack.pushViewController(
					pushedAnchor,
					animated: animated
				)
				CATransaction.commit()
			}
		}
		else {
			InternalInconsistency
				.error(message: "Can't push a view without navigation stack! Presenting new stack instead...")
				.with(View.self, for: "view")
				.asRuntimeWarning(
					file: file,
					line: line
				)

			let navigationRoot: UINavigationController = .init(rootViewController: pushedAnchor)
			navigationRoot.modalPresentationStyle = .overFullScreen
			await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
				self.present(
					navigationRoot,
					animated: animated,
					completion: {
						continuation.resume()
					}
				)
			}
		}
		return pushedAnchor.identifier
	}

	@MainActor internal func present<View>(
		sheet view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View : ControlledView {
		if let anchor: TransitionAnchor = self.tabBarController ?? self.navigationController {
			return await anchor
				.present(
					sheet: view,
					animated: animated,
					file: file,
					line: line
				)
		}
		else {
			let presentedAnchor: UIHostingController = .init(rootView: view)
			presentedAnchor.modalPresentationStyle = .pageSheet
			await withUnsafeContinuation { (continuation: UnsafeContinuation<Void, Never>) in
				self.present(
					presentedAnchor,
					animated: animated,
					completion: {
						continuation.resume()
					}
				)
			}
			return presentedAnchor.identifier
		}
	}
}

#endif
