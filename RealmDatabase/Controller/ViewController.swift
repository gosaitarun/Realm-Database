//
//  ViewController.swift
//  RealmDatabase
//
//  Created by Tarun on 22/01/18.
//  Copyright © 2018 Tarun. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    //MARK: Variable
    let realm = try! Realm()
    var arrayBank:Results<Bank>!
    var selectedBank:Int!
    var pickerBank = UIPickerView()
    
    //MARK: IBOutlet
    @IBOutlet weak var textFieldBankId: UITextField!
    @IBOutlet weak var textFieldBankName: UITextField!
    @IBOutlet weak var textFieldUserId: UITextField!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldSelectBank: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Realm Database Path: \(String(describing: realm.configuration.fileURL?.absoluteString))")
        textFieldSelectBank.inputView = pickerBank
        pickerBank.delegate = self
        pickerBank.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Button Actions Mathod
    
    @IBAction func buttonBankClicked(_ sender: UIButton) {
        if textFieldBankId.text?.characters.count != 0 && textFieldBankName.text?.characters.count != 0 {
            try! realm.write {
                let bank = Bank()
                bank.id = Int(textFieldBankId.text!)!
                bank.name = textFieldBankName.text!
                realm.add(bank)
                
                showAlert(title: "Realm", message: "Bank Added Successfully")
                textFieldBankId.text = ""
                textFieldBankName.text = ""
            }
        } else {
            showAlert(title: "Realm", message: "Please enter all the detail.")
        }
    }
    
    @IBAction func buttonAddUserClicked(_ sender: UIButton) {
        if textFieldUserId.text?.characters.count != 0 && textFieldUserName.text?.characters.count != 0 && textFieldSelectBank.text?.characters.count != 0 {
            try! realm.write {
                let user = User()
                user.id = Int(textFieldUserId.text!)!
                user.name = textFieldUserName.text!
                user.bank = arrayBank[selectedBank]
                realm.add(user)
                
                showAlert(title: "Realm", message: "User Added Successfully")
                textFieldUserId.text = ""
                textFieldUserName.text = ""
                textFieldSelectBank.text = ""
            }
        } else {
            showAlert(title: "Realm", message: "Please enter all the detail.")
        }
    }
    
    //MARK: TextField Delegate Method
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        arrayBank = realm.objects(Bank.self)
        return true
    }
    
    //MARK: Picker Delegate Method
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (arrayBank != nil) ? arrayBank.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayBank[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBank = row
        textFieldSelectBank.text = arrayBank[row].name
    }
}

extension UIViewController {
    
    func showAlert(title:String,message:String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
}
