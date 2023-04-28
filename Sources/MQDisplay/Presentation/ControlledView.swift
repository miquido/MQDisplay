import SwiftUI

public protocol ControlledView: View {
	
	associatedtype Controller: ViewController
	
	init(controller: Controller)
}

#if DEBUG

// MARK: - Preview

extension ControlledView {

	public static func preview(
		with context: Controller.Context,
		featurePatches: @escaping (FeaturePatches) -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) -> some View {
    Self(
      controller: .preview(
        with: context,
        featurePatches: featurePatches,
        file: file,
        line: line
      )
    )
	}

	public static func preview(
		featurePatches: @escaping (FeaturePatches) -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) -> some View where Controller.Context == Void {
    Self(
      controller: .preview(
        with: Void(),
        featurePatches: featurePatches,
        file: file,
        line: line
      )
    )
	}
}

// MARK: - Example Preview

import MQDummy

internal struct Example_Previews: PreviewProvider {

  internal static var previews: some View {
    ExampleView.preview(
      with: "Preview Example Context",
      featurePatches: { (features: FeaturePatches) in
        features(
          patch: \Diagnostics.applicationInfo,
          with: always("Patched dependency")
        )
      }
    )
  }
}

fileprivate struct ExampleView: ControlledView {

  fileprivate let controller: ExampleViewController

  fileprivate init(
    controller: ExampleViewController
  ) {
    self.controller = controller
  }

  fileprivate var body: some View {
    WithViewState(
      from: self.controller,
      at: \.string
    ) { (state: String) in
      Text(state)
        .multilineTextAlignment(.center)
    }
  }
}

fileprivate final class ExampleViewController: ViewController {

  fileprivate struct State: Equatable, Sendable {

    fileprivate var string: String
  }

  fileprivate let viewState: MutableViewState<State>

  fileprivate init(
    with context: String,
    using features: Features
  ) throws {
    let diagnostics: Diagnostics = features.instance()
    self.viewState = .init(
      initial: .init(
        string: "\(context)\n\n\(diagnostics.applicationInfo())"
      )
    )
  }
}

#endif
