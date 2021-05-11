//
//  EntryController.swift
//  JournalCK
//
//  Created by JJB on 5/10/21.
//

import Foundation
import CloudKit

class EntryController {
    
    //MARK: - SharedInstance
    static let shared = EntryController()
    
    
    //MARK: - Source of Truth
    var entries: [Entry] = []
    
    
    //MARK: - DBProperty
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    //MARK: - Functions CRUD
    func createEntryWith(title: String, body: String, completion: @escaping(_ result: Result<Entry?, EntryError>) -> Void) {
        
        let newEntry = Entry(title: title, body: body)
        save(entry: newEntry, completion: completion)
        
    }
    
    func save(entry: Entry, completion: @escaping(_ result: Result<Entry?, EntryError>) -> Void) {
        
        let entryRecord = CKRecord(entry: entry)
        privateDB.save(entryRecord) { (record, error) in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
                return
            }
            
            guard let record = record,
                  let savedEntry = Entry(ckRecord: record)
            else {completion(.failure(.couldNotUnwrap)); return}
            print("New entry saved successfully")
            
            self.entries.insert(savedEntry, at: 0)
            completion(.success(savedEntry))
        }
    }
    
    func fetchEntriesWith(completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: EntryConstants.RecordTypeKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { records, error in
            
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { completion(.failure(.couldNotUnwrap)); return }
            
            print("Successfully fetched all Entries")
            
            let fetchedEntries = records.compactMap { Entry(ckRecord: $0)}
            
            self.entries = fetchedEntries
            completion(.success(self.entries))
        }
    }
} //End of class
