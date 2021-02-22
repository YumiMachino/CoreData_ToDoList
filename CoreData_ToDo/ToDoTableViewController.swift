//
//  ToDoTableViewController.swift
//  CoreData_ToDo
//
//  Created by Yumi Machino on 2021/02/21.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var cellId = "toDoItemCell"
    var sections: [String] = ["High Priority", "Medium Priority", "Low Priority"]
    
    ///perform objects in coreData database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchedToDoItems = [ManagedToDoItem]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDo Items"
        getAllItems()
        
        // register custom TableViewCell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    
    @objc
    func addTapped(){
        let alert = UIAlertController(title: "New Item",
                                      message: "Enter new item",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit",
                                      style: .cancel,
                                      handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(title: text, priorityLevel: 1, isCompletedIndicator: false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            let highPriorityItems = fetchedToDoItems.filter{$0.priorityLevel == 1}
            return highPriorityItems.count
        case 1:
            let mediumPriorityItems = fetchedToDoItems.filter{$0.priorityLevel == 2}
            return mediumPriorityItems.count
        case 2:
            let lowPriorityItems = fetchedToDoItems.filter{$0.priorityLevel == 3}
            return lowPriorityItems.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let toDoItem = fetchedToDoItems[indexPath.row]
        switch indexPath.section {
        case 0:
            if toDoItem.priorityLevel == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                cell.textLabel?.text = toDoItem.title
                return cell
            }
        case 1:
            if toDoItem.priorityLevel == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                cell.textLabel?.text = toDoItem.title
                return cell
            }
        case 2:
            if toDoItem.priorityLevel == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
                cell.textLabel?.text = toDoItem.title
                return cell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = fetchedToDoItems[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit item",
                                      message: nil,
                                      preferredStyle: .actionSheet)
    
        /// cancel
        sheet.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        /// edit
        sheet.addAction(UIAlertAction(title: "Edit",
                                      style: .default,
                                      handler: { _ in
            
            let alert = UIAlertController(title: "Edit",
                                          message: "Edit item",
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title

            alert.addAction(UIAlertAction(title: "Save",
                                          style: .cancel,
                                          handler: { [weak self] _ in

                guard let field = alert.textFields?.first, let newTitle = field.text, !newTitle.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newTitle: newTitle, newPriorityLevel: 1, updatedIsCompletedIndicator: false)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }))
        
        /// delete
        sheet.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true, completion: nil)
    }
}

extension ToDoTableViewController {

    /// get all the ToDoItem from the database
    func getAllItems(){
        do {
            fetchedToDoItems = try context.fetch(ManagedToDoItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        } catch {
            print(error)
        }
    }

    /// create an Item in the CoreData database
    func createItem(title: String, priorityLevel: Int16, isCompletedIndicator: Bool) {
        let newItem = ManagedToDoItem(context: context)
        newItem.title = title
        guard priorityLevel == 1 || priorityLevel == 2 || priorityLevel == 3  else {return}
        newItem.priorityLevel = priorityLevel
        newItem.isCompletedIndicator = isCompletedIndicator
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error)
        }
    }

    /// delete an Item in the CoreData database
    func deleteItem(item: ManagedToDoItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            print(error)
        }
    }


    func updateItem(item: ManagedToDoItem, newTitle: String, newPriorityLevel: Int16, updatedIsCompletedIndicator: Bool ) {
        item.title = newTitle
        item.priorityLevel = newPriorityLevel
        item.isCompletedIndicator = updatedIsCompletedIndicator

        do {
            try context.save()
            getAllItems()
        } catch {
            print(error)
        }
    }

}

extension ToDoTableViewController {
    func generateDummyData() {
        
        createItem(title: "Take a walk", priorityLevel: 1, isCompletedIndicator: false)
        createItem(title: "Study Design pattern", priorityLevel: 1, isCompletedIndicator: false)
        createItem(title: "Study iOS", priorityLevel: 1, isCompletedIndicator: false)
  
    }
    
    func resetData() {
        for count in 0...fetchedToDoItems.count - 1 {
            if count == 0 {
                deleteItem(item: fetchedToDoItems[0])
                break
            }
            deleteItem(item: fetchedToDoItems[count])
        }
    }
}
