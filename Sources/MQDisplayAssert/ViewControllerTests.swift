import MQDisplay
import MQAssert
import XCTest

open class ViewControllerTests: FeatureTests {
	
	public final func test<Controller>(
		_: Controller.Type,
		context: Controller.Context,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController {
		self.test(
			timeout: timeout,
			patches: patches,
			execute: { (testFeatures: DummyFeatures) throws -> Void in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						context: context,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller>(
		_: Controller.Type,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Controller.Context == Void {
		self.test(
			timeout: timeout,
			patches: patches,
			execute: { (testFeatures: DummyFeatures) throws -> Void in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned>(
		_: Controller.Type,
		context: Controller.Context,
		returnsEqual expected: Returned,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Returned: Equatable {
		self.test(
			timeout: timeout,
			patches: patches,
			returnsEqual: expected,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						context: context,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned>(
		_: Controller.Type,
		returnsEqual expected: Returned,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Controller.Context == Void, Returned: Equatable {
		self.test(
			timeout: timeout,
			patches: patches,
			returnsEqual: expected,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned, ExpectedError>(
		_: Controller.Type,
		context: Controller.Context,
		throws expected: ExpectedError.Type,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, ExpectedError: Error {
		self.test(
			timeout: timeout,
			patches: patches,
			throws: expected,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						context: context,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned, ExpectedError>(
		_: Controller.Type,
		throws expected: ExpectedError.Type,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Controller.Context == Void, ExpectedError: Error {
		self.test(
			timeout: timeout,
			patches: patches,
			throws: expected,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned>(
		_: Controller.Type,
		context: Controller.Context,
		executedPrepared expectedExecutionCount: UInt,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches, @escaping @Sendable () -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController {
		self.test(
			timeout: timeout,
			patches: patches,
			executedPrepared: expectedExecutionCount,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						context: context,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned>(
		_: Controller.Type,
		executedPrepared expectedExecutionCount: UInt,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches, @escaping @Sendable () -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Controller.Context == Void {
		self.test(
			timeout: timeout,
			patches: patches,
			executedPrepared: expectedExecutionCount,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned, Argument>(
		_: Controller.Type,
		context: Controller.Context,
		executedPreparedUsing expectedArgument: Argument,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches, @escaping @Sendable (Argument) -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) where Controller: ViewController, Argument: Equatable & Sendable {
		self.test(
			timeout: timeout,
			patches: patches,
			executedPreparedUsing: expectedArgument,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						context: context,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
	
	public final func test<Controller, Returned, Argument>(
		_: Controller.Type,
		executedPreparedUsing expectedArgument: Argument,
		timeout: TimeInterval = 0.5,
		when patches: @escaping (FeaturePatches, @escaping @Sendable (Argument) -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	)
	where
Controller: ViewController,
	Controller.Context == Void,
Argument: Equatable & Sendable
	{
		self.test(
			timeout: timeout,
			patches: patches,
			executedPreparedUsing: expectedArgument,
			execute: { (testFeatures: DummyFeatures) throws -> Returned in
				try await executing(
					testFeatures.instance(
						of: Controller.self,
						file: file,
						line: line
					)
				)
			},
			file: file,
			line: line
		)
	}
}
