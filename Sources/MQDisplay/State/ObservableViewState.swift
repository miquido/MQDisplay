import Combine

public final class ObservableViewState<Source, ObservedState>: ObservableObject
where Source: ViewStateSource, ObservedState: Equatable & Sendable {
	
	public let objectWillChange: Publishers.RemoveDuplicates<Publishers.MapKeyPath<Source.StateChangesPublisher, ObservedState>>
	private let source: Source
	private let keyPath: KeyPath<Source.State, ObservedState>
	
	internal nonisolated init(
		from source: Source,
		at keyPath: KeyPath<Source.State, ObservedState>
	) {
		self.source = source
		self.keyPath = keyPath
		self.objectWillChange = source
			.stateWillChange
			.map(keyPath)
			.removeDuplicates()
	}
	
	@MainActor public var current: ObservedState {
		self.source.current[keyPath: keyPath]
	}
}
