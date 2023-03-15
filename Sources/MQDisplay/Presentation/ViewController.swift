import MQDo

// Abstraction for controller managing view state.
// Same instance should not be reused between multiple
// views - it should uniquely identify a view on display.
public protocol ViewController: AnyObject, Equatable {

	associatedtype Context = Void
	associatedtype ViewState: Equatable = Stateless

	var viewState: MutableViewState<ViewState> { get }

	init(
		with context: Context,
		using features: Features
	) throws
}

@propertyWrapper
public struct Stateless: Equatable, Sendable {

	public var wrappedValue: MutableViewState<Never>

	public init() {
		self.wrappedValue = .placeholder()
	}
}

extension ViewController {

	public static func == (
		lhs: Self,
		rhs: Self
	) -> Bool {
		lhs.viewState === rhs.viewState
	}
}

extension ViewController {

	@MainActor public func binding<Value>(
		to keyPath: WritableKeyPath<ViewState, Value>
	) -> Binding<Value> {
		self.viewState.binding(to: keyPath)
	}
}

#if DEBUG

	import MQDummy

	extension ViewController {

		public static func preview(
			with context: Context,
			featurePatches: (FeaturePatches) -> Void,
			file: StaticString = #fileID,
			line: UInt = #line
		) -> Self {
			do {
				return try .init(
					with: context,
					using: DummyFeatures(
						with: featurePatches
					)
				)
			}
			catch {
				error
					.asTheError()
					.appending(
						.message(
							"Initializing ViewController.preview failed!",
							file: file,
							line: line
						)
					)
					.with(Self.self, for: "ViewController")
					.with(context, for: "Context")
					.asFatalError(
						message: "Preview can't be prepared!"
					)
			}
		}

		public static func preview(
			featurePatches: (FeaturePatches) -> Void,
			file: StaticString = #fileID,
			line: UInt = #line
		) -> Self
		where Self.Context == Void {
			Self.preview(
				with: Void(),
				featurePatches: featurePatches,
				file: file,
				line: line
			)
		}
	}

#endif
