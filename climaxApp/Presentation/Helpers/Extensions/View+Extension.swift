//
//  View+Extension.swift
//  climaxApp
//
//  Created by Juan Felipe Torres on 2/02/25.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condiion evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
