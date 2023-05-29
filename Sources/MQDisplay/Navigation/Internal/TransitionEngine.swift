import MQDo

internal struct TransitionEngine {

	internal typealias ScheduleTransition = @MainActor @Sendable (
		_ anchorIdentifier: TransitionIdentifier?,
		_ transition: @escaping @MainActor (TransitionAnchor) async throws -> Void
	) async throws -> Void

	internal var scheduleTransition: ScheduleTransition
}

extension TransitionEngine: CacheableFeature {

	nonisolated static var placeholder: Self {
		.init(
			scheduleTransition: unimplemented2()
		)
	}
}

extension TransitionEngine {

	@MainActor internal func scheduleTransition(
		from anchorIdentifier: TransitionIdentifier? = .none,
		_ transition: @escaping @MainActor (TransitionAnchor) async throws -> Void
	) async throws {
		try await self.scheduleTransition(anchorIdentifier, transition)
	}
}
