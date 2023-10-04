//
//  String+Localizable.swift
//  Quiz
//
//  Created by Magda Pękacka on 04/10/2023.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString( self,tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
