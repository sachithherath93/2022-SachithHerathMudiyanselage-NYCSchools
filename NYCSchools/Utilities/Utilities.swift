//
//  Utilities.swift
//  NYCSchools
//
//  Created by Sachith H on 5/18/22.
//

// Helper functions
import Foundation
import UIKit

extension String {
    // Unwanted character cleanup for some strings returned from the API
    func removeUnwantedCharacters() -> Self {
        return self.replacingOccurrences(of:"[^a-z,. ^A-Z^0-9]", with: "", options: .regularExpression)
    }
    
    func removeNoneEmail() -> Self {
        return self.replacingOccurrences(of:"[^a-z^@^., -^A-Z^0-9]", with: "", options: .regularExpression)
    }
    
    func removeNonNumeric() -> Self {
        return self.replacingOccurrences(of:"[^0-9.]", with: "", options: .regularExpression)
    }
    
    func removeNonPhoneNumber() -> Self {
        return self.replacingOccurrences(of:"[^0-9 -]", with: "", options: .regularExpression)
    }
    
    // Source - stackOverflow
    func capitalizingFirstLetter() -> Self {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst()
        return first + other
    }
}

extension UIView {
    func pinToSuperView(_ superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        let viewConstraints: [NSLayoutConstraint] = [self.topAnchor.constraint(equalTo: superView.topAnchor), self.leftAnchor.constraint(equalTo: superView.leftAnchor), self.bottomAnchor.constraint(equalTo: superView.bottomAnchor), self.rightAnchor.constraint(equalTo: superView.rightAnchor)]
        NSLayoutConstraint.activate(viewConstraints)
    }
}
