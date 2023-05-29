import MQDo

internal final class WindowTransitionEngine: ImplementationOfCacheableFeature {

	private typealias Transition = @MainActor (TransitionWindowAnchor) async -> Void

	@MainActor private var nextTransitionAwaiter: CheckedContinuation<Transition, Never>? = .none
	// use Deque instead?
	@MainActor private var pendingTransitions: Array<Transition> = .init()
	private let windowAnchor: @MainActor () -> TransitionWindowAnchor
	private lazy var transitionsTask: Task<Void, Never> = .detached { @MainActor [weak self] in
		while !Task.isCancelled, let self {
			let transtion: Transition = await self.pickNextTransition()
			await transtion(self.windowAnchor())
		}
	}

	@MainActor internal init(
		with _: CacheableFeatureVoidContext,
		using features: Features
	) throws {
		let uiRootContext: UIRootScope.Context = try features.context(
			for: UIRootScope.self
		)
		self.windowAnchor = { @MainActor () -> TransitionWindowAnchor in
			if let anchor: TransitionWindowAnchor = uiRootContext() as? TransitionWindowAnchor {
				return anchor
			}
			else {
				// FIXME: define an error for invalid window
				Undefined
					.error(message: "Provided window was not valid!")
					.asFatalError()
			}
		}
	}

	deinit {
		self.transitionsTask.cancel()
	}

	@MainActor private final func pickNextTransition() async -> Transition {
		if self.pendingTransitions.isEmpty {
			return await withCheckedContinuation { (continuation: CheckedContinuation<Transition, Never>) in
				assert(self.nextTransitionAwaiter == nil)
				self.nextTransitionAwaiter = continuation
			}
		}
		else {
			return self.pendingTransitions.removeFirst()
		}
	}

	@MainActor @Sendable private final func scheduleTransition(
		from anchorIdentifier: TransitionIdentifier?,
		_ transition: @escaping @MainActor (TransitionAnchor) async throws -> Void
	) async throws {
		try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
			guard !self.transitionsTask.isCancelled
			else { return continuation.resume(throwing: Cancelled.error()) }

			let transition: Transition = { @MainActor (anchor: TransitionWindowAnchor) async in
				do {
					try Task.checkCancellation()

					let transitonAnchor: TransitionAnchor
					if let anchorIdentifier {
						if let matchingAnchor: TransitionAnchor = anchor.first(with: anchorIdentifier) {
							transitonAnchor = matchingAnchor
						}
						else {
							// FIXME: define error for no matching anchor
							throw
								Undefined
								.error(message: "Requested transtion anchor was not available")
								.asRuntimeWarning()
						}
					}
					else {
						transitonAnchor = anchor.activeLeaf()
					}

					try await continuation.resume(
						returning: transition(transitonAnchor)
					)
				}
				catch {
					continuation.resume(throwing: error)
				}
			}

			if let nextTransitionAwaiter {
				nextTransitionAwaiter.resume(returning: transition)
				self.nextTransitionAwaiter = .none
			}
			else {
				self.pendingTransitions.append(transition)
			}
		}
	}

	nonisolated var instance: TransitionEngine {
		.init(
			scheduleTransition: self.scheduleTransition(from:_:)
		)
	}
}
