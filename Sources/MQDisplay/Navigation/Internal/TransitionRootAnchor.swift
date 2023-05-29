// Protocol dedicated for being public to hide implementation details
public protocol TransitionRootAnchor {

	@MainActor func setContent<View>(
		_ view: View,
		with identifier: TransitionIdentifier,
		embeddedInStack: Bool,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws
	where View: ControlledView
}
