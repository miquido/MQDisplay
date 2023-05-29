// MARK: - General

internal protocol TransitionAnchor {

	nonisolated var identifier: TransitionIdentifier { get }

	@MainActor func stackAnchor() -> TransitionStackAnchor?
	@MainActor func tabsAnchor() -> TransitionTabsAnchor?

	@MainActor func first(
		with identifier: TransitionIdentifier
	) -> TransitionAnchor?

	@MainActor func activeLeaf() -> TransitionAnchor

	@MainActor func present<View>(
		sheet view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView

	@MainActor func dismiss(
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
}

// MARK: - Window

internal protocol TransitionWindowAnchor: TransitionRootAnchor, TransitionAnchor {}

// MARK: - Stack

internal protocol TransitionStackAnchor: TransitionAnchor {

	@MainActor func push<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView
}

// MARK: - Tabs

internal protocol TransitionTabsAnchor: TransitionAnchor {

	@MainActor func add<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView

	@MainActor func remove(
		tab identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws

	@MainActor func select(
		tab identifier: TransitionIdentifier,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
}
