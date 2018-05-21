//
//  messageVC.swift
//  ChatBot
//
//  Created by Shivam Dev on 19/05/18.
//  Copyright © 2018 Shivam Dev. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class messageVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textFieldMessage: UITextField!
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBOutlet weak var messageBoxView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    
    var messages: [Lmessages] = []
    
    var positionNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.tableView.separatorStyle = .none

        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        textFieldMessage.delegate = self
        sendMessageBtn.layer.borderWidth = 1.0
        sendMessageBtn.layer.borderColor = #colorLiteral(red: 0.3858584166, green: 0.5081222653, blue: 0.973092854, alpha: 1)
        
        messageBoxView.layer.borderWidth = 1.0
        messageBoxView.layer.borderColor = #colorLiteral(red: 0.3858584166, green: 0.5081222653, blue: 0.973092854, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector (tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    
    @objc func tableViewTapped() {
        textFieldMessage.endEditing(true)
    }
    
    
    @IBAction func dismissBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func sendMessageBtnWasPressed(_ sender: Any) {
        if textFieldMessage.text != "" {
            save(message: textFieldMessage.text!, position: positionNumber, side: .right)
            self.positionNumber += 1
            isTyping(indexPathValue: messages.count + 1)
            fetch()
            print("FIRST: \(messages.count)")
//            if self.messages.count >= 5 {
//                self.reloadData()
//            } else {
//                self.tableView.reloadData()
//            }
            self.tableView.reloadData()
            self.tableView.scrollToBottom()
            self.getJsonvalue(message: self.textFieldMessage.text!)
        }
        
        
        textFieldMessage.text = ""
    }
    
    func isTyping(indexPathValue: Int) {
        save(message: "isTyping", position: indexPathValue, side: .left)
        fetch()
    }
    
    
    @IBAction func deleteCoreData(_ sender: Any) {
        deleteAllRecords()
        fetch()
        tableView.reloadData()
    }
    
    
    func deleteAllRecords(name: String = "", indexVlaue: Int = 0) {
        let context = appDelegate?.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Lmessages")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        if name == "isTyping" {
            context?.delete(messages[indexVlaue-1] as NSManagedObject)
            print("SECOND: \(messages.count)")
        } else {
            do {
                try context?.execute(deleteRequest)
                try context?.save()
            } catch {
                print ("There was an error")
            }
        }
        
    }
    
    
    func save(message: String, position: Int, side: Side) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let localMessages = Lmessages(context: managedContext)
        
        localMessages.message = message
        localMessages.position = Int32(position)
        localMessages.side = side.rawValue
        
        do {
            try managedContext.save()
        } catch let error{
            debugPrint("Error: \(error.localizedDescription)")
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    func reloadData(){
        self.tableView.reloadData()
        DispatchQueue.main.async {
//                self.tableView.contentSize.height - UIScreen.main.bounds.height
            let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height + 40)
            self.tableView.setContentOffset(scrollPoint, animated: true)
        }
        
    }
    
    
    
    func getJsonvalue(message: String) {


        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)

        let unsafeChars = CharacterSet.alphanumerics.inverted
        let newTrimmedMessage: String = trimmed.components(separatedBy: unsafeChars).joined(separator: "+")
        //MARK:- ENTER YOUR API KEY HERE
        let urlString = "https://www.personalityforge.com/api/chat/?apiKey=YOUR_API_KEY_HERE&message=\(newTrimmedMessage)&chatBotID=63906&externalID=chirag1"
        print("STRING: \(urlString)")
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONDecoder().decode(BotMessage.self, from: data)
                self.deleteAllRecords(name: "isTyping", indexVlaue: self.messages.count)
                self.fetch()
                self.save(message: json.message.message, position: self.positionNumber, side: .left)
                self.fetch()
            } catch let error {
                print("\(error)")
            }
            
            DispatchQueue.main.async {
                if self.messages.count >= 5 {
                    self.reloadData()
                } else {
                    self.tableView.reloadData()
                }
                self.positionNumber += 1
            }
            
            
            }.resume()
    }
    
    
}

extension messageVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatMessageCell", for: indexPath) as! ChatMessageCell
        
            let message = messages[indexPath.row]
            
            if message.side == "right"{
                cell.typingView.isHidden = true
                cell.leftLbl.isHidden = true
                cell.rightLbl.layer.backgroundColor = #colorLiteral(red: 0.3858584166, green: 0.5081222653, blue: 0.973092854, alpha: 0.309770976)
                cell.rightLbl.layer.bounds.size.height = 40
                cell.updateRight(rightLblMessage: message.message!)
                
            } else if message.side == "left" && message.message == "isTyping"{
                print("I RRRURURURURURURUNNNNNN")
                cell.rightLbl.isHidden = true
                cell.leftLbl.isHidden = true
                cell.typingView.isHidden = false
                cell.typingView.loadGif(name: "typing")
            } else {
                cell.typingView.isHidden = true
                cell.rightLbl.isHidden = true
                cell.leftLbl.layer.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 0.3)
                cell.updateLeft(leftLblMessage: message.message!)
        }
        
        
//        NSIndexPath(forRow: rows - 1, inSection: sections - 1)
        return cell
    }
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0)
        if indexPath.row == lastRowIndex - 2 {
            tableView.scrollToBottom(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = messages[indexPath.row]
        
        if message.side == "right"{
            return 40
        } else {
            return tableView.estimatedRowHeight
        }
        
    }
    
}

extension UITableView {
    func scrollToBottom(animated: Bool = true) {
        let sections = self.numberOfSections
        let rows = self.numberOfRows(inSection: sections - 1)
        if (rows > 0){
            self.scrollToRow(at: IndexPath.init(row: rows - 1, section: sections - 1) as IndexPath, at: .bottom, animated: true)
        }
    }
}


extension messageVC {
    
    func fetch() {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Lmessages>(entityName: "Lmessages")
        
        do {
            messages = try managedContext.fetch(fetchRequest)
        } catch {
            debugPrint("ERROR: \(error.localizedDescription)")
        }
        
    }
    
    
}















