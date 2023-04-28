import MQ
import SwiftUI

extension Text {

  @inline(__always) @_transparent
	public init(
		displayable: DisplayableWithString
	) {
		self.init(displayable.displayableString.resolved)
	}
}
