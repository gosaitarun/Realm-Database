//
//  UserListVC.swift
//  RealmDatabase
//
//  Created by Tarun on 20/01/18.
//  Copyright © 2018 Tarun. All rights reserved.
//

import UIKit
import RealmSwift

class UserListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Variable
    let relam = try! Realm()
    var arrayUser:Results<User>!
    
    //MARK: IBOutlet
    @IBOutlet weak var tableViewUserList:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayUser = relam.objects(User.self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewUserList.reloadData()
    }
    
    //MARK: Button Actions
    
    @IBAction func buttonSortClicked(_ sender: UIButton) {
        let option = UIAlertController(title: "Select Sort", message: nil, preferredStyle: .actionSheet)
        option.addAction(UIAlertAction(title: "Ascending", style: .default, handler: { (action) in
            self.arrayUser = self.relam.objects(User.self).sorted(byKeyPath: "name", ascending: true)
            self.tableViewUserList.reloadData()
        }))
        option.addAction(UIAlertAction(title: "Descending", style: .default, handler: { (action) in
            self.arrayUser = self.relam.objects(User.self).sorted(byKeyPath: "name", ascending: false)
            self.tableViewUserList.reloadData()
        }))
        option.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(option, animated: true, completion: nil)
    }
    
    //MARK: TableView Delegate And DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrayUser != nil) ? arrayUser.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let labelName = cell?.viewWithTag(1) as? UILabel
        labelName?.text = arrayUser[indexPath.row].name
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            try! self.relam.write {
                self.relam.delete(self.arrayUser[indexPath.row])
                self.tableViewUserList.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.performSegue(withIdentifier: "showUserList", sender: indexPath.row)
        }
        return [deleteAction,editAction]
    }
    
    //MARK: Segue Delegate Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? UpdateUserVC
        vc?.selectedUser = arrayUser[(sender as? Int)!]
    }

}
