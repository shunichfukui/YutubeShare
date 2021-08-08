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
    var db = Firestore.firestore()
    var doneSendProfileDelegate: DoneSendProfileDelegate?
    
    var userID = String()
    var urlString = String()
    var videoID = String()
    var title = String()
    var publishTime = String()
    var desctiption = String()
    var channelTitle = String()

    init() {
    }

    init(userID:String, userName: String,urlString: String,videoID: String,title: String,publishTime: String,desctiption: String,channelTitle: String) {
        self.userID = userID
        self.userName = userName
        self.urlString = urlString
        self.videoID = videoID
        self.title = userID
        self.publishTime = publishTime
        self.desctiption = desctiption
        self.channelTitle = channelTitle
    }
    
    func sendData(userName:String) {
        self.db.collection("contents").document(userName).collection("collection").document().setData(["userID":self.userID as Any, "userName":self.userName as Any,"publishTime":self.publishTime as Any,"urlString":self.urlString as Any,"videoID":self.videoID as Any,"desctiption":self.desctiption as Any,"title":self.title as Any, "channelTitle":self.channelTitle as Any, "postDate":Date().timeIntervalSince1970])
        self.db.collection("Users").addDocument(data: ["userName":self.userName])
    }
    // プロフィールを送信する処理
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
