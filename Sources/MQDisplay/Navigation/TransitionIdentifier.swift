public struct TransitionIdentifier {

  private let identifier: AnyHashable

  public init<Identifier>(
    _ identifier: Identifier
  ) where Identifier: Hashable {
    self.identifier = identifier
  }
}

extension TransitionIdentifier: Hashable {}

extension TransitionIdentifier: Identifiable {

  public var id: Self { self }
}
