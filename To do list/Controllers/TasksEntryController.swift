//
//  TasksEntryController.swift
//  To do list
//
//  Created by Khaled L Said on 7/12/20.
//  Copyright © 2020 Intake4. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase

protocol refreshDataDelegate {
    func refreshData()
}

class TasksEntryController: UIViewController {

    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var dateAndTime: HoshiTextField!
    @IBOutlet weak var taskContent: HoshiTextField!
    
    var ref: DatabaseReference!
    
    let datePicker = UIDatePicker()
    
    var delegate: refreshDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        showDatePicker()
        background.layer.cornerRadius = 10
        background.layer.masksToBounds = true
    }
    
    private func saveTask() {
       guard let key = Auth.auth().currentUser?.uid else { return }
        
        let taskData = ["dateAndTime": self.dateAndTime.text,
                          "taskContent": self.taskContent.text]
        self.ref.child("users").child(key).child("tasks").childByAutoId().setValue(taskData)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        // prevent from choosing outdated time and date
        datePicker.minimumDate = Date()
        
       //ToolBar
       let toolbar = UIToolbar()
       toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        dateAndTime.inputAccessoryView = toolbar
        dateAndTime.inputView = datePicker
    }
    
    @objc func doneDatePicker() {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy/MM/dd hh:mm a"
      dateAndTime.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
       self.view.endEditing(true)
     }
    
    
    @IBAction func save(_ sender: UIButton) {
        saveTask()
        delegate?.refreshData()
        dismiss(animated: true, completion: nil)
        
    }
    
    

}
