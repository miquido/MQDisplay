import MQDo

internal struct TransitionEngine {

	@TaskLocal internal static var anchor: TransitionAnchor?

  internal var activeAnchor: @MainActor () -> TransitionAnchor
  internal var revertTransition: @MainActor (TransitionIdentifier, Bool, StaticString, UInt) async -> Void
}

extension TransitionEngine: StaticFeature {

  nonisolated static var placeholder: Self {
    .init(
      activeAnchor: unimplemented0(),
      revertTransition: unimplemented4()
    )
  }
}
