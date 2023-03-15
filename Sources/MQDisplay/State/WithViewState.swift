import SwiftUI

public struct WithViewState<Controller, ObservedState, ContentView>: View
where Controller: ViewController, ObservedState: Equatable, ContentView: View {

	@StateObject private var observedState: ObservableViewState<Controller.ViewState, ObservedState>
	private let content: (ObservedState) -> ContentView

	public init(
		from controller: Controller,
		at keyPath: KeyPath<Controller.ViewState, ObservedState>,
		@ViewBuilder content: @escaping (ObservedState) -> ContentView
	) {
		self._observedState = .init(
			wrappedValue: .init(
				from: controller.viewState,
				at: keyPath
			)
		)
		self.content = content
	}

	public init(
		from controller: Controller,
		@ViewBuilder content: @escaping (ObservedState) -> ContentView
	) where Controller.ViewState == ObservedState {
		self._observedState = .init(
			wrappedValue: .init(
				from: controller.viewState,
				at: \.self
			)
		)
		self.content = content
	}

	public var body: some View {
		self.content(self.observedState.state)
	}
}
