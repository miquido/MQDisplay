import SwiftUI

extension View {

	public func padding(
		top: CGFloat = 0,
		leading: CGFloat = 0,
		bottom: CGFloat = 0,
		trailing: CGFloat = 0
	) -> some View {
		self.padding(
			.init(
				top: top,
				leading: leading,
				bottom: bottom,
				trailing: trailing
			)
		)
	}
}
