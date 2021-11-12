//
//  not+RxCocoa.swift
//  RxSwiftExt
//
//  Created by Rafael Ferreira on 3/7/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxCocoa

public extension SharedSequenceConvertibleType where Element == Bool {
    /// Boolean not operator.
    func not() -> SharedSequence<SharingStrategy, Bool> {
        return map(!)
    }
}
