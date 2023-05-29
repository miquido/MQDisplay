import MQDo

public struct SheetPresentTransitionTo<Destination, View>: ImplementationOfDisposableFeature
where Destination: TransitionDestination, View: ControlledView, View.Controller.Context == Destination.Context {

	private let features: Features
	private let transitionEngine: TransitionEngine

	public init(
		with context: Void,
		using features: Features
	) throws {
		self.features = features
		self.transitionEngine = try features.instance()
	}

	@MainActor private func perform(
		with context: Destination.Context,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws -> TransitionIdentifier {
		let view: View = try .init(
			controller: self.features
				.instance(
					of: View.Controller.self,
					context: context,
					file: file,
					line: line
				)
		)
		let identifier: TransitionIdentifier = Destination.transitionIdentier(for: context)

		try await self.transitionEngine.scheduleTransition { @MainActor (anchor: TransitionAnchor) async throws in
			try await anchor
				.present(
					sheet: view,
					with: identifier,
					embeddedInStack: false,
					animated: animated,
					file: file,
					line: line
				)
		}

		return identifier
	}

	public nonisolated var instance: TransitionTo<Destination> {
		.init(
			perform: self.perform(with:animated:file:line:)
		)
	}
}
