import SwiftUI

public struct Embed<EmbeddedView, PlaceholderView>: View
where EmbeddedView: ControlledView, PlaceholderView: View {
	
	private let controller: (any ViewController)?
	private let placeholder: @MainActor () -> PlaceholderView
	
	public init(
		_ view: EmbeddedView.Type,
		using controller: (any ViewController)?,
		@ViewBuilder placeholder: @MainActor @escaping () -> PlaceholderView
	) {
		self.controller = controller
		self.placeholder = placeholder
	}
	
	public init(
		_ view: EmbeddedView.Type,
		using controller: (any ViewController)?
	) where PlaceholderView == EmptyView {
		self.controller = controller
		self.placeholder = EmptyView.init
	}
	
	public var body: some View {
		if let embeddedViewController: EmbeddedView.Controller = self.controller as? EmbeddedView.Controller {
			EmbeddedView(
				controller: embeddedViewController
			)
		}
		else {
			self.placeholder()
		}
	}
}
