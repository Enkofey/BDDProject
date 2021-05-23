//
//  ViewController.swift
//  BDDProject
//
//  Created by Julien DAVID on 24/02/2021.
//

import UIKit
import CoreData

class ViewController: UITableViewController, DetailTacheViewDelegate, EditTacheViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
            label.text = Array(keySorting)[row].key
            label.sizeToFit()
            return label
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1 //return 2
        }
    
    var keySorting : KeyValuePairs =
            [
                "Nom" : 1,
                "Catégorie" : 2,
                "Date" : 3,
            ]
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            keySorting.count
        }
        
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 60
        }
    
    
    @IBOutlet weak var sortByButton: UIBarButtonItem!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
    @IBAction func sortByButtonPush(_ sender: Any) {
        
        let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height:screenHeight))
                pickerView.dataSource = self
                pickerView.delegate = self
                
                pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
                
                vc.view.addSubview(pickerView)
                pickerView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
                pickerView.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
                
                let alert = UIAlertController(title: "Select Background Colour", message: "", preferredStyle: .actionSheet)
                
                alert.popoverPresentationController?.sourceView = sortByButton.customView
                alert.popoverPresentationController?.sourceRect = sortByButton.customView!.bounds
                
                alert.setValue(vc, forKey: "contentViewController")
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                }))
                
                alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                    self.selectedRow = pickerView.selectedRow(inComponent: 0)
                    let selected = Array(self.keySorting)[self.selectedRow]
                    let value = selected.value
                    
                    if(value == 1){
                        self.sortTachesListByTitle()
                    }
                    if(value == 2){
                        self.sortTachesListByCategorie()
                    }
                    if(value == 3){
                        self.sortTachesListByDate()
                    }
                    
                    self.updateUI()
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func EditTacheViewControllerSave(_ controller: EditTacheViewController, _ tache: Tache) {
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    func EditTacheViewControllerCancel(_ controller: EditTacheViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var taches : [Tache] = []
    private var categories : [Categorie] = []

    func sortTachesListByTitle(){
        if(taches.count > 1){
            var isSort : Bool = false
            while(isSort == false){
                isSort = true
                for i in 0...taches.count-2{
                    var compare = taches[i].title!.localizedStandardCompare(taches[i+1].title!)
                    if(compare == ComparisonResult.orderedDescending){
                        var temp = taches[i]
                        taches[i] = taches[i+1]
                        taches[i+1] = temp
                        isSort = false
                    }
                }
            }
        }
    }
    
    func sortTachesListByCategorie(){
        if(taches.count > 1){
            var isSort : Bool = false
            while(isSort == false){
                isSort = true
                for i in 0...taches.count-2{
                    var compare = taches[i].category!.nom!.localizedStandardCompare(taches[i+1].category!.nom!)
                    if(compare == ComparisonResult.orderedDescending){
                        var temp = taches[i]
                        taches[i] = taches[i+1]
                        taches[i+1] = temp
                        isSort = false
                    }
                }
            }
        }
    }
    
    func sortTachesListByDate(){
        if(taches.count > 1){
            var isSort : Bool = false
            while(isSort == false){
                isSort = true
                for i in 0...taches.count-2{
                    if(taches[i].majDate! < taches[i+1].majDate!){
                        var temp = taches[i]
                        taches[i] = taches[i+1]
                        taches[i+1] = temp
                        isSort = false
                    }
                }
            }
        }
    }
    
    
    private var managedContext : NSManagedObjectContext{
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        taches = fetchTache()
        
        /*
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
 */
        
        //navigationItem.searchController = searchController
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
    
    private func fetchCategorie(searchQuery : String? = nil) -> [Categorie]{
        let fetchRequest: NSFetchRequest<Categorie> = Categorie.fetchRequest()
        let sortDesricptor = NSSortDescriptor(keyPath : \Categorie.nom,ascending : false)
        fetchRequest.sortDescriptors = [sortDesricptor]
        
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            let predicate = NSPredicate(format: "%K contains[cd] %@", argumentArray: [#keyPath(Categorie.nom),searchQuery])
        }
        
        do{
            return try self.managedContext.fetch(fetchRequest)
        } catch{
            fatalError(error.localizedDescription)
        }
    }
    
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Ajouter", message: "Que voulez vous ajouter ?", preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title : "Annuler",style: .cancel,handler: nil)
        let moreButton = UIAlertAction(title: "Catégorie", style: .default) { _ in
            
            let subAlertController = UIAlertController(title: "Nouvelle Catégorie", message: "Ajouter une catégorie", preferredStyle: .alert)
            
            subAlertController.addTextField { (TitletextField) in
                TitletextField.placeholder = "Nom catégorie..."
            }
            
            guard let textField = subAlertController.textFields?.first else{
                return
            }
            
            let saveButton2 = UIAlertAction(title: "Créer", style: .default){_ in
                self.createCategorie(nomTache: textField.text!)
                self.categories = self.fetchCategorie()
                self.tableView.reloadData()
            }
            let cancelButton2 = UIAlertAction(title : "Annuler",style: .cancel,handler: nil)
            subAlertController.addAction(saveButton2)
            subAlertController.addAction(cancelButton2)
            self.present(subAlertController, animated: true, completion: nil)
            
        }
        let saveButton = UIAlertAction(title: "Taches", style: .default){_ in
            
            let subAlertController = UIAlertController(title: "Nouvelle Tâche", message: "Ajouter une tâche à la liste", preferredStyle: .alert)
            
            subAlertController.addTextField { (TitletextField) in
                TitletextField.placeholder = "Titre..."
                
            }
            
            subAlertController.addTextField { (DescriptiontextField) in
                DescriptiontextField.placeholder = "Description..."
            }
            
            guard let textField = subAlertController.textFields?.first else{
                return
            }
            guard let textField2 = subAlertController.textFields?[1] else{
                return
            }
            
            let saveButton2 = UIAlertAction(title: "Créer", style: .default){_ in
                self.createTache(title: textField.text!, description: textField2.text!)
                self.taches = self.fetchTache()
                self.tableView.reloadData()
            }
            let cancelButton2 = UIAlertAction(title : "Annuler",style: .cancel,handler: nil)
            subAlertController.addAction(saveButton2)
            subAlertController.addAction(cancelButton2)
            self.present(subAlertController, animated: true, completion: nil)
        }
        
        alertController.addAction(moreButton)
        alertController.addAction(saveButton)
        alertController.addAction(cancelButton)
    
        present(alertController, animated: true, completion: nil)
    }
    
    private func createCategorie(nomTache: String){
        let categorie = Categorie(context: managedContext)
        categorie.nom = nomTache
        
    }
    
    private func createTache (title: String, description : String, dateCrea : Date = Date(), dateMod : Date = Date()){
            let tache = Tache(context: managedContext)
            tache.title = title
            tache.descriptions = description
            tache.creationDate = dateCrea
            tache.majDate = dateMod
            let tempCategorie = Categorie(context: managedContext)
            tempCategorie.nom = ""
            tache.category = tempCategorie
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
            cell.textLabel?.text = "\(tache.title!) - \(DateFormatter.localizedString(from: tache.creationDate! , dateStyle: .short, timeStyle: .short))"
            cell.detailTextLabel?.text = tache.descriptions
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
            saveContext()
            
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
        }
    
    func updateUI() {
        for i in 0...taches.count-1{
            tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            switch segueIdentifier(for: segue) {
                case .editTache:
                    let nav = segue.destination as! UINavigationController
                    let dest = nav.topViewController as! EditTacheViewController
                    dest.categorieTab = categories
                    dest.item = taches[tableView.indexPath(for: sender as! UITableViewCell)!.item]
                    dest.delegate = self;
                    break
                case .detailTache:
                    let dest = segue.destination as! DetailTacheViewController
                    let cellSelected = tableView.indexPath(for: sender as! UITableViewCell)!
                    dest.item = taches[cellSelected.item]
                    dest.delegate = self;
                    break
            }
        }
    
}
extension ViewController : SegueHandlerType{
    
    enum SegueIdentifier : String {
        case editTache
        case detailTache
    }
}
