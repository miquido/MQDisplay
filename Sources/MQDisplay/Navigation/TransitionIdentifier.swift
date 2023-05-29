public struct TransitionIdentifier {

	private let identifier: AnyHashable

	internal init<Identifier>(
		_ identifier: Identifier
	) where Identifier: Hashable {
		self.identifier = identifier
	}
}

extension TransitionIdentifier: Hashable {}

extension TransitionIdentifier: Identifiable {

	@inline(__always) @_transparent
	public var id: Self { self }
}
