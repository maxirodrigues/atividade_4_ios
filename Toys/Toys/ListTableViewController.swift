//
//  ListTableViewController.swift
//  Toys
//
//  Created by User on 06/01/2022.
//  Copyright © 2022 User. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {
    
    let collection = "toys"
    var toysList: [ToysItem] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToysList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let toysViewController = segue.destination as? ToysViewController,
            let row = tableView.indexPathForSelectedRow?.row{
            toysViewController.toysList = toysList[row]
        }
        
    }
    
    func loadToysList(){
        listener = firestore.collection(collection).order(by:"name", descending: false).addSnapshotListener(includeMetadataChanges: true, listener:{snapshot, error in
            
            if let error = error{
                print(error)
            }else{
                guard let snapshot = snapshot else {return}
                print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showItemsFrom(snapshot)
                }
            }
            
        })
    }

    func showItemsFrom(_ snapshot: QuerySnapshot){
        toysList.removeAll()
        for document in snapshot.documents{
           let data = document.data()
            if let name = data["name"] as? String, let state = data["state"] as? Int, let address = data["address"] as? String, let giver = data["giver"] as? String, let phone = data["phone"] as? String {
                let toysItem = ToysItem(name: name, state: state, address: address, giver: giver, phone: phone,id: document.documentID)
                toysList.append(toysItem)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toysList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let toysItem = toysList[indexPath.row]
        cell.textLabel?.text = toysItem.name
        //cell.detailTextLabel?.text = toysItem.state
        
        let stateToys = toysItem.state
        
        switch stateToys {
            
        case 0:
            cell.detailTextLabel?.text = "Novo"
            
        case 1:
            cell.detailTextLabel?.text = "Usado"
            
        default:
            cell.detailTextLabel?.text = "Precisa de reparo"
        }
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let toysItem = toysList[indexPath.row]
            firestore.collection(collection).document(toysItem.id).delete()
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
