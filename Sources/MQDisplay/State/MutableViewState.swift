import Combine
import MQ
import SwiftUI

@MainActor @dynamicMemberLookup
public final class MutableViewState<State>: AnyViewState, Sendable
where State: Equatable & Sendable {

	public nonisolated var objectWillChange: AnyPublisher<State, Never> {
		self.updatesPublisher
			.removeDuplicates()
			.eraseToAnyPublisher()
	}
	internal let updatesPublisher: AnyPublisher<State, Never>
	private let read: @MainActor () -> State
	private let write: @MainActor (State) -> Void

	public nonisolated init<UpdatesPublisher>(
		read: @escaping @MainActor () -> State,
		write: @escaping @MainActor (State) -> Void,
		updates: UpdatesPublisher // should emit before each change and always on MainActor
	) where UpdatesPublisher: Publisher, UpdatesPublisher.Output == State, UpdatesPublisher.Failure == Never {
		self.read = read
		self.write = write
		self.updatesPublisher = updates.eraseToAnyPublisher()
	}

	public nonisolated convenience init(
		initial: State
	) {
		// access isolated by MainActor, no need to synchronize with lock
		var state: State = initial
		let updatesSubject: PassthroughSubject<State, Never> = .init()
		self.init(
			read: { state },
			write: { (newValue: State) in
				updatesSubject.send(newValue)
				state = newValue
			},
			updates: updatesSubject
		)
	}

	// stateless - does nothing
	public nonisolated convenience init()
	where State == Never {
		self.init(
			read: always(unreachable("Can't read Never")),
			write: noop,
			updates: Empty(completeImmediately: true)
		)
	}

	public private(set) var current: State {
		get { self.read() }
		set { self.write(newValue) }
	}

	@inlinable
	public subscript<Value>(
		dynamicMember keyPath: KeyPath<State, Value>
	) -> Value {
		self.current[keyPath: keyPath]
	}
}

extension MutableViewState {

	public func update<Returned>(
		_ mutation: (inout State) throws -> Returned
	) rethrows -> Returned {
		var copy: State = self.current
		defer { self.current = copy }

		return try mutation(&copy)
	}

	public func update<Value>(
		_ keyPath: WritableKeyPath<State, Value>,
		to value: Value
	) {
		self.current[keyPath: keyPath] = value
	}

	public func binding<BindingValue>(
		to keyPath: WritableKeyPath<State, BindingValue>
	) -> Binding<BindingValue> {
		Binding<BindingValue>(
			get: { self.current[keyPath: keyPath] },
			set: { (newValue: BindingValue) in
				self.current[keyPath: keyPath] = newValue
			}
		)
	}
}

extension MutableViewState: Equatable {

	public nonisolated static func == (
		lhs: MutableViewState<State>,
		rhs: MutableViewState<State>
	) -> Bool {
		lhs === rhs
	}
}
