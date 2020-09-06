import XCTest
@testable import DependencyInjection

private protocol TestInterface {
	func createString() -> String
}

private class TestImplementation: TestInterface, DIDependency {
	private let value: String
	required init() { self.value = "testString"}
	init(value: String) { self.value = value }
	func createString() -> String {
		return value
	}
}

private class TestImplementation2: TestInterface, DIDependency {
	required init() {}
	func createString() -> String {
		return "testString2"
	}
}

final class DependencyInjectionTests: XCTestCase {

	@Autowired(cacheType: .none)
	private var testVar: TestInterface
	@Autowired(cacheType: .share)
	private var testVarShared: TestInterface
	@Autowired(cacheType: .local)
	private var testVarLocal: TestInterface

	func testDependency() {
		DIProvider.shared.register(forType: TestInterface.self, dependency: TestImplementation.self)
		XCTAssertEqual(testVar.createString(), "testString")
		DIProvider.shared.clear()
	}

	func testLambda() {
		DIProvider.shared.register(forType: TestInterface.self, lambda: { return TestImplementation(value: "testStringLambda") })
		XCTAssertEqual(testVar.createString(), "testStringLambda")
		DIProvider.shared.clear()
	}

	func testObject() {
		DIProvider.shared.register(forType: TestInterface.self, object: TestImplementation(value: "testStringObject"))
		XCTAssertEqual(testVar.createString(), "testStringObject")
		DIProvider.shared.clear()
	}

	func testSharedVar() {
		DIProvider.shared.register(forType: TestInterface.self, dependency: TestImplementation.self)
		XCTAssertEqual(testVarLocal.createString(), "testString")
		XCTAssertEqual(testVarShared.createString(), "testString")
		DIProvider.shared.clear()
		DIProvider.shared.register(forType: TestInterface.self, lambda: { return TestImplementation(value: "testStringLambda") })
		XCTAssertEqual(testVarLocal.createString(), "testString")
		XCTAssertEqual(testVarShared.createString(), "testStringLambda")
	}

	func testNonSharedVar() {
		DIProvider.shared.register(forType: TestInterface.self, lambda: { return TestImplementation(value: "testString") })
		XCTAssertEqual(testVar.createString(), "testString")
		XCTAssertEqual(testVarShared.createString(), "testString")
		DIProvider.shared.register(forType: TestInterface.self, lambda: { return TestImplementation(value: "testStringLambda") })
		XCTAssertEqual(testVar.createString(), "testStringLambda")
		XCTAssertEqual(testVarShared.createString(), "testString")
	}

	func testNonSharedDependencyVar() {
		DIProvider.shared.register(forType: TestInterface.self, dependency: TestImplementation.self)
		XCTAssertEqual(testVar.createString(), "testString")
		XCTAssertEqual(testVarShared.createString(), "testString")
		DIProvider.shared.register(forType: TestInterface.self, dependency: TestImplementation2.self)
		XCTAssertEqual(testVar.createString(), "testString2")
		XCTAssertEqual(testVarShared.createString(), "testString")
	}

	static var allTests = [
		("testDependency", testDependency),
		("testLambda", testLambda),
		("testObject", testObject),
		("testSharedVar", testSharedVar),
		("testNonSharedVar", testNonSharedVar),
		("testNonSharedDependencyVar", testNonSharedDependencyVar)
	]
}
