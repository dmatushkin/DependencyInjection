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

	private let cacheType: DICacheType

	public init(cacheType: DICacheType = .local) {
		self.cacheType = cacheType
	}

	private var value: T?
	public var wrappedValue: T {
		mutating get {
			if cacheType == .local, let value = value {
				return value
			}
			guard let value = DIProvider.shared.inject(forType: T.self, cacheType: cacheType) as? T else { fatalError("Dependency of type \(T.self) not found")}
			if cacheType == .local {
				self.value = value
			}
			return value
		}
	}
}
