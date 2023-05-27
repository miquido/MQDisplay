import MQ
import SwiftUI

extension Text {

	@inline(__always) @_transparent
	public init(
		displayable: DisplayableWithString
	) {
		self.init(displayable.displayableString.resolved)
	}

	@inline(__always) @_transparent @_disfavoredOverload
	public init(
		displayable: DisplayableString
	) {
		self.init(displayable.resolved)
	}
}
