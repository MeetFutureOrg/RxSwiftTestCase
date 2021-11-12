//
//  CAAnimationUtils.swift
//  SwiftTestCase
//
//  Created by Sun on 2021/4/20.
//  Copyright © 2021 Appest. All rights reserved.
//

import UIKit

private class CALayerAnimationDelegate: NSObject, CAAnimationDelegate {
    private let keyPath: String?
    var completion: ((Bool) -> Void)?

    init(animation: CAAnimation, completion: ((Bool) -> Void)?) {
        if let animation = animation as? CABasicAnimation {
            keyPath = animation.keyPath
        } else {
            keyPath = nil
        }
        self.completion = completion

        super.init()
    }

    @objc func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let anim = anim as? CABasicAnimation {
            if anim.keyPath != keyPath {
                return
            }
        }
        if let completion = completion {
            completion(flag)
        }
    }
}

private let completionKey = "CAAnimationUtils_completion"

let kCAMediaTimingFunctionSpring = "CAAnimationUtilsSpringCurve"

extension CAAnimation {
    var completion: ((Bool) -> Void)? {
        get {
            if let delegate = delegate as? CALayerAnimationDelegate {
                return delegate.completion
            } else {
                return nil
            }
        } set(value) {
            if let delegate = delegate as? CALayerAnimationDelegate {
                delegate.completion = value
            } else {
                delegate = CALayerAnimationDelegate(animation: self, completion: value)
            }
        }
    }
}

extension CALayer {
    func makeAnimation(
        from: AnyObject,
        to: AnyObject,
        keyPath: String,
        timingFunction: String,
        duration: Double,
        delay: Double = 0.0,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) -> CAAnimation {
        if timingFunction == kCAMediaTimingFunctionSpring {
            let animation = makeSpringAnimation(keyPath)
            animation.fromValue = from
            animation.toValue = to
            animation.isRemovedOnCompletion = removeOnCompletion
            animation.fillMode = .forwards
            if let completion = completion {
                animation.delegate = CALayerAnimationDelegate(
                    animation: animation,
                    completion: completion
                )
            }

            let k = Float(UIView.animationDurationFactor())
            var speed: Float = 1.0
            if k != 0, k != 1 {
                speed = Float(1.0) / k
            }

            animation.speed = speed * Float(animation.duration / duration)
            animation.isAdditive = additive

            if !delay.isZero {
                animation.beginTime = CACurrentMediaTime() + delay * UIView
                    .animationDurationFactor()
                animation.fillMode = .both
            }

            return animation
        } else {
            let k = Float(UIView.animationDurationFactor())
            var speed: Float = 1.0
            if k != 0, k != 1 {
                speed = Float(1.0) / k
            }

            let animation = CABasicAnimation(keyPath: keyPath)
            animation.fromValue = from
            animation.toValue = to
            animation.duration = duration
            if let mediaTimingFunction = mediaTimingFunction {
                animation.timingFunction = mediaTimingFunction
            } else {
                animation
                    .timingFunction =
                    CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
            }
            animation.isRemovedOnCompletion = removeOnCompletion
            animation.fillMode = .forwards
            animation.speed = speed
            animation.isAdditive = additive
            if let completion = completion {
                animation.delegate = CALayerAnimationDelegate(
                    animation: animation,
                    completion: completion
                )
            }

            if !delay.isZero {
                animation.beginTime = CACurrentMediaTime() + delay * UIView
                    .animationDurationFactor()
                animation.fillMode = .both
            }

            return animation
        }
    }

    func animate(
        from: AnyObject,
        to: AnyObject,
        keyPath: String,
        timingFunction: String,
        duration: Double,
        delay: Double = 0.0,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        let animation = makeAnimation(
            from: from,
            to: to,
            keyPath: keyPath,
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            completion: completion
        )
        add(animation, forKey: additive ? nil : keyPath)
    }

    func animateGroup(_ animations: [CAAnimation], key: String) {
        let animationGroup = CAAnimationGroup()
        var timeOffset = 0.0
        for animation in animations {
            animation.beginTime += timeOffset
            timeOffset += animation.duration / Double(animation.speed)
        }
        animationGroup.animations = animations
        animationGroup.duration = timeOffset
        add(animationGroup, forKey: key)
    }

