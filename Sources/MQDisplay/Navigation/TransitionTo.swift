import MQDo

public struct TransitionTo<Destination>
where Destination: TransitionDestination {

  internal var perform: @MainActor (
    _ context: Destination.Context,
    _ animated: Bool,
    _ file: StaticString,
    _ line: UInt
  ) async throws -> TransitionIdentifier
}

extension TransitionTo: DisposableFeature {

  public static var placeholder: Self {
    .init(
      perform: unimplemented4()
    )
  }
}

extension TransitionTo {

  public var mockPerform: @Sendable (_ context: Destination.Context, _ animated: Bool) async throws -> TransitionIdentifier {
		@available(*, unavailable)
    get { unimplemented2("`mockPerform` should never be used explicitly") }
    set {
      self.perform = { @Sendable (context: Destination.Context, animated: Bool, _: StaticString, _: UInt) async throws -> TransitionIdentifier in
        try await newValue(context, animated)
      }
    }
  }
}

extension TransitionTo {

  @MainActor
  @discardableResult
  public func perform(
    with context: Destination.Context,
    animated: Bool = true,
    file: StaticString = #fileID,
    line: UInt = #line
  ) async throws -> TransitionIdentifier {
    try await self.perform(context, animated, file, line)
  }

  @MainActor
  @discardableResult
  public func perform(
    animated: Bool = true,
    file: StaticString = #fileID,
    line: UInt = #line
  ) async throws -> TransitionIdentifier
  where Destination.Context == Void {
    try await self.perform(Void(), animated, file, line)
  }
}
