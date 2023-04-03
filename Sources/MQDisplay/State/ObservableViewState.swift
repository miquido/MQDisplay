import Combine

public final class ObservableViewState<SourceState, ObservedState>: AnyViewState
where SourceState: Equatable & Sendable, ObservedState: Equatable & Sendable {
	
	public let objectWillChange:
	Publishers.RemoveDuplicates<Publishers.MapKeyPath<AnyPublisher<SourceState, Never>, ObservedState>>
	private let source: MutableViewState<SourceState>
	private let keyPath: KeyPath<SourceState, ObservedState>
	
	internal nonisolated init(
		from source: MutableViewState<SourceState>,
		at keyPath: KeyPath<SourceState, ObservedState>
	) {
		self.source = source
		self.keyPath = keyPath
		self.objectWillChange = source
			.updatesPublisher
			.map(keyPath)
			.removeDuplicates()
	}
	
	@MainActor public var current: ObservedState {
		self.source.current[keyPath: keyPath]
	}
}
