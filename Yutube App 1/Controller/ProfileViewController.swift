//
//  ProfileViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/07/31.
//

import UIKit
import Photos
import FirebaseFirestore

class ProfileViewController: UIViewController {

    var userName = String()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        button.layer.cornerRadius = 10
        checkCamera()
        // Do any additional setup after loading the view.
    }
    func checkCamera() {
        // ユーザーに許可を促す.
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch(status){
            case .authorized:print("Authorized")
            case .denied:print("NotDetermined")
            case .restricted: print("limited")
            @unknown default: break
            }
            <#code#>
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