    func animateKeyframes(
        values: [AnyObject],
        duration: Double,
        keyPath: String,
        timingFunction: String = CAMediaTimingFunctionName.linear.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        let k = Float(UIView.animationDurationFactor())
        var speed: Float = 1.0
        if k != 0, k != 1 {
            speed = Float(1.0) / k
        }

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        var keyTimes: [NSNumber] = []
        for i in 0..<values.count {
            if i == 0 {
                keyTimes.append(0.0)
            } else if i == values.count - 1 {
                keyTimes.append(1.0)
            } else {
                keyTimes.append((Double(i) / Double(values.count - 1)) as NSNumber)
            }
        }
        animation.keyTimes = keyTimes
        animation.speed = speed
        animation.duration = duration
        animation.isAdditive = additive
        if let mediaTimingFunction = mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            animation
                .timingFunction =
                CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
        }
        animation.isRemovedOnCompletion = removeOnCompletion
        if let completion = completion {
            animation.delegate = CALayerAnimationDelegate(
                animation: animation,
                completion: completion
            )
        }

        add(animation, forKey: keyPath)
    }

    func animateSpring(
        from: AnyObject,
        to: AnyObject,
        keyPath: String,
        duration: Double,
        delay: Double = 0.0,
        initialVelocity: CGFloat = 0.0,
        damping: CGFloat = 88.0,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        let animation: CABasicAnimation
        if #available(iOS 9.0, *) {
            animation = makeSpringBounceAnimation(keyPath, initialVelocity, damping)
        } else {
            animation = makeSpringAnimation(keyPath)
        }
        animation.fromValue = from
        animation.toValue = to
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.fillMode = .forwards
        if let completion = completion {
            animation.delegate = CALayerAnimationDelegate(
                animation: animation,
                completion: completion
            )
        }

        let k = Float(UIView.animationDurationFactor())
        var speed: Float = 1.0
        if k != 0, k != 1 {
            speed = Float(1.0) / k
        }

        if !delay.isZero {
            animation.beginTime = CACurrentMediaTime() + delay * UIView.animationDurationFactor()
            animation.fillMode = .both
        }

        animation.speed = speed * Float(animation.duration / duration)
        animation.isAdditive = additive

        add(animation, forKey: keyPath)
    }

    func animateAdditive(
        from: NSValue,
        to: NSValue,
        keyPath: String,
        key: String,
        timingFunction: String,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        duration: Double,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        let k = Float(UIView.animationDurationFactor())
        var speed: Float = 1.0
        if k != 0, k != 1 {
            speed = Float(1.0) / k
        }

        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        if let mediaTimingFunction = mediaTimingFunction {
            animation.timingFunction = mediaTimingFunction
        } else {
            animation
                .timingFunction =
                CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: timingFunction))
        }
        animation.isRemovedOnCompletion = removeOnCompletion
        animation.fillMode = .forwards
        animation.speed = speed
        animation.isAdditive = true
        if let completion = completion {
            animation.delegate = CALayerAnimationDelegate(
                animation: animation,
                completion: completion
            )
        }

        add(animation, forKey: key)
    }

    func animateAlpha(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: NSNumber(value: Float(from)),
            to: NSNumber(value: Float(to)),
            keyPath: "opacity",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            completion: completion
        )
    }

    func animateScale(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: NSNumber(value: Float(from)),
            to: NSNumber(value: Float(to)),
            keyPath: "transform.scale",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            completion: completion
        )
    }

    func animateScaleY(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: NSNumber(value: Float(from)),
            to: NSNumber(value: Float(to)),
            keyPath: "transform.scale.y",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            completion: completion
        )
    }

    func animateRotation(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: NSNumber(value: Float(from)),
            to: NSNumber(value: Float(to)),
            keyPath: "transform.rotation.z",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            completion: completion
        )
    }

    func animatePosition(
        from: CGPoint,
        to: CGPoint,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        force: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        if from == to, !force {
            if let completion = completion {
                completion(true)
            }
            return
        }
        animate(
            from: NSValue(cgPoint: from),
            to: NSValue(cgPoint: to),
            keyPath: "position",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            completion: completion
        )
    }

    func animateBounds(
        from: CGRect,
        to: CGRect,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        force: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        if from == to, !force {
            if let completion = completion {
                completion(true)
            }
            return
        }
        animate(
            from: NSValue(cgRect: from),
            to: NSValue(cgRect: to),
            keyPath: "bounds",
            timingFunction: timingFunction,
            duration: duration,
            delay: delay,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            completion: completion
        )
    }

    func animateBoundsOriginXAdditive(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: from as NSNumber,
            to: to as NSNumber,
            keyPath: "bounds.origin.x",
            timingFunction: timingFunction,
            duration: duration,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: true,
            completion: completion
        )
    }

    func animateBoundsOriginYAdditive(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        timingFunction: String = CAMediaTimingFunctionName.easeInEaseOut.rawValue,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        completion: ((Bool) -> Void)? = nil
    ) {
        animate(
            from: from as NSNumber,
            to: to as NSNumber,
            keyPath: "bounds.origin.y",
            timingFunction: timingFunction,
            duration: duration,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: true,
            completion: completion
        )
    }

    func animateBoundsOriginXAdditive(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        mediaTimingFunction: CAMediaTimingFunction
    ) {
        animate(
            from: from as NSNumber,
            to: to as NSNumber,
            keyPath: "bounds.origin.x",
            timingFunction: CAMediaTimingFunctionName.easeInEaseOut.rawValue,
            duration: duration,
            mediaTimingFunction: mediaTimingFunction,
            additive: true
        )
    }

    func animateBoundsOriginYAdditive(
        from: CGFloat,
        to: CGFloat,
        duration: Double,
        mediaTimingFunction: CAMediaTimingFunction
    ) {
        animate(
            from: from as NSNumber,
            to: to as NSNumber,
            keyPath: "bounds.origin.y",
            timingFunction: CAMediaTimingFunctionName.easeInEaseOut.rawValue,
            duration: duration,
            mediaTimingFunction: mediaTimingFunction,
            additive: true
        )
    }

    func animatePositionKeyframes(
        values: [CGPoint],
        duration: Double,
        removeOnCompletion _: Bool = true,
        completion _: ((Bool) -> Void)? = nil
    ) {
        animateKeyframes(
            values: values.map { NSValue(cgPoint: $0) },
            duration: duration,
            keyPath: "position"
        )
    }

    func animateFrame(
        from: CGRect,
        to: CGRect,
        duration: Double,
        delay: Double = 0.0,
        timingFunction: String,
        mediaTimingFunction: CAMediaTimingFunction? = nil,
        removeOnCompletion: Bool = true,
        additive: Bool = false,
        force: Bool = false,
        completion: ((Bool) -> Void)? = nil
    ) {
        if from == to, !force {
            if let completion = completion {
                completion(true)
            }
            return
        }
        var interrupted = false
        var completedPosition = false
        var completedBounds = false
        let partialCompletion: () -> Void = {
            if interrupted || (completedPosition && completedBounds) {
                if let completion = completion {
                    completion(!interrupted)
                }
            }
        }

        var fromPosition = CGPoint(x: from.midX, y: from.midY)
        var toPosition = CGPoint(x: to.midX, y: to.midY)

        var fromBounds = CGRect(origin: bounds.origin, size: from.size)
        var toBounds = CGRect(origin: bounds.origin, size: to.size)

        if additive {
            fromPosition.x = -(toPosition.x - fromPosition.x)
            fromPosition.y = -(toPosition.y - fromPosition.y)
            toPosition = CGPoint()

            fromBounds.size.width = -(toBounds.width - fromBounds.width)
            fromBounds.size.height = -(toBounds.height - fromBounds.height)
            toBounds = CGRect()
        }

        animatePosition(
            from: fromPosition,
            to: toPosition,
            duration: duration,
            delay: delay,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            force: force,
            completion: { value in
                if !value {
                    interrupted = true
                }
                completedPosition = true
                partialCompletion()
            }
        )
        animateBounds(
            from: fromBounds,
            to: toBounds,
            duration: duration,
            delay: delay,
            timingFunction: timingFunction,
            mediaTimingFunction: mediaTimingFunction,
            removeOnCompletion: removeOnCompletion,
            additive: additive,
            force: force,
            completion: { value in
                if !value {
                    interrupted = true
                }
                completedBounds = true
                partialCompletion()
            }
        )
    }

    func cancelAnimationsRecursive(key: String) {
        removeAnimation(forKey: key)
        if let sublayers = sublayers {
            for layer in sublayers {
                layer.cancelAnimationsRecursive(key: key)
            }
        }
    }
}
