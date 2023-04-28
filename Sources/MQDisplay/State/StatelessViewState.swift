import Combine

@propertyWrapper
public final class StatelessViewState: ViewStateSource {

	public let stateWillChange: Empty<Never, Never> = .init(completeImmediately: true)

	public init() {}

	public var wrappedValue: StatelessViewState { self }

	public var current: Never {
		unreachable("Can't access current value of Never")
	}
}
