import Combine
import MQ
import SwiftUI

@MainActor @dynamicMemberLookup
public final class MutableViewState<State>: Sendable
where State: Equatable & Sendable {

	internal let stateWillChange: PassthroughSubject<State, Never>
	private let read: @MainActor () -> State
	private let write: @MainActor (State) -> Void

	public nonisolated init(
		initial: State
	) {
		var state: State = initial
		let updatesSubject: PassthroughSubject<State, Never> = .init()
		self.read = { state }
		self.write = { (newValue: State) in
			updatesSubject.send(newValue)
			state = newValue
		}
		self.stateWillChange = updatesSubject
	}

	// stateless - does nothing
	public nonisolated init() where State == Never {
		self.read = always(unreachable("Can't read Never"))
		self.write = noop
		self.stateWillChange = .init()
	}

	// placeholder - crashes when used
	fileprivate nonisolated init(
		file: StaticString,
		line: UInt
	) {
		self.read = unimplemented0(
			file: file,
			line: line
		)
		self.write = unimplemented1(
			file: file,
			line: line
		)
		self.stateWillChange = .init()
	}

	public private(set) var value: State {
		get { self.read() }
		set { self.write(newValue) }
	}

	@inlinable
	public subscript<Value>(
		dynamicMember keyPath: KeyPath<State, Value>
	) -> Value {
		self.value[keyPath: keyPath]
	}
}

extension MutableViewState {

	public func update<Returned>(
		_ mutation: (inout State) throws -> Returned
	) rethrows -> Returned {
		var copy: State = self.value
		defer { self.value = copy }

		return try mutation(&copy)
	}

	public func update<Value>(
		_ keyPath: WritableKeyPath<State, Value>,
		to value: Value
	) {
		self.value[keyPath: keyPath] = value
	}

	public func binding<BindingValue>(
		to keyPath: WritableKeyPath<State, BindingValue>
	) -> Binding<BindingValue> {
		Binding<BindingValue>(
			get: { self.value[keyPath: keyPath] },
			set: { (newValue: BindingValue) in
				self.value[keyPath: keyPath] = newValue
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

extension MutableViewState {

	public nonisolated static func placeholder(
		file: StaticString = #fileID,
		line: UInt = #line
	) -> Self {
		.init(
			file: file,
			line: line
		)
	}
}
