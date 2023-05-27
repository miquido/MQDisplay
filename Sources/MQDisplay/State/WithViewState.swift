import SwiftUI

public struct WithViewState<StateSource, State, ContentView>: View
where StateSource: ViewStateSource, State: Equatable & Sendable, ContentView: View {

	@StateObject private var observedState: ObservableViewState<StateSource, State>
	private let content: (State) -> ContentView

	public init<Controller>(
		from controller: Controller,
		at keyPath: KeyPath<StateSource.State, State>,
		@ViewBuilder content: @escaping (State) -> ContentView
	) where Controller: ViewController, Controller.ViewState == StateSource {
		self._observedState = .init(
			wrappedValue: .init(
				from: controller.viewState,
				at: keyPath
			)
		)
		self.content = content
	}

	public init<Controller>(
		from controller: Controller,
		@ViewBuilder content: @escaping (State) -> ContentView
	) where Controller: ViewController, State == StateSource.State, StateSource == Controller.ViewState {
		self._observedState = .init(
			wrappedValue: .init(
				from: controller.viewState,
				at: \.self
			)
		)
		self.content = content
	}

	public init(
		using stateSource: StateSource,
		at keyPath: KeyPath<StateSource.State, State>,
		@ViewBuilder content: @escaping (State) -> ContentView
	) {
		self._observedState = .init(
			wrappedValue: .init(
				from: stateSource,
				at: keyPath
			)
		)
		self.content = content
	}

	public init(
		using stateSource: StateSource,
		@ViewBuilder content: @escaping (State) -> ContentView
	) where StateSource.State == State {
		self._observedState = .init(
			wrappedValue: .init(
				from: stateSource,
				at: \.self
			)
		)
		self.content = content
	}

	public var body: some View {
		self.content(self.observedState.current)
	}
}
