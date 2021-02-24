//
//  ViewController.swift
//  BDDProject
//
//  Created by Julien DAVID on 24/02/2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    private var taches : [Tache] = []

    private var managedContext : NSManagedObjectContext{
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taches = fetchTache()
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = editButtonItem
    }
    private func fetchTache(searchQuery : String? = nil) -> [Tache]{
        let fetchRequest: NSFetchRequest<Tache> = Tache.fetchRequest()
        let sortDesricptor = NSSortDescriptor(keyPath : \Tache.creationDate,ascending : false)
        fetchRequest.sortDescriptors = [sortDesricptor]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Tache.title),searchQuery])
        }
        
        do{
            return try self.managedContext.fetch(fetchRequest)
        } catch{
            fatalError(error.localizedDescription)
        }
    }
        private func createTache (title: String, date : Date = Date()){
            let tache = Tache(context: managedContext)
            
            tache.title = title
            tache.creationDate = date
        }
        
        private func saveContext(){
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return taches.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let tache = taches[indexPath.row]
            cell.accessoryType = tache.isChecked ? .checkmark : .none
            cell.textLabel?.text = tache.title
            cell.detailTextLabel?.text = DateFormatter.localizedString(from: tache.creationDate!, dateStyle: .medium, timeStyle: .short)
            return cell
        }
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            guard editingStyle == .delete else {
                return
            }
            
            let index = indexPath.row
            let tache = taches[index]
            
            managedContext.delete(tache)
            saveContext()
            
            taches.remove(at: index)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            taches[indexPath.row].isChecked.toggle()
            saveContext()
            
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            cell.accessoryType = taches[indexPath.row].isChecked ? .checkmark : .none
        }
}
extension ViewController : UISearchResultsUpdating{
        func updateSearchResults(for searchController: UISearchController) {
            let searchQuery = searchController.searchBar.text
            taches = fetchTache(searchQuery: searchQuery)
            tableView.reloadData()
        }
    }
