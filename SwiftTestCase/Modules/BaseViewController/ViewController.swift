//
//  ViewController.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

import AsyncDisplayKit
import RxSwift
import UIKit

protocol StandalonePresentableController: ViewController {}

private func findCurrentResponder(_ view: UIView) -> UIResponder? {
    if view.isFirstResponder {
        return view
    } else {
        for subview in view.subviews {
            if let result = findCurrentResponder(subview) {
                return result
            }
        }
        return nil
    }
}

private func findWindow(_ view: UIView) -> WindowHost? {
    if let view = view as? WindowHost {
        return view
    } else if let superview = view.superview {
        return findWindow(superview)
    } else {
        return nil
    }
}

enum ViewControllerPresentationAnimation {
    case none
    case modalSheet
}

struct ViewControllerSupportedOrientations: Equatable {
    var regularSize: UIInterfaceOrientationMask
    var compactSize: UIInterfaceOrientationMask

    init(regularSize: UIInterfaceOrientationMask, compactSize: UIInterfaceOrientationMask) {
        self.regularSize = regularSize
        self.compactSize = compactSize
    }

    func intersection(_ other: ViewControllerSupportedOrientations)
        -> ViewControllerSupportedOrientations
    {
        return ViewControllerSupportedOrientations(
            regularSize: regularSize.intersection(other.regularSize),
            compactSize: compactSize.intersection(other.compactSize)
        )
    }
}

class ViewControllerPresentationArguments {
    let presentationAnimation: ViewControllerPresentationAnimation
    let completion: (() -> Void)?

    init(
        presentationAnimation: ViewControllerPresentationAnimation,
        completion: (() -> Void)? = nil
    ) {
        self.presentationAnimation = presentationAnimation
        self.completion = completion
    }
}

enum ViewControllerNavigationPresentation {
    case `default`
    // swiftlint:disable inclusive_language
    case master
    // swiftlint:enable inclusive_language
    case modal
    case flatModal
    case standaloneModal
    case modalInLargeLayout
}

enum TabBarItemContextActionType {
    case none
    case always
    case whenActive
}

class ViewController: ASDKViewController<ASDisplayNode> {

    override init() {
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let list1 = [10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26]
        let result = quicksort(list1)
        print(result)
        var list2 = [10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8]
        quicksortLomuto(&list2, low: 0, high: list2.count - 1)
        print(list2)
        var list3 = [8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26]
        quicksortHoare(&list3, low: 0, high: list3.count - 1)
        print(list3)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    func quicksort<T: Comparable>(_ a: [T]) -> [T] {
        guard a.count > 1 else { return a }

        let pivot = a[a.count / 2]
        let less = a.filter { $0 < pivot }
        let equal = a.filter { $0 == pivot }
        let greater = a.filter { $0 > pivot }

        return quicksort(less) + equal + quicksort(greater)
    }

    // *** Using Lomuto partitioning ***
    /*
       Lomuto's partitioning algorithm.
       The return value is the index of the pivot element in the new array. The left
       partition is [low...p-1]; the right partition is [p+1...high], where p is the
       return value.
     */
    func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
        let pivot = a[high]

        var i = low
        for j in low..<high {
            if a[j] <= pivot {
                a.swapAt(i, j)
                i += 1
            }
        }

        a.swapAt(i, high)
        return i
    }

//    var list2 = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
//    partitionLomuto(&list2, low: 0, high: list2.count - 1)
//    list2
//
    func quicksortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
        if low < high {
            let p = partitionLomuto(&a, low: low, high: high)
            quicksortLomuto(&a, low: low, high: p - 1)
            quicksortLomuto(&a, low: p + 1, high: high)
        }
    }

//
//    quicksortLomuto(&list2, low: 0, high: list2.count - 1)
//
//    // *** Hoare partitioning ***
//    /*
//      Hoare's partitioning scheme.
//      The return value is NOT necessarily the index of the pivot element in the
//      new array. Instead, the array is partitioned into [low...p] and [p+1...high],
//      where p is the return value. The pivot value is placed somewhere inside one
//      of the two partitions, but the algorithm doesn't tell you which one or where.
//    */
    func partitionHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
        let pivot = a[low]
        var i = low - 1
        var j = high + 1

        while true {
            repeat { j -= 1 } while a[j] > pivot
            repeat { i += 1 } while a[i] < pivot

            if i < j {
                a.swapAt(i, j)
            } else {
                return j
            }
        }
    }

//
//    var list3 = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
//    partitionHoare(&list3, low: 0, high: list3.count - 1)
//    list3
//
    func quicksortHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
        if low < high {
            let p = partitionHoare(&a, low: low, high: high)
            quicksortHoare(&a, low: low, high: p)
            quicksortHoare(&a, low: p + 1, high: high)
        }
    }
//
//    quicksortHoare(&list3, low: 0, high: list3.count - 1)
//
//    // *** Randomized sorting ***
//    /* Returns a random integer in the range min...max, inclusive. */
//    public func random(min: Int, max: Int) -> Int {
//      assert(min < max)
//      return min + Int(arc4random_uniform(UInt32(max - min + 1)))
//    }
//
//    func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
//      if low < high {
//        let pivotIndex = random(min: low, max: high)
//        (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
//
//        let p = partitionLomuto(&a, low: low, high: high)
//        quicksortRandom(&a, low: low, high: p - 1)
//        quicksortRandom(&a, low: p + 1, high: high)
//      }
//    }
//
//    var list4 = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
//    quicksortRandom(&list4, low: 0, high: list4.count - 1)
//    list4
//
//    // *** Dutch national flag partioning ***
//    /*
//      Swift's swap() doesn't like it if the items you're trying to swap refer to
//      the same memory location. This little wrapper simply ignores such swaps.
//    */
//    public func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
//      if i != j {
//        a.swapAt(i, j)
//      }
//    }
//
//    /*
//      Dutch national flag partitioning.
//      Returns a tuple with the start and end index of the middle area.
//    */
//    func partitionDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
//      let pivot = a[pivotIndex]
//
//      var smaller = low
//      var equal = low
//      var larger = high
//
//      while equal <= larger {
//        if a[equal] < pivot {
//          swap(&a, smaller, equal)
//          smaller += 1
//          equal += 1
//        } else if a[equal] == pivot {
//          equal += 1
//        } else {
//          swap(&a, equal, larger)
//          larger -= 1
//        }
//      }
//      return (smaller, larger)
//    }
//
//    var list5 = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
//    partitionDutchFlag(&list5, low: 0, high: list5.count - 1, pivotIndex: 10)
//    list5
//
//    func quicksortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
//      if low < high {
//        let pivotIndex = random(min: low, max: high)
//        let (p, q) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
//        quicksortDutchFlag(&a, low: low, high: p - 1)
//        quicksortDutchFlag(&a, low: q + 1, high: high)
//      }
//    }
//
//    quicksortDutchFlag(&list5, low: 0, high: list5.count - 1)
}
