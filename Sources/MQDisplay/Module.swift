@_exported import MQDo
@_exported import SwiftUI
@_exported import MQDummy

#if os(iOS) || os(tvOS)

@_implementationOnly import class UIKit.UIWindow

extension FeaturesRegistry
where Scope == RootFeaturesScope {

  public mutating func useUIKitTransitionEngine(
    with window: @autoclosure @escaping () -> UIWindow
  ) {
    self.use(UIKitTransitionEngine.self, with: window)
  }
}

#endif
