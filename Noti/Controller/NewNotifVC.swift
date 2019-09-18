//
//  NewNotifVC.swift
//  Noti
//
//  Created by Seti Vega on 12/1/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit
import UserNotifications

class NewNotifVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    // MARK: - IB Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self
        titleTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupTextField(textField: titleTextField)
        setupTextView(textView: messageTextView)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IB Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createNotif", sender: self)
    }
    
    
    // MARK: - My Functions
    
    func setupTextField(textField: UITextField){
        let gray = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.layer.borderWidth = 1
        textField.text = "Notification Title"
        textField.textColor = UIColor.lightGray
        textField.layer.cornerRadius = 6
        textField.layer.borderColor = gray.cgColor
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.autocorrectionType = .no
        textFieldDidBeginEditing(textField)
        textFieldDidEndEditing(textField)
    }
    
    
    func setupTextView(textView: UITextView){
        let gray = UIColor(red: 208.0/255.0, green: 208.0/255.0, blue: 208.0/255.0, alpha: 1.0)
        textView.layer.borderWidth = 1
        textView.text = "Your Notification Message goes here"
        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 6
        textView.layer.borderColor = gray.cgColor
        textView.autocorrectionType = .no
        textViewDidBeginEditing(textView)
        textViewDidEndEditing(textView)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textFieldString = titleTextField.text, let swtRange = Range(range, in: textFieldString) {
            
            let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
            
            titleLabel.text = fullString
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textFieldString = messageTextView.text, let swtRange = Range(range, in: textFieldString) {
            
            let fullString = textFieldString.replacingCharacters(in: swtRange, with: text)
            
            messageLabel.text = fullString
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = "Notification Title"
            titleLabel.text = textField.text
            textField.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Your Notification Message goes here"
            messageLabel.text = textView.text
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createNotif" {
            let destinationVC = segue.destination as! CreateNotifVC

            let title = titleTextField.text
            let message = messageTextView.text
            
            destinationVC.notifTitle = title
            destinationVC.notifMessage = message
            
        }
        
    }

}


