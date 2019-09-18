//
//  EditNotifVC.swift
//  Noti
//
//  Created by Seti Vega on 12/2/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit

class EditNotifVC: UIViewController{
    
//    let homeVC = HomeVC()
//    var index = Int()
    
    var notiTitle = String()
    var notiMessage = String()
    
    //MARK: - IBOutlets
    @IBOutlet weak var notiTitleTextField: UITextField!
    @IBOutlet weak var notiMessageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(notiTitle)
        
        notiTitleTextField.text = notiTitle
        notiMessageTextView.text = notiMessage
        
    }
    
    //MARK: - IBActions
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
