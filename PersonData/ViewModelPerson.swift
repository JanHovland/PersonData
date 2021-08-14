//
//  ViewModelPerson.swift
//  ViewModelPerson
//
//  Created by Jan Hovland on 14/08/2021.
//

import os.log
import CloudKit

class ViewModelPerson: ObservableObject {

    // MARK: - Properties

    /// The CloudKit container to use. Update with your own container identifier.
    private let container = CKContainer(identifier: Config.containerIdentifier)

    /// This sample uses the private database, which requires a logged in iCloud account.
    private lazy var database = container.privateCloudDatabase

    /// This sample uses a singleton record ID, referred to by this property.
    /// CloudKit uses `CKRecord.ID` objects to represent record IDs.
    private let lastPersonRecordID: CKRecord.ID

    /// Publish the fetched last person to our view.
    @Published var lastPerson = String()

    // MARK: - Init

    init(isTesting: Bool = false) {
        // Use a different unique record ID if testing.
        lastPersonRecordID = CKRecord.ID(recordName: isTesting ? "lastPersonTest" : "lastPerson")
        // getLastPerson()
    }
    
    func deleteLastPerson() async throws {
        do {
            try await database.deleteRecord(withID: lastPersonRecordID)
            // os_log("Record with ID \(recordId) was deleted.")
            os_log("Record was deleted.")
        } catch {
            self.reportError(error)
            throw error
        }
    }
    
    func savePerson() async throws {
        
        // let personID = CKRecord.ID(recordName: lastPersonRecordID)
        let personRecord = CKRecord(recordType: "Person", recordID: lastPersonRecordID)
        personRecord["name"] = "lastPerson"

        do {
            let recordId = try await database.save(personRecord)
            os_log("Record with ID \(recordId) was saved.")
        } catch {
            self.reportError(error)
            throw error
        }
    }
    
    private func reportError(_ error: Error) {
        guard let ckerror = error as? CKError else {
            os_log("Not a CKError: \(error.localizedDescription)")
            return
        }

        switch ckerror.code {
        case .partialFailure:
            // Iterate through error(s) in partial failure and report each one.
            let dict = ckerror.userInfo[CKPartialErrorsByItemIDKey] as? [NSObject: CKError]
            if let errorDictionary = dict {
                for (_, error) in errorDictionary {
                    reportError(error)
                }
            }

        // This switch could explicitly handle as many specific errors as needed, for example:
        case .unknownItem:
            os_log("CKError: Record not found.")

        case .notAuthenticated:
            os_log("CKError: An iCloud account must be signed in on device or Simulator to write to a PrivateDB.")

        case .permissionFailure:
            os_log("CKError: An iCloud account permission failure occured.")

        case .networkUnavailable:
            os_log("CKError: The network is unavailable.")

        default:
            os_log("CKError: \(error.localizedDescription)")
        }
    }



}
