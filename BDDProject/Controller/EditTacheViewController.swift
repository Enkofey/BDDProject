//
//  editTacheViewController.swift
//  BDDProject
//
//  Created by Julien DAVID on 03/03/2021.
//

import UIKit

class EditTacheViewController : UITableViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var categorieButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categorieTextLabel: UILabel!
    
    let imager = ImagePhoto()
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        label.text = Array(categorieTab!)[row].nom
            label.sizeToFit()
            return label
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int
        {
            return 1 //return 2
        }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
        {
            categorieTab!.count
        }
        
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
        {
            return 60
        }
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
    var categorieTab : [Categorie]?
    
    @IBAction func saveAction(_ sender: Any) {
        if let item = item{
                item.title = nomTextField.text
                item.descriptions = descriptionTextField.text
                item.majDate = Date()
            if let image = imageView.image {
                let images = ImagePhoto(context: context)
                images.donnee = image.pngData()
                item.imagePhoto = images
            }
            if (categorieTextLabel.text != "" && categorieTab != nil){
                for i in categorieTab!{
                    if(categorieTextLabel.text! == i.nom){
                        item.category = i
                    }
                }
            }
                delegate?.EditTacheViewControllerSave(self, item)
            }
    }
    @IBAction func chooseCategorie(_ sender: Any) {
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
                
                alert.popoverPresentationController?.sourceView = categorieButton
                alert.popoverPresentationController?.sourceRect = categorieButton.bounds
                
                alert.setValue(vc, forKey: "contentViewController")
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
                }))
                
                alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
                    self.selectedRow = pickerView.selectedRow(inComponent: 0)
                    let selected = Array(self.categorieTab!)[self.selectedRow]
                    let value = selected.nom
                    self.categorieTextLabel.text = value
                }))
                
                self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pickImageAction(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    present(imagePicker, animated: true, completion: nil)
                }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        delegate?.EditTacheViewControllerCancel(self)
    }
    
    var delegate : EditTacheViewDelegate?
    var item : Tache?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item{
            nomTextField.text = item.title
            descriptionTextField.text = item.descriptions
        }
    }
    
}
extension EditTacheViewController {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("\(info)")
        if let image = info[.originalImage] as? UIImage {
            imageView?.image = image
            dismiss(animated: true, completion: nil)
        }
    }
}


protocol EditTacheViewDelegate {
    func EditTacheViewControllerCancel(_ controller : EditTacheViewController)
    func EditTacheViewControllerSave(_ controller : EditTacheViewController, _ tache : Tache)
}
