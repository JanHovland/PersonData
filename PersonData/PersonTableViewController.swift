//
//  PersonTableViewController.swift
//  PersonData
//
//  Created by Jan  on 07.04.2018.
//  Copyright © 2018 Jan . All rights reserved.
//

import UIKit
import CloudKit
class PersonTableViewController: UITableViewController, UITextFieldDelegate {
    
    let database = CKContainer.default().privateCloudDatabase
    
    var personData = [CKRecord]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Skyv nedover for å hente data")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        queryDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if (tableView.numberOfSections == 0) {
            return 1
        } else {
            return tableView.numberOfSections
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personData.count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Slett") { (action, sourceView, completionHandler) in
            
            let record = self.personData[indexPath.row]
            self.database.delete(withRecordID: record.recordID) { (recordID, error) in
                DispatchQueue.main.async {
                    if (error != nil) {
                        print ("error")
                    } else {
                        print ("Posten er slettet")
                        self.personData.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade )
                        
                    }
                }
            }
            
        }
        
        // Customize the action buttons
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "Slett")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PersonTableViewCell

        let navn = personData[indexPath.row].value(forKey: "Navn") as! String
        cell.navnLabel?.text = navn
        let adresse = personData[indexPath.row].value(forKey: "Adresse") as! String
        cell.adresseLabel?.text = adresse
        let fodselsDato = personData[indexPath.row].value(forKey: "DateOfBirth") as! String
        cell.fodselsLabel?.text = fodselsDato

        return cell
    }

    @objc func queryDatabase() {
    
        let predicate = NSPredicate(value: true)
    
        let query = CKQuery(recordType: "PersonData", predicate: predicate)
    
        database.perform(query, inZoneWith: nil) { (records, _) in
                guard let records = records else { return }
    
                let sortedRecords = records.sorted(by: { $0.creationDate! < $1.creationDate! })
                self.personData = sortedRecords
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
        }
    }

    
}
