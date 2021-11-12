//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Thane Gill on 18/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType where Element == Bool {
    /// Boolean not operator
    func not() -> Observable<Bool> {
        return map(!)
    }
}
