//
//  Autowired.swift
//  DependencyInjection
//
//  Created by Dmitry Matyushkin on 7/22/20.
//  Copyright © 2020 Dmitry Matyushkin. All rights reserved.
//

import Foundation

@propertyWrapper
public struct Autowired<T> {
	public init() {
	}
	private var value: T?
	public var wrappedValue: T {
		mutating get {
			if let value = value {
				return value
			}
			guard let value = DIProvider.shared.inject(forType: T.self) as? T else { fatalError("Dependency of type \(T.self) not found")}
			self.value = value
			return value
		}
	}
}
