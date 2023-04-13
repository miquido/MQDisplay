public final class StatelessViewState: AnyViewState {
	
	public init() {}
	
	public var current: Never {
		unreachable("Can't access current value of Never")
	}
}
