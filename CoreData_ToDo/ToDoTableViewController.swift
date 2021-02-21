//
//  ToDoTableViewController.swift
//  CoreData_ToDo
//
//  Created by Yumi Machino on 2021/02/21.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    
    var cellId = "toDoItemCell"
    
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
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(title: text, priorityLevel: 1, isCompletedIndicator: false)
        }))
        present(alert, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedToDoItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let toDoItem = fetchedToDoItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = toDoItem.title
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = fetchedToDoItems[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit item",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
//        sheet.addTextField(configurationHandler: nil)
        
        /// cancel
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        /// edit
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "Edit",
                                          message: "Edit item",
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.title

            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in

                guard let field = alert.textFields?.first, let newTitle = field.text, !newTitle.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newTitle: newTitle, newPriorityLevel: 1, updatedIsCompletedIndicator: false)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }))
        
        /// delete
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
