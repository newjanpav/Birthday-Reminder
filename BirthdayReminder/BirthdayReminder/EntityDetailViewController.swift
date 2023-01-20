//
//  EntityDetailViewController.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 5.01.23.
//

import UIKit

class EntityDetailViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    
    var currentEntity : BirthdayEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentEntity = currentEntity else{return}
        
        nameLabel.text = currentEntity.name
        dateOfBirthLabel.text = currentEntity.formatedData
        
        guard let data = currentEntity.iconData else{return}
        let image = UIImage(data: data)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = (imageView.frame.height) / 2
    }
}
