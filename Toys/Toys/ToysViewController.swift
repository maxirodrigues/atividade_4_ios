//
//  ToysViewController.swift
//  Toys
//
//  Created by User on 05/01/2022.
//  Copyright © 2022 User. All rights reserved.
//

import UIKit
import Firebase

class ToysViewController: UIViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var segmentedControlState: UISegmentedControl!
    @IBOutlet weak var textFieldGiver: UITextField!
    @IBOutlet weak var textViewAddress: UITextView!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var buttonAddEdit: UIButton!
    
    var toysList: ToysItem?
    
    let userReference = Firestore.firestore().collection("toys")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if let toysList = toysList  {
           title = "Edição"
           buttonAddEdit.setTitle("Alterar", for: .normal) }
   
    }
    
//let estado = 1
    
   func create(){
        guard let name = textFieldName?.text, let state = segmentedControlState?.selectedSegmentIndex, let address = textViewAddress?.text, let giver = textFieldGiver?.text, let phone = textFieldPhone?.text else {return}
        
        let parameters = ["name": name,
                          "state": state,
                          "address": address,
                          "giver": giver,
                          "phone": phone] as [String : Any]
        userReference.addDocument(data: parameters)
    }
    
    
    func update(){
        
        
        guard let name = textFieldName?.text,let state = segmentedControlState?.selectedSegmentIndex, let address = textViewAddress?.text, let giver = textFieldGiver?.text, let phone = textFieldPhone?.text else {return}
        
        let parameters = ["name": name,
                          "state": state,
                          "address": address,
                          "giver": giver,
                          "phone": phone
            ] as [String : Any]
        let id = toysList?.id
        userReference.document(id!).setData(parameters)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareScreen()
    }
    
    func prepareScreen(){
        if let toysList = toysList {
            textFieldName.text = toysList.name
            segmentedControlState.selectedSegmentIndex = toysList.state
            textFieldGiver.text = toysList.giver
            textViewAddress.text = toysList.address
            textFieldPhone.text = toysList.phone
            
            
            
        }
    }

    
    @IBAction func save(_ sender: UIButton) {
        if let toysList = toysList{
            update()
            navigationController?.popViewController(animated: true)
        } else {
            create()
            navigationController?.popViewController(animated: true)
        }
    }

}
