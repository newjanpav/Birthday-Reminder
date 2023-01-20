//
//  DateFormaterViewController.swift
//  BirthdayReminder
//
//  Created by Pavel Shymanski on 20.01.23.
//

import UIKit


protocol  DateFormaterViewControllerDelegate: AnyObject {
    func changeDateFormat(_ controoller: DateFormaterViewController, changeForrmat format: String)
}

class DateFormaterViewController: UIViewController  {
    
    @IBOutlet weak var imagePicker: UIPickerView!
    var delegate: DateFormaterViewControllerDelegate?
    var dateFormats = ["EEEE, MMM d, yyyy",
                       "MM/dd/yyyy",
                       "MMMM yyyy",
                       "MMM d, yyyy",
                       "dd.MM.yy",
                       "MM-dd-yyyy HH:mm"]
    
    var selectedDateFormat = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.dataSource = self
    }
}

extension DateFormaterViewController :  UIPickerViewDelegate,UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateFormats.count - 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dateFormats[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDateFormat = dateFormats[row]
        delegate?.changeDateFormat(self, changeForrmat: selectedDateFormat )
        dismiss(animated: true, completion: nil)
    }
}

