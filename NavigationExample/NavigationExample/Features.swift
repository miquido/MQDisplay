import MQDisplay

// This is example implementation of navigation, not a template for making
// appications using MQDo/MQDisplay - do not use treat this as a good example
// of setting up Features container tree and feature containers propagation
let features: Features = FeaturesRoot { (registry: inout FeaturesRegistry<RootFeaturesScope>) in
	registry.useWindowTransitionEngine { (registry: inout FeaturesRegistry<UIRootScope>) in
		registry.use(StackSheetPresentTransitionTo<ExampleStackViewDestination, ExampleStackItemView>.self)
		registry.use(PushTransitionTo<ExampleStackItemViewDestination, ExampleStackItemView>.self)
	}
}
