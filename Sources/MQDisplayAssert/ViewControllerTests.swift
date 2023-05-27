import MQAssert
import MQDisplay
import XCTest

open class ViewControllerTests: FeatureTests {

	public final func test<Controller>(
		_: Controller.Type,
		context: Controller.Context,
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController {
		await self.test(
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
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Void,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Controller.Context == Void {
		await self.test(
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
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Returned: Equatable {
		await self.test(
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
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Controller.Context == Void, Returned: Equatable {
		await self.test(
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
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, ExpectedError: Error {
		await self.test(
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
		when patches: @escaping (FeaturePatches) -> Void = {
			(_: FeaturePatches) -> Void in /* noop */
		},
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Controller.Context == Void, ExpectedError: Error {
		await self.test(
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
		when patches: @escaping (FeaturePatches, @escaping @Sendable () -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController {
		await self.test(
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
		when patches: @escaping (FeaturePatches, @escaping @Sendable () -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Controller.Context == Void {
		await self.test(
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
		when patches: @escaping (FeaturePatches, @escaping @Sendable (Argument) -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async where Controller: ViewController, Argument: Equatable & Sendable {
		await self.test(
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
		when patches: @escaping (FeaturePatches, @escaping @Sendable (Argument) -> Void) -> Void,
		executing: @escaping (Controller) async throws -> Returned,
		file: StaticString = #fileID,
		line: UInt = #line
	) async
	where
		Controller: ViewController,
		Controller.Context == Void,
		Argument: Equatable & Sendable
	{
		await self.test(
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
