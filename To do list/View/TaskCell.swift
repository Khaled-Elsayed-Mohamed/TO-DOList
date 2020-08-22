//
//  TaskCell.swift
//  To do list
//
//  Created by Khaled L Said on 7/12/20.
//  Copyright © 2020 Intake4. All rights reserved.
//

import UIKit
import TextFieldEffects

protocol UserCellDelegate {

    func didPressButton(customTableViewCell: UITableViewCell, didTapButton button: UIButton)
}

class TaskCell: UITableViewCell {


    
//!!
    @IBOutlet weak var dataAndTime: UILabel!
    @IBOutlet weak var taskContent: UILabel!
    
    var delegate: UserCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(task: Task) {
        dataAndTime.text = task.dateAndTime
        taskContent.text = task.taskContent
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        
        delegate?.didPressButton(customTableViewCell: self, didTapButton: sender)
    }

    
}
