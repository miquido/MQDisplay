import SwiftUI

public protocol ControlledView: View {
	
	associatedtype Controller: ViewController
	
	init(controller: Controller)
}
