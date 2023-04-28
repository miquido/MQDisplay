internal protocol TransitionAnchor {

	nonisolated var identifier: TransitionIdentifier { get }

	@MainActor var parentAnchor: TransitionAnchor? { get }

	@MainActor func leafAnchor(
		with identifier: TransitionIdentifier? // none is active leaf
	) -> TransitionAnchor?

	@MainActor func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async

	@MainActor func replace<View>(
		with view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View: ControlledView

	@MainActor func push<View>(
		_ view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View: ControlledView

	@MainActor func present<View>(
		sheet view: View,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async -> TransitionIdentifier
	where View: ControlledView
}
