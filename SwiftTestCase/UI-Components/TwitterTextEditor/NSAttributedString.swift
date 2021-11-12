//
//  NSAttributedString.swift
//  TwitterTextEditor
//
//  Copyright 2021 Twitter, Inc.
//  SPDX-License-Identifier: Apache-2.0
//

import Foundation

private extension Dictionary where Key == NSAttributedString.Key {
    var shortDescription: String {
        let attributeDescriptions: [String]
        if let attributeNames = Configuration.shared
            .attributeNamesDescribedForAttributedStringShortDescription
        {
            attributeDescriptions = map { attribute in
                attributeNames
                    .contains(attribute.key) ? "\(attribute.key.rawValue): \(attribute.value)" :
                    attribute.key.rawValue
            }
        } else {
            attributeDescriptions = keys.map { key in
                key.rawValue
            }
        }
        return "{\(attributeDescriptions.joined(separator: ", "))}"
    }
}

extension NSAttributedString {
    private var shortDescription: String {
        guard length > 0 else {
            return ""
        }

        // Mostly same implementation as original `description`
        var description = String()
        var index = 0
        var effectiveRange: NSRange = .zero
        repeat {
            let attributes = self.attributes(at: index, effectiveRange: &effectiveRange)
            description.append(string.substring(with: effectiveRange))
            description.append(attributes.shortDescription)
            index = effectiveRange.upperBound
        } while index < length

        return description
    }

    var loggingDescription: CustomStringConvertible & CVarArg {
        guard Configuration.shared.isAttributedStringShortDescriptionForLoggingEnabled else {
            return self
        }

        return CustomDescribing(self) { attributedString in
            attributedString.shortDescription
        }
    }
}
