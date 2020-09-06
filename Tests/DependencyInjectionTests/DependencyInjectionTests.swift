import XCTest
@testable import DependencyInjection

private protocol TestInterface {
	func createString() -> String
}

private class TestImplementation: TestInterface, DIDependency {
	required init() {}
	func createString() -> String {
		return "testString"
	}
}

final class DependencyInjectionTests: XCTestCase {

	@Autowired
	private var testVarDependency: TestInterface
	@Autowired
	private var testVarLambda: TestInterface
	@Autowired
	private var testVarObject: TestInterface

	func testDependency() {
		DIProvider.shared.register(forType: TestInterface.self, dependency: TestImplementation.self)
		XCTAssertEqual(testVarDependency.createString(), "testString")
		DIProvider.shared.clear()
	}

	func testLambda() {
		DIProvider.shared.register(forType: TestInterface.self, lambda: { return TestImplementation() })
		XCTAssertEqual(testVarLambda.createString(), "testString")
		DIProvider.shared.clear()
	}

	func testObject() {
		DIProvider.shared.register(forType: TestInterface.self, object: TestImplementation())
		XCTAssertEqual(testVarObject.createString(), "testString")
		DIProvider.shared.clear()
	}

	static var allTests = [
		("testDependency", testDependency),
		("testLambda", testLambda),
		("testObject", testObject)
	]
}
