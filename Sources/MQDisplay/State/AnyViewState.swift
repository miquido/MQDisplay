import Combine

public protocol AnyViewState<State>: ObservableObject {
	
	associatedtype State: Equatable & Sendable
	
	@MainActor var current: State { get }
}
