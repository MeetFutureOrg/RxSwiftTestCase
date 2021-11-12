//
//  ofType.swift
//  RxSwiftExt
//
//  Created by Nate Kim on 19/01/2018.
//  Copyright © 2018 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType {
    /**
     Filters the elements of an observable sequence, if that is an instance of the supplied type.

     - seealso: [filter operator on reactivex.io](http://reactivex.io/documentation/operators/filter.html)

     - parameter type: The Type to filter each source element.
     - returns: An observable sequence that contains elements which is an instance of the suppplied type.
     */
    func ofType<Result>(_: Result.Type) -> Observable<Result> {
        return filterMap {
            guard let result = $0 as? Result else { return .ignore }
            return .map(result)
        }
    }
}
