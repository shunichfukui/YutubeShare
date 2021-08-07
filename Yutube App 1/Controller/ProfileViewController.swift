//
//  ProfileViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/07/31.
//

import UIKit
import Photos
import FirebaseFirestore

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, DoneSendProfileDelegate {

    var userName = String()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    func viewDidxLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 10
        textView.layer.cornerRadius = 10
        button.layer.cornerRadius = 10
        checkCamera()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tap(_ sender: Any) {
        showAlert()
        
    }
    // タッチされたときに呼ばれる場所
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードを閉じる
        textView.resignFirstResponder()
        
    }

    func checkCamera() {
        // ユーザーに許可を促す.
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch(status){
            case .authorized:print("Authorized")
            case .denied:print("NotDetermined")
            case .restricted: print("limited")
            case .notDetermined:
                
            case .limited:
                <#code#>
            @unknown default: break
            }
            <#code#>
        }
    }
    
    func showAlert(){
        let alert:UIAlertController = UIAlertController(title:"選択してください。", message: "カメラアルバムをどちらにしますか？", preferredStyle: .alert)
        // カメラボタン
        let cameraAction: UIAlertAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action: UIAlertAction!)-> Void in self.createImagePicker(sourceType: .camera)
        })
        // アルバムボタン
        let albumAction: UIAlertAction = UIAlertAction(title: "アルバム", style: .default, handler: {
            // ボタンが押された時の処理
            (action:UIAlertAction!)-> Void in
            self.createImagePicker(sourceType: .photoLibrary)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(albumAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        
        // Alertを表示
        present(alert, animated: true, completion: nil)
    }

    func createImagePicker(sourceType: UIImagePickerController.SourceType){
        let cameraPicker = UIImagePickerController()
        cameraPicker.sourceType = sourceType
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        self.present(cameraPicker, animated: true, completion: nil)
    }

    // 撮影がキャンセルになった時に呼ばれる
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]){
        if let pickedImage = info[.editedImage] as? UIImage {
            imageView.image = pickedImage
            // 閉じる処理
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func dane(_ sender: Any) {
        // dbに送信
        let sendDB = SendDB()
        sendDB.doneSendProfileDelegate = self

        sendDB.sendProfile(userName: userName, imageData: imageView.image?.jpegData(compressionQuality: 0.5), profileTextView: textView.text!)
    }
    
    func DoneSendProfileDelegate(sendCheck: Int) {
        if sendCheck == 1 {
            // 画面遷移
            let searchVC = self.storyboard?.instantiateViewController(identifier: "searchVC") as! SearchViewController
            self.navigationController?.pushViewController(searchVC, animated: true)
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
