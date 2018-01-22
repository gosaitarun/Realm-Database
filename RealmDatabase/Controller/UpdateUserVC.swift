//
//  UpdateUserVC.swift
//  RealmDatabase
//
//  Created by Tarun on 20/01/18.
//  Copyright © 2018 Tarun. All rights reserved.
//

import UIKit
import RealmSwift

class UpdateUserVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    //MARK: Variable
    var arrayBank:Results<Bank>!
    var selectedUser:User!
    var selectedBank:Int!
    let realm = try! Realm()
    var pickerBank = UIPickerView()
    
    //MARK: IBOutlet
    @IBOutlet weak var textFieldUserId: UITextField!
    @IBOutlet weak var textFieldUserName: UITextField!
    @IBOutlet weak var textFieldSelectBank: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayBank = realm.objects(Bank.self)
        textFieldUserName.text = selectedUser.name
        textFieldUserId.text = String(selectedUser.id)
        textFieldSelectBank.text = selectedUser?.bank?.name
        selectedBank = arrayBank.index(of: (selectedUser?.bank)!)
        textFieldSelectBank.inputView = pickerBank
        pickerBank.delegate = self
        pickerBank.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Button Actions
    
    @IBAction func buttonUpdateUserClicked(_ sender: UIButton) {
        if textFieldUserId.text?.characters.count != 0 && textFieldUserName.text?.characters.count != 0 && textFieldSelectBank.text?.characters.count != 0 {
            try! realm.write {
                selectedUser?.id = Int(textFieldUserId.text!)!
                selectedUser?.name = textFieldUserName.text!
                selectedUser?.bank = arrayBank[selectedBank]
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            showAlert(title: "Realm", message: "Please enter all the detail.")
        }
    }
    
    //MARK: TextFieldDelegate Method
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerBank.selectRow(selectedBank, inComponent: 0, animated: true)
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
