//
//  ignore.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 10/04/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import Foundation
import RxSwift

public extension ObservableType where Element: Equatable {
    func ignore(_ valuesToIgnore: Element...) -> Observable<Element> {
        return asObservable().filter { !valuesToIgnore.contains($0) }
    }

    func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> Observable<Element>
        where Sequence.Element == Element
    {
        return asObservable().filter { !valuesToIgnore.contains($0) }
    }
}
