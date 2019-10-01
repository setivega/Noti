//
//  ViewController.swift
//  Noti
//
//  Created by Seti Vega on 12/1/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    
    
    var notis: [Notification] = []
    var oneTime: [Notification] = []
    var repeating: [Notification] = []
    
    var dataFilter : Int = 0
    
    override func viewDidLoad() {
        
        tableView.register(UINib.init(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
//        LocalPushManager.shared.getPendingNotifs()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        let nibName = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "notificationCell")

    
        getNotis()
        filterNotis()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        notis.removeAll()
        getNotis()
        tableView.reloadData()
        printNotis()
    }
    
    //MARK: - Conform to TableView Delegate & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataFilter {
        case 0:
            return notis.count
        case 1:
            return repeating.count
        case 2:
            return oneTime.count
        default:
            return notis.count
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NotificationCell", owner: self, options: nil)?.first as! NotificationCell
        
        switch dataFilter {
        case 0:
            setupCells(notiArray: notis, notiCell: cell, notiPath: indexPath)
        case 1:
            setupCells(notiArray: repeating, notiCell: cell, notiPath: indexPath)
        case 2:
            setupCells(notiArray: oneTime, notiCell: cell, notiPath: indexPath)
        default:
            setupCells(notiArray: notis, notiCell: cell, notiPath: indexPath)
        }
        
        cell.editIcon.tag = indexPath.row
        cell.editIcon.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return cell
    }
    
   
    
    @objc func showActionSheet(sender: UIButton) {
        
        let cell = self.tableView.visibleCells[sender.tag] as! NotificationCell
        
        let cellNum = sender.tag
        let cellName = cell.notificationTitle.text
        
        print(cellNum)
        print(cellName!)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let edit = UIAlertAction(title: "Edit", style: .default) { (action) in
                let editVC = EditNotifVC()
                editVC.notiIndex = cellNum
            print("HomeVC: \(editVC.notiIndex)")
            self.performSegue(withIdentifier: "editNotif", sender: sender)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            if let title = cell.notificationTitle.text{
                self.deleteNoti(name: title)
            }else{
                print("Boinkenstein")
            }
        }
        
        actionSheet.addAction(edit)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "editNotif" {
//            let editVC = segue.destination as! EditNotifVC
//            let button = sender as! UIButton
//            editVC.index = button.tag
//            print(editVC.index)
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func setupCells(notiArray: [Notification], notiCell: NotificationCell, notiPath: IndexPath){
        notiCell.notificationTitle.text = notiArray[notiPath.row].title
        notiCell.notificationMessage.text = notiArray[notiPath.row].message
        notiCell.notificationTime.text = notiArray[notiPath.row].dateString
        notiCell.interval = notiArray[notiPath.row].interval
        notiCell.repeating = notiArray[notiPath.row].repeating
        notiCell.rawType = notiArray[notiPath.row].type
        notiCell.state = notiArray[notiPath.row].state
        notiCell.fireDate = notiArray[notiPath.row].fireDate
//        if let fireDate = notiArray[notiPath.row].fireDate{
//            notiCell.fireDate = fireDate
//        }
        
    }
    
    
    func filterNotis(){
        for noti in notis {
            if noti.repeating == true{
                repeating.append(noti)
            }else if noti.repeating == false{
                oneTime.append(noti)
            }
        }
    }
  
    
    //MARK: - IBActions
    @IBAction func filterSegmentValueChanged(_ sender: CustomSegementedControl) {
        oneTime.removeAll()
        repeating.removeAll()
        filterNotis()
        switch sender.selectedSegmentIndex {
        case 0:
            dataFilter = 0
        case 1:
            dataFilter = 1
        case 2:
            dataFilter = 2
        default:
            dataFilter = 0
        }
        reload()
    }
    
    func reload() {
        DispatchQueue.main.async {
                self.tableView.reloadData()
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "newNotif", sender: self)
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "settings", sender: self)
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

    
    func updateTableView(){
        notis.removeAll()
        getNotis()
        tableView.reloadData()
    }
    
    func printNotis(){
        notis.forEach({print($0.title)})
    }
    
    func getNotis() {

        notis = fetch(entity: "Notification")
        
    }
    
    
    func updateNotis(){
        
        
        let firstNoti = notis.first
        
        firstNoti?.title += "YO YOu UPdate Bro"
        
        do{
            try context.save()
            print("saved successfully")
        } catch let err{
            print("Error: \(err.localizedDescription)")
        }
        
        printNotis()
        
        
    }
    
    func deleteNoti(name: String){
        
        for noti in notis {
            if noti.title == name{
                context.delete(noti)
                print(name)
            }
            do{
                try context.save()
                LocalPushManager.shared.deleteLocalPush(title: name)
            }catch let err{
                print("Error: \(err.localizedDescription)")
            }
        }
        
        updateTableView()
    }
    
}






