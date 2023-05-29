import MQDisplay

// MARK: - ViewController

final class WelcomeViewController: ViewController {

	struct State: Equatable {

		var title: DisplayableString
		var counter: Int
	}

	let viewState: MutableViewState<State>

	init(
		with context: Void,
		using features: Features
	) throws {
		self.viewState = .init(
			initial: .init(
				title: "\(localized: "welcome.title", bundle: .main)",
				counter: 0
			)
		)
	}

	@MainActor func increment() {
		self.viewState.update { state in
			state.counter += 1
		}
	}

	@MainActor func decrement() {
		self.viewState.update { state in
			state.counter -= 1
		}
	}
}

// MARK: - ControlledView

struct WelcomeView: ControlledView {

	private let controller: WelcomeViewController

	init(
		controller: WelcomeViewController
	) {
		self.controller = controller
	}

	var body: some View {
		VStack {
			WithViewState(
				from: self.controller,
				at: \.title
			) { title in
				Text(displayable: title)
			}

			WithViewState(
				from: self.controller,
				at: \.counter
			) { counter in
        Text(displayable: "\(localized: "counter.prefix", bundle: .main) \(counter)")
			}

			Button(
				action: { self.controller.increment() },
				label: {
					Text(
						displayable: .localized(
							"counter.increment",
							bundle: .main
						)
					)
				}
			)

			Button(
				action: { self.controller.decrement() },
				label: {
					Text(
						displayable: .localized(
							"counter.decrement",
							bundle: .main
						)
					)
				}
			)
		}
	}
}

// MARK: - Example usage

let features: Features = FeaturesRoot { registry in
	// register your fearures here
}

// MARK: - Create instance for UIKit

import PlaygroundSupport

PlaygroundPage.current.liveView = try BridgingViewController
	.bridging(
		WelcomeView.self,
		controller: features.instance()
	)

// MARK: - Preview for SwiftUI

internal struct WelcomeView_Previews: PreviewProvider {

	internal static var previews: some View {
		WelcomeView
      .preview { (patches: FeaturePatches) in
				// patch dependencies here
			}
	}
}
