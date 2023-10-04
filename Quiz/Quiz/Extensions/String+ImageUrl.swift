//
//  String+ImageUrl.swift
//  Quiz
//
//  Created by Magda Pękacka on 02/10/2023.
//

import Foundation

extension String {
    func modifyImageUrl(width: Int, height: Int) -> String? {
        guard let urlString = extractStringAfterHttp() else {
            return nil
        }
        
        return "https://i.wpimg.pl/\(width)x\(height)/\(urlString)"
    }
    
    private func extractStringAfterHttp() -> String? {
        if let range = self.range(of: "https://") {
            let substring = String(self[range.upperBound...])
            return substring
        } else {
            return nil
        }
    }
}
