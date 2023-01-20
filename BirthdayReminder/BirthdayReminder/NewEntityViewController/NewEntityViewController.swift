//
//  newEntityViewController.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 5.01.23.
//

import UIKit

protocol NewEntityViewControllerDelegate: AnyObject {
    func  newEntityViewController (_ controller: NewEntityViewController, didCreateEntity entity: BirthdayEntity )
}


class NewEntityViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    // add datePicker
    let datePicker = UIDatePicker()
    var selectedDate: Date?
    var imagePicker = UIImagePickerController()
    weak var delegate: NewEntityViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        dateOfBirthField.delegate = self
        dateOfBirthField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        datePicker.addTarget(self, action: #selector(onDatePickerValueChanged(sender:)), for: .valueChanged)
       

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(onTaponMainView))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }

    @objc func onTaponMainView(){
        nameTextField.resignFirstResponder()
        dateOfBirthField.resignFirstResponder()
    }
    
    //description Action for dataPicker
    @objc func onDatePickerValueChanged(sender: UIDatePicker){
        let date = sender.date
        selectedDate = date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM d , yyyy"
        let dateString =  dateFormater.string(from: date)
        dateOfBirthField.text = dateString
    }
    
    @IBAction func didPressClouseButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressConfirmButton(_ sender: UIButton) {
        guard  let name = nameTextField.text,
               let selectedDate = selectedDate,
               let data = imageView.image?.pngData(),
                name.count > 3 else {return}
        
        let entity  = BirthdayEntity(name: name, dateString: selectedDate, iconData: data)
        
       dismiss(animated: true, completion: {
           self.delegate?.newEntityViewController(self, didCreateEntity: entity)
       })
        
    }
    
    
    @IBAction func pickAnImageDidTap(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
}

extension NewEntityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            dateOfBirthField.becomeFirstResponder()

        }else{
            textField.resignFirstResponder()
        }
        return true
    }
}

extension NewEntityViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imageView.image = image
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
