public protocol TransitionDestination {

	associatedtype Context = Void
	associatedtype Identifier: Hashable = ObjectIdentifier

	static func identier(
		for context: Context
	) -> Identifier
}

extension TransitionDestination
where Identifier == ObjectIdentifier {

	@inline(__always) @_transparent
	public static func identier(
		for context: Context
	) -> Identifier {
		.init(Self.self)
	}
}

extension TransitionDestination {

	@inline(__always) @_transparent
	internal static func transitionIdentier(
		for context: Context
	) -> TransitionIdentifier {
		.init(Self.identier(for: context))
	}
}
