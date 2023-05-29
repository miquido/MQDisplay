import MQDisplay

enum ExampleStackItemViewDestination: TransitionDestination {

	typealias Context = ExampleStackItemViewController.Context
}

typealias TransitionToExampleStackItemView = TransitionTo<ExampleStackItemViewDestination>
