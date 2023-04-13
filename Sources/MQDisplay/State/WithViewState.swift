import SwiftUI

public struct WithViewState<ViewState, ContentView>: View
where ViewState: AnyViewState, ContentView: View {

	@StateObject private var observedState: ViewState
	private let content: (ViewState.State) -> ContentView

	public init<Controller, SourceState, ContentState>(
		from controller: Controller,
		at keyPath: KeyPath<SourceState, ContentState>,
		@ViewBuilder content: @escaping (ContentState) -> ContentView
	) where Controller: ViewController, Controller.ViewState == MutableViewState<SourceState>, ViewState == ObservableViewState<SourceState, ContentState> {
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
		@ViewBuilder content: @escaping (ViewState.State) -> ContentView
	) where Controller: ViewController, ViewState == Controller.ViewState {
		self._observedState = .init(
			wrappedValue: controller.viewState
		)
		self.content = content
	}

	public var body: some View {
		self.content(self.observedState.current)
	}
}
