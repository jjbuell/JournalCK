//
//  DateFormatter.swift
//  JournalCK
//
//  Created by JJB on 5/10/21.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
