//
//  EditNotifVC.swift
//  Noti
//
//  Created by Seti Vega on 12/2/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class EditNotifVC: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
//    let homeVC = HomeVC()
//    var index = Int()
    
    var notis: [Notification] = []
    var noti = Notification()
    var notiIndex = Int()
    var notiMessage = String()
    var notiTitle = String()
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        messageTextView.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupTextField(textField: titleTextField)
        setupTextView(textView: messageTextView)
        
        getNoti()
//        print("EditVC: \(notiIndex)")
        titleTextField.text = noti.title
        messageTextView.text = noti.message
        
        
    }
    
    //MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - CRUD Core Data
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetch(entity: String) -> [Notification] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest) as? [Notification]
            return fetchedObjects ?? [Notification]()
            
        } catch let err{
            print("Error: \(err.localizedDescription)")
            return [Notification]()
        }
        
        
    }
    
    func getNotis() {
        
        notis = fetch(entity: "Notification")
        
    }
    

    func getNoti(){
        getNotis()
        noti = notis[notiIndex]
    }
    
    //MARK:- My Functions
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            textField.text = "Notification Title"
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
            textView.textColor = UIColor.lightGray
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
