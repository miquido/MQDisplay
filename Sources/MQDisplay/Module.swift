@_exported import MQDo
@_exported import MQDummy
@_exported import SwiftUI

#if os(iOS) || os(tvOS)

@_implementationOnly import class UIKit.UIWindow

extension FeaturesRegistry
where Scope == RootFeaturesScope {

	public mutating func useWindowTransitionEngine(
		with registrySetup: FeaturesRegistry<UIRootScope>.Setup
	) {
		self.defineScope(UIRootScope.self) { (uiRootRegistry: inout FeaturesRegistry<UIRootScope>) in
			registrySetup(&uiRootRegistry)
			uiRootRegistry.use(WindowTransitionEngine.self)
		}
	}
}

#endif
