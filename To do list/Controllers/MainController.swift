//
//  MainController.swift
//  To do list
//
//  Created by Khaled L Said on 7/12/20.
//  Copyright © 2020 Intake4. All rights reserved.
//

import UIKit
import Firebase

class MainController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var ref: DatabaseReference!
    var arrOfTasks:[Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewConfig()
        ref = Database.database().reference()
        navControllerTitle()
        self.navigationController?.isNavigationBarHidden = false
        self.table.backgroundView = UIImageView(image: UIImage(named: "background 2"))
        getData()
        
        
        
    }
    
    func getData() {
        guard let key = Auth.auth().currentUser?.uid else { return }
        let itemsRef = self.ref.child("users").child(key).child("tasks")
        itemsRef.observeSingleEvent(of: .value, with: { snapshot in
            var todoArr: [Task] = []
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let postKey = snap.key
                let postTodo = dict["taskContent"] as! String
                let postDateAndTime = dict["dateAndTime"] as! String
                let post = Task(taskid: postKey, dateAndTime: postDateAndTime, taskContent: postTodo)
                todoArr.append(post)
            }
            self.arrOfTasks = todoArr
            self.table.reloadData()
        })
    }
    
    
    
    private func navControllerTitle() {
       guard let key = Auth.auth().currentUser?.uid else { return }
       self.ref.child("users").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
       let value = snapshot.value as? NSDictionary
           let userName = value?["userName"] as? String
           self.navigationItem.title = userName
       }) { (error) in
           print(error.localizedDescription)
       }
    }
    
    @IBAction func addTaskBtnPressed(_ sender: UIBarButtonItem) {
        let taskVC = UIStoryboard(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.tasksEntryVC) as! TasksEntryController
        taskVC.delegate = self
        taskVC.modalPresentationStyle = .overCurrentContext
        taskVC.modalTransitionStyle = .crossDissolve
        self.present(taskVC, animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
   
    private func tableViewConfig() {
        table.register(UINib(nibName: Cells.taskCell, bundle: nil), forCellReuseIdentifier: Cells.taskCell)
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrOfTasks.count
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cells.taskCell, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.configureCell(task: arrOfTasks[indexPath.row])
        cell.backgroundColor = .clear
        cell.isOpaque = false
        cell.delegate = self
        
        return cell
        }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}
extension MainController: refreshDataDelegate {
    func refreshData() {
        getData()
    }
    
}

extension MainController: UserCellDelegate {
    func didPressButton(customTableViewCell: UITableViewCell, didTapButton button: UIButton) {
        
        let alert = UIAlertController(title: "Sorry", message: "Are you sure you want to delete this TODO?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: { (uiAlert) in
                  guard let indexPath = self.table.indexPath(for: customTableViewCell) else {return}
             guard let key = Auth.auth().currentUser?.uid else { return }
            guard let todoKey = self.arrOfTasks[indexPath.row].taskid else { return }
            self.ref.child("users").child(key).child("tasks").child(todoKey).removeValue()
            self.getData()
            }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    
}



