//
//  ToDoTableViewController.swift
//   CoreData
//
//  Created by Rafael M. Trasmontero on 1/5/18.
//  Copyright © 2018 GTTuts. All rights reserved.
//

import UIKit
import CoreData
class ToDoTableViewController: UITableViewController {

    //MARK: Core Data Properties
    var resultsController: NSFetchedResultsController<ToDo>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContext()

    }

    
    //MARK: - Fetch From Core Data
    func fetchContext(){
        //Request
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let dateSortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        request.sortDescriptors = [dateSortDescriptors]
        //Init
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: CoreDataService.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        resultsController.delegate = self
        
        //Fetch
        do {
            try resultsController.performFetch()
        } catch let err {
            print("ERROR FETCHING DATA:",err.localizedDescription)
        }
    }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        // Configure the cell...
        let toDo = resultsController.object(at: indexPath)
        cell.textLabel?.text = toDo.title
        cell.detailTextLabel?.text = textualPriority(priority: toDo.priority)
        return cell
    }
    
    // MARK: Swipe Left Actions DELETE
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action,view, completion) in
            
            //TODO: Delete To-Do Task
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch let err {
                print("ERROR SAVING CONTEXT AFTER DELETE:",err.localizedDescription)
                completion(false)
            }
            
            
        }
        action.image = #imageLiteral(resourceName: "trash")
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    // MARK: Swipe Right Actions CHECK
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Check") { (action,        view, completion) in
            //TODO: Delete To-Do Task
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            do{
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch let err {
                print("ERROR SAVING CONTEXT AFTER CHECK:",err.localizedDescription)
                completion(false)
            }
        }
        action.image = #imageLiteral(resourceName: "check")
        action.backgroundColor = .green 
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Click +
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        //Click cell
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddToDoViewController {
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
    
    // MARK: - Delegate method to edit cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowWhatToDoVC", sender: tableView.cellForRow(at: indexPath))
    }

    //MARK: - Hanlde Priority(!!!) for Detail Subtitle
    func textualPriority(priority:Int16) -> String{
        switch priority {
        case 0:
            return "!"
        case 1:
            return "!!"
        case 2:
            return "!!!"
        default:
            return ""
        }
    }


}




// MARK: - Delegate method For Tableview

extension ToDoTableViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = newIndexPath{
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath){
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
                cell.detailTextLabel?.text = textualPriority(priority: todo.priority)
            }
        default:
            break
        }
    }

}
