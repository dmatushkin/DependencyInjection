//
//  DIProvider.swift
//  DependencyInjection
//
//  Created by Dmitry Matyushkin on 7/22/20.
//  Copyright © 2020 Dmitry Matyushkin. All rights reserved.
//

import Foundation

public protocol DIDependency {
	init()
}

public class DIProvider {

	enum DIRegistrationType {
		case dependency(type: DIDependency.Type)
		case lambda(value: () -> Any)
		case object(value: Any)
	}

	private init() {}

	public static let shared = DIProvider()
    private static let queue = DispatchQueue(label: "DIQueue")

	private var diMap: [String: DIRegistrationType] = [:]
	private var singletons: [String: DIDependency] = [:]
	private var lambdaValues: [String: Any] = [:]

	public func inject(forType type: Any, cacheType: DICacheType) -> Any? {
        let className = String(describing: type.self)
        guard let registration = diMap[className] else { return nil }
        switch registration {
        case .dependency(let type):
            if cacheType == .share {
                if let obj = singletons[className] {
                    return obj
                } else {
                    let obj = type.init()
                    singletons[className] = obj
                    return obj
                }
            } else {
                return type.init()
            }
        case .lambda(let value):
            if cacheType == .share {
                if let obj = lambdaValues[className] {
                    return obj
                } else {
                    let obj = value()
                    lambdaValues[className] = obj
                    return obj
                }
            } else {
                return value()
            }
        case .object(let value):
            return value
        }
	}

	@discardableResult
	public func register(forType type: Any, lambda: @escaping () -> Any) -> DIProvider {
		let className = String(describing: type.self)
		diMap[className] = .lambda(value: lambda)
		return self
	}

	@discardableResult
	public func register(forType type: Any, object: Any) -> DIProvider {
		let className = String(describing: type.self)
		diMap[className] = .object(value: object)
		return self
	}

	@discardableResult
	public func register(forType type: Any, dependency: DIDependency.Type) -> DIProvider {
		let className = String(describing: type.self)
		diMap[className] = .dependency(type: dependency)
		return self
	}

	public func clear() {
		diMap = [:]
		singletons = [:]
		lambdaValues = [:]
	}
}
