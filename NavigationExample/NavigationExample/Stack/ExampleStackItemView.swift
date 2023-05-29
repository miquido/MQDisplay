import MQDisplay

struct ExampleStackItemView: ControlledView {

	let controller: ExampleStackItemViewController

	init(
		controller: ExampleStackItemViewController
	) {
		self.controller = controller
	}

	var body: some View {
		VStack {
			Image(systemName: "arrow.right")
				.imageScale(.large)
				.foregroundColor(.accentColor)

			Button(
				action: {
					self.controller.presentSheet()
				},
				label: {
					Text(
						displayable: "Show sheet"
					)
					.padding(8)
					.foregroundColor(.blue)
				}
			)

			Button(
				action: {
					self.controller.pushNext()
				},
				label: {
					Text(
						displayable: "Push next"
					)
					.padding(8)
					.foregroundColor(.blue)
				}
			)
		}
		.padding(
			top: 80,
			leading: 16,
			bottom: 80,
			trailing: 16
		)
		.multilineTextAlignment(.center)
		.buttonStyle(.bordered)
		.foregroundColor(.black)
		.background(Color.white)
	}
}

struct ExampleStackItemView_Previews: PreviewProvider {

	static var previews: some View {
		ExampleStackItemView
			.preview { (patches: FeaturePatches) in
			}
	}
}
