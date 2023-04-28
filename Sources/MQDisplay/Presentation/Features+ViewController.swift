import MQDo

extension Features {
	
  @inline(__always) @_transparent
	public func instance<Controller>(
		of: Controller.Type = Controller.self,
		context: Controller.Context,
		file: StaticString = #fileID,
		line: UInt = #line
	) throws -> Controller
	where Controller: ViewController {
		do {
			return try Controller(
				with: context,
				using: self
			)
		}
		catch {
			throw
			error
				.asTheError()
				.appending(
					.message(
						"Loading ViewController failed",
						file: file,
						line: line
					)
					.with(
						context,
						for: "ViewController.Context"
					)
					.with(
						"\(Controller.self)",
						for: "ViewController"
					)
				)
		}
	}
	
  @inline(__always) @_transparent
	public func instance<Controller>(
		of: Controller.Type = Controller.self,
		file: StaticString = #fileID,
		line: UInt = #line
	) throws -> Controller
	where Controller: ViewController, Controller.Context == Void {
		try self.instance(
			of: Controller.self,
			context: Void(),
			file: file,
			line: line
		)
	}
}
