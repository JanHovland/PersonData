//
//  NyPersonViewController.swift
//  PersonData
//
//  Created by Jan  on 09.04.2018.
//  Copyright © 2018 Jan . All rights reserved.
//

//Parenteser og skråstreker
//Mens tallrekka på tastaturet hvilket tegn du får om du holder shift inne mens du trykker på dem, er det ikke alle som vet følgende:
//
//Shift-7: /
//Alt-7: |
//Shift-alt-7: \
//
//På samme måte, med sifrene 8 og 9:
//Shift-8 / Shift-9: ( )
//Alt-8 / Alt-9: [ ]
//Shift-alt-8 / Shift-alt-9: { }

import UIKit
import CloudKit

class NyPersonViewController: UIViewController, UITextFieldDelegate {

    let database = CKContainer.default().privateCloudDatabase
    
    let datoValg = UIDatePicker()
    
    var personData = [CKRecord]()

    var activityIndicator = UIActivityIndicatorView()
    
    var kjonn: String = "Mann"
    
    @IBOutlet weak var navnTextField: UITextField!
    @IBOutlet weak var adresseTextField: UITextField!
    
    @IBOutlet weak var navnInput:  UITextField!
    
    @IBOutlet weak var adresseInput: UITextField!
    
    @IBOutlet weak var fodselsDatoInput: UITextField!
    
    @IBOutlet weak var kjonnInput: UISegmentedControl!
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        self.view.addSubview(activityIndicator)
        
        // Har endret slik at navn og adresse sine tastatur bruker return knappen
        // for å lukke tastaturet.
        // Må legge til UITextFieldDelegate i class NyPersonViewController
        // class NyPersonViewController: UIViewController, UITextFieldDelegate
        
        navnTextField.delegate = self
        adresseTextField.delegate = self

        // Legg inn fra tastatur
        // hentFraTastaturValg()      // Gjelder navn og adresse
        
        // Legg inn fra datovalg
        hentFraDatoValg()             // Gjelder fødselsdato
 
   }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navnTextField.resignFirstResponder()
        adresseTextField.resignFirstResponder()
      return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func saveToCloud(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let person = CKRecord(recordType: "PersonData")
        
        let navnStr = navnInput.text
        let adresseStr = adresseInput.text
        let fodselsStr = fodselsDatoInput.text
//        let kjonnStr = kjonn

        if (navnStr?.isEmpty)! || (adresseStr?.isEmpty)! || (fodselsStr?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Lagre data", message: "Du må legge inn både navn, adresse og fødselsdato", preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
            return()
            
        } else {
            
            activityIndicator.startAnimating()
            
            person.setObject(navnStr! as CKRecordValue, forKey: "Navn")
            person.setObject(adresseStr! as CKRecordValue, forKey: "Adresse")
            person.setObject(fodselsStr! as CKRecordValue, forKey: "DateOfBirth")
            person.setObject(kjonn as CKRecordValue, forKey: "Kjonn")
            database.save(person) { (record, error) in
                guard record != nil else { return }
            }
            
            self.activityIndicator.stopAnimating()
            print("saved record")
            
        }
        
        //  Blanke innholdet ved SaveToCloud
        self.navnInput.text = ""
        self.adresseInput.text = ""
        self.fodselsDatoInput.text = ""
        self.kjonn = "mann"

    }
    
//        func hentFraTastaturValg() {
//
//            // Lager en toolbar på toppen av tastaturet som  inneholder knappen ferdig
//
//            let toolBarNumber = UIToolbar()
//            toolBarNumber.sizeToFit()
//            let flexibleSpaceNumber = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
//                                                      target: nil, action: nil)
//
//            let ferdigButtonNumber = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
//                                                     target: self, action: #selector(self.skjulTastatur))
//
//            toolBarNumber.setItems([flexibleSpaceNumber, ferdigButtonNumber], animated: false)
//
//            navnInput.inputAccessoryView = toolBarNumber
//            adresseInput.inputAccessoryView = toolBarNumber
//        }
//
//        @objc func skjulTastatur() {
//            view.endEditing(true)
//        }
//
        func hentFraDatoValg() {
            let toolBarDatoValg = UIToolbar()
            toolBarDatoValg.sizeToFit()

            let flexibleSpaceDatoValg = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,                                                target: nil, action: nil)

            let ferdigButtonDatoValg = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                target: self, action: #selector(self.skjulDatoValg))

            toolBarDatoValg.setItems([flexibleSpaceDatoValg, ferdigButtonDatoValg], animated: false)

            fodselsDatoInput.inputAccessoryView = toolBarDatoValg
            fodselsDatoInput.inputView = datoValg
            datoValg.datePickerMode = .date
         }
    
        @objc func skjulDatoValg() {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            let datoString = formatter.string(from: datoValg.date)
            fodselsDatoInput.text = "\(datoString)"
            self.view.endEditing(true)
        }

    @IBAction func velgeKjonn(_ sender: UISegmentedControl) {
        
        switch kjonnInput.selectedSegmentIndex  {
        case 0: kjonn = "mann"
        case 1: kjonn = "kvinne"
        default: return
        }
        
    }
    
}
