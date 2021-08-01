//
//  ViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/07/23.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        button.layer.cornerRadius = 10
        
    }
    
    @IBAction func createNewUser(_ sender: Any) {
        createUser()
    }

    func createUser(){
        Auth.auth().signInAnonymously { (result, error)  in
            let user = result?.user
            print(user.debugDescription)
            UserDefaults.standard.set(self.textfield.text, forKey:"userName")
            
            let profileVC = self.storyboard!.instantiateViewController(identifier:"profileVC") as! ProfileViewController
            
            // 画面遷移
            self.navigationController?.pushViewController(profileVC, animated: true)
            profileVC.userName = self.textfield.text!
            //let profileVC = self.stroyboard
        }
        
    }

}

