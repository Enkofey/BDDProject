//
//  DetailTacheViewController.swift
//  BDDProject
//
//  Created by Julien DAVID on 03/03/2021.
//

import UIKit

class DetailTacheViewController : UIViewController {
    
    var delegate : DetailTacheViewDelegate?
    var item : Tache?
    
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var detailNomTache: UILabel!
    
    @IBOutlet weak var detailDescriptionTache: UILabel!
    
    @IBOutlet weak var detailDateCreaTache: UILabel!
    
    @IBOutlet weak var detailDateModTache: UILabel!
    
    @IBOutlet weak var detailCategorieTache: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let item = item{
            if let photo = item.imagePhoto {
                if let data = photo.donnee{
                    let image = UIImage(data: data)
                    detailImage.image = image
                }
            }
            detailNomTache.text = item.title
            detailDescriptionTache.text = item.descriptions
            detailDateCreaTache.text = "\(item.creationDate!)"
            detailDateModTache.text = "\(item.majDate!)"
            if(item.category != nil){
                if(item.category!.nom != nil){
                    detailCategorieTache.text = item.category!.nom
                }
                else{
                    detailCategorieTache.text = ""
                }
            }
            else{
                detailCategorieTache.text = ""
            }
        }
    }
    
    
}
protocol DetailTacheViewDelegate : class {
}
