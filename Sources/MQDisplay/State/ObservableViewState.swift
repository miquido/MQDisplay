import Combine

internal final class ObservableViewState<SourceState, ObservedState>: ObservableObject
where SourceState: Equatable, ObservedState: Equatable {

	internal let objectWillChange:
		Publishers.RemoveDuplicates<Publishers.MapKeyPath<PassthroughSubject<SourceState, Never>, ObservedState>>
	private let source: MutableViewState<SourceState>
	private let keyPath: KeyPath<SourceState, ObservedState>

	internal nonisolated init(
		from source: MutableViewState<SourceState>,
		at keyPath: KeyPath<SourceState, ObservedState>
	) {
		self.source = source
		self.keyPath = keyPath
		self.objectWillChange = source
			.stateWillChange
			.map(keyPath)
			.removeDuplicates()
	}

	@MainActor internal var state: ObservedState {
		self.source.value[keyPath: keyPath]
	}
}
