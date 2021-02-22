//
//  AddEditTableViewController.swift
//  CoreData_ToDo
//
//  Created by Yumi Machino on 2021/02/21.
//

import UIKit

protocol AddEditDelegate: class {
    func add(_ title: String, _ priority: Int16)
}


class AddEditTableViewController: UITableViewController {

    let sections:[String] = ["ToDo item", "Priority"]
    
    var titleCell = AddEditTableViewCell()
    var segmentControlCell = SegmentCtrlTableViewCell()
   
    let saveButton =  UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveToDoItem))
    
    var item: ManagedToDoItem?
    var delegate: AddEditDelegate?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Add new Item"
        // navigation buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissTVC))
        navigationItem.rightBarButtonItem = saveButton
        
        updateSaveBtnState()
        // Observe text field
        titleCell.textField.addTarget(self, action: #selector(textEditingChanged(_:)), for: .editingChanged)
    }

    @objc
      func saveToDoItem(){
          // create an item, add to model
        let newTitle = titleCell.textField.text!
        let newPriority = Int16(segmentControlCell.segmentControl.selectedSegmentIndex + 1)
        print(newTitle, newPriority)
        delegate?.add(newTitle, newPriority)
        dismiss(animated: true, completion: nil)
    }
    
    @objc
        func dismissTVC(){
            dismiss(animated: true, completion: nil)
        }
    
    func updateSaveBtnState(){
           saveButton.isEnabled = checkText(titleCell.textField)
           
       }

       private func checkText(_ textField: UITextField) -> Bool {
           guard let text = titleCell.textField.text, text.count >= 1 else {return false}
           return true
       }
       
       @objc
       func textEditingChanged(_ sender: UITextField) {
           updateSaveBtnState()
       }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           switch indexPath {
           case [0, 0]:
               return titleCell
           case [1, 0]:
               return segmentControlCell
           default:
               fatalError("Error")
           }
       }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return sections[section]
        case 1:
            return sections[section]
        default:
            fatalError()
        }
    }
}

/// Custom TableViewCell
class AddEditTableViewCell: UITableViewCell {
    
    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: .default, reuseIdentifier: reuseIdentifier)
           contentView.addSubview(textField)
           textField.matchParent(padding: .init(top: 10, left: 8, bottom: 10, right: 8))
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}


class SegmentCtrlTableViewCell: UITableViewCell {

    let items = ["High", "Medium", "Low"]
    
    lazy var segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: items)
            control.selectedSegmentIndex = 1
            return control
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: .default, reuseIdentifier: reuseIdentifier)
          contentView.addSubview(segmentControl)
         segmentControl.matchParent(padding: .init(top: 30, left: 8, bottom: 30, right: 8))
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}
