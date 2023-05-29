import MQDisplay

final class ExampleStackItemViewController: ViewController {

	private let transitionToExampleSheetView: TransitionToExampleStackView
	private let transitionToExampleStackItemView: TransitionToExampleStackItemView

	init(
		with context: Void,
		using features: Features
	) throws {
		self.transitionToExampleSheetView = try features.instance()
		self.transitionToExampleStackItemView = try features.instance()
	}

	func presentSheet() {
		Task {
			try await self.transitionToExampleSheetView.perform()
		}
	}

	func pushNext() {
		Task {
			try await self.transitionToExampleStackItemView.perform()
		}
	}
}

