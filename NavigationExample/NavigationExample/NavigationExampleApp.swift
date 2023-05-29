import MQDisplay

@main
struct NavigationExampleApp: App {

	var body: some Scene {
		WindowGroup {
			self.windowContent()
		}
	}

	func windowContent() -> SwiftUIWindow<WindowContentView> {
		do {
			return try .init(
				content: WindowContentView.self,
				using: features
			)
		}
		catch {
			error
				.asTheError()
				.asFatalError()
		}
	}
}

struct WindowContentView: ControlledView {

	let controller: WindowContentViewController

	init(
		controller: WindowContentViewController
	) {
		self.controller = controller
	}

	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello navigation!")

			Button(
				action: {
					self.controller.presentSheet()
				},
				label: {
					Text(
						displayable: "Show sheet"
					)
					.padding(8)
					.foregroundColor(.blue)
				}
			)
		}
		.padding(
			top: 80,
			leading: 16,
			bottom: 80,
			trailing: 16
		)
		.multilineTextAlignment(.center)
		.buttonStyle(.bordered)
		.foregroundColor(.black)
		.background(Color.white)
	}
}

final class WindowContentViewController: ViewController {

	private let transitionToExampleSheetView: TransitionToExampleStackView

	init(
		with context: Void,
		using features: Features
	) throws {
		self.transitionToExampleSheetView = try features.instance()
	}

	func presentSheet() {
		Task {
			try await self.transitionToExampleSheetView.perform()
		}
	}
}
