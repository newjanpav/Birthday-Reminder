//
//  ViewController.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 4.01.23.
//

import UIKit

fileprivate struct ViewConfig {
    static let kCellHeight: CGFloat = 80
}

class RootViewController: UIViewController {
    @IBOutlet weak var BirthDayTableView: UITableView!
    var entities : [BirthdayEntity] = []
    var dateFormat: String?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BirthDayTableView.dataSource = self
        BirthDayTableView.delegate = self
        
        guard let savedEntities = UserDefaultsManager.shared.takeAwayArray(forKey: .birthdayEntity) else {return}
        entities = savedEntities
    }

    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        let vc = NewEntityViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func formatedDateDidTap(_ sender: UIButton) {
        let vc  = DateFormaterViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
}

extension RootViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id) as? BirthdayEntityCell
        if cell == nil {
           cell = Bundle.main.loadNibNamed("BirthdayEntityCell", owner: nil, options: nil)?[0] as? BirthdayEntityCell
        }
        var currentEntiti = entities[indexPath.row]
        cell?.nameLabel.text = currentEntiti.name
        
        if dateFormat == nil {
            cell?.birthdayDateLabel.text = currentEntiti.formatedData
        }else{
            currentEntiti.newFormatedDate = dateFormat
            cell?.birthdayDateLabel.text = currentEntiti.formatedData
        }
        if let data = currentEntiti.iconData,
            let image = UIImage(data: data) {
            cell?.iconImageView.image = image
            cell?.iconImageView.contentMode = .scaleAspectFill
            cell?.iconImageView.layer.cornerRadius = (cell?.iconImageView.frame.height)! / 2
            }
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ViewConfig.kCellHeight
    }
    
//delete cell from BirthDayTableView with an AlertController
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        let alertController = UIAlertController(title: "Delete this Birthday date ?", message: "Are you sure?", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive) { _ in
            alertController.dismiss(animated: true) {
                tableView.beginUpdates()
                self.entities.remove(at: indexPath.row)
                // save data to UserDefaults
                UserDefaultsManager.shared.saveArray(array: self.entities, forKey: .birthdayEntity)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
    }
    
//when we select on certain Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntity = entities[indexPath.row]
        let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EntityDetailViewController") as! EntityDetailViewController
        vc.currentEntity = selectedEntity
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController: NewEntityViewControllerDelegate {
    func newEntityViewController(_ controller: NewEntityViewController, didCreateEntity entity: BirthdayEntity) {
        //add new cell into entities without BirthDayTableView.reload()
        entities.append(entity)
        // save data to UserDefaults
        
        UserDefaultsManager.shared.saveArray(array: entities, forKey: .birthdayEntity)
        
        guard let index = entities.firstIndex(of: entity) else {return}
        let indexPath = IndexPath(row: index, section: 0)
        BirthDayTableView.insertRows(at: [indexPath], with: .fade)
    }
}

extension RootViewController : DateFormaterViewControllerDelegate {
    func changeDateFormat(_ controoller: DateFormaterViewController, changeForrmat format: String) {
        dateFormat = format
        BirthDayTableView.reloadData()
    }
}
 

