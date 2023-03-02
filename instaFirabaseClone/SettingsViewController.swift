//
//  SettingsViewController.swift
//  instaFirabaseClone
//
//  Created by Yakup Suda on 1.03.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var mailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mailText.text = Auth.auth().currentUser!.email!
       
        
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toMainVC", sender: nil)
        } catch{
            print("Error")
        }
        
    }
    


}
