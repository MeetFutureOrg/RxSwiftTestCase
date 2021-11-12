//
//  catchErrorJustComplete.swift
//  RxSwiftExt
//
//  Created by Florent Pillet on 21/05/16.
//  Copyright © 2016 RxSwift Community. All rights reserved.
//

import RxSwift

public extension ObservableType {
    /**
     Dismiss errors and complete the sequence instead

     - returns: An observable sequence that never errors and completes when an error occurs in the underlying sequence
     */
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            Observable.empty()
        }
    }
}
