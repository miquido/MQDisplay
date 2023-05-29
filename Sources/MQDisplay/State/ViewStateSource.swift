import Combine

public protocol ViewStateSource<State> {

	associatedtype State: Equatable & Sendable
	associatedtype StateChangesPublisher: Publisher
	where StateChangesPublisher.Output == State, StateChangesPublisher.Failure == Never

	var stateWillChange: StateChangesPublisher { get }

	@MainActor var current: State { get }
}

extension ViewStateSource {

	public func observable<State>(
		_ keyPath: KeyPath<Self.State, State>
	) -> ObservableViewState<Self, State> {
		.init(from: self, at: keyPath)
	}
}
