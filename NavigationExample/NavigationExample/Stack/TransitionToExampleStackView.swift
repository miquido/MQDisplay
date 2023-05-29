import MQDisplay

enum ExampleStackViewDestination: TransitionDestination {

	typealias Context = ExampleStackItemViewController.Context
}

typealias TransitionToExampleStackView = TransitionTo<ExampleStackViewDestination>

