import MQ
import SwiftUI

extension Text {

	public init(
		displayable: DisplayableString
	) {
		self.init(displayable.resolved)
	}
}
