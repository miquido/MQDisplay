import MQDo

public enum UIRootScope: FeaturesScope {

	public typealias Context = @MainActor @Sendable () -> TransitionRootAnchor
}
