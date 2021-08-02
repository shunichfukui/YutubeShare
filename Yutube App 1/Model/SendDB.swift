//
//  SendDB.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/01.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

protocol DoneSendProfileDelegate {
    // 範囲を決める
    func doneSendProfileDelegate(sendCheck: Int)
}

class SendDB {
    var userName = String()
    var imageData = Data()
    var db = FirebaseFirestore()
    var doneSendProfileDelegate: DoneSendProfileDelegate?
    
    init() {
    }

    func sendProfile (userName: String, imageData: Data, profileTextView:String) {
        // データの送信処理
        let imageRef = Storage.storage().reference().child("ProfileImageFolder").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")

        imageRef.putData(imageData, metadata: nil) {
            (metadata, error) in
            
            if error != nil {
                print(error.debugDescription)
                return
            }

            imageRef.downloadURL {
                (url, error) in
                if error != nil {
                    print(error.debugDescription)
                    return
                }

                // 送信
                self.db.collection("profile").document(userName).setData(
                    ["userName": userName as Any, "imageURLString": url?.absoluteString as Any, "profileTextView": profileTextView as Any]
                )
                // 送信完了
                self.doneSendProfileDelegate?.doneSendProfileDelegate(sendCheck: 1)
            }
        }
    }
}
