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
		self.transitionEngine = features.instance()
	}

	@MainActor private func perform(
		with context: Destination.Context,
		animated: Bool,
		file: StaticString,
		line: UInt
	) async throws -> TransitionIdentifier {
		let view: View = try await .init(
			controller: self.features
				.instance(
					of: View.Controller.self,
					context: context,
					file: file,
					line: line
				)
		)
		if let anchor: TransitionAnchor = TransitionEngine.anchor {
			return await anchor
				.present(
					sheet: view,
					animated: animated,
					file: file,
					line: line
				)
		}
		else {
			let anchor: TransitionAnchor = self.transitionEngine.activeAnchor()
			return await TransitionEngine.$anchor.withValue(anchor) {
				await anchor
					.present(
						sheet: view,
						animated: animated,
						file: file,
						line: line
					)
			}
		}
	}

	public nonisolated var instance: TransitionTo<Destination> {
		.init(
			perform: self.perform(with:animated:file:line:)
		)
	}
}
