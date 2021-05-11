//
//  Entry.swift
//  JournalCK
//
//  Created by JJB on 5/10/21.
//

import Foundation
import CloudKit


//MARK: - String Constants
struct EntryConstants {
    static let TitleKey = "title"
    static let BodyKey = "body"
    static let TimeStampKey = "timeStamp"
    static let RecordTypeKey = "Entry"
}


//MARK: - Entry Class
class Entry {
    
    let title: String
    let body: String
    let timeStamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timeStamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timeStamp = timeStamp
        self.ckRecordID = ckRecordID
    }
} //End of class


//MARK: - Extensions
extension Entry {
    convenience init?(ckRecord: CKRecord){
        guard let title = ckRecord[EntryConstants.TitleKey] as? String,
              let body = ckRecord[EntryConstants.BodyKey] as? String,
              let timeStamp = ckRecord[EntryConstants.TimeStampKey] as? Date
        else {return nil}
        
        self.init(title: title, body: body, timeStamp: timeStamp, ckRecordID: ckRecord.recordID)
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}

extension CKRecord{
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.RecordTypeKey, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.TitleKey)
        self.setValue(entry.body, forKey: EntryConstants.BodyKey)
        self.setValue(entry.timeStamp, forKey: EntryConstants.TimeStampKey)
    }
}
