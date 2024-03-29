//
//  SearchAndLoadModel.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/08.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import SwiftyJSON
import Alamofire

protocol DoneCatchDataProtocol {
    // 規則
    func doneCatchData(array:[DataSets])
}
protocol DoneLoadDataProtocol {
    // 規則
    func doneLoadData(array:[DataSets])
}

protocol DoneLoadUserNameProtocol {
    // 規則
    func doneLoadUserName(array:[String])
}

protocol DoneLoadProfileProtocol {
    // 規則
    func doneLoadProfileProtocol(check:Int, userName:String, profileTextView: String, imageURLString:String)
}

protocol DoneLoadTrendProtocol {
    // 規則
    func doneLoadTrendProtocol(check:Int, array:[TrendModel])
}

class SearchAndLoadModel {

    var urlString = String()
    var resultPerPage = Int()
    var dataSetsArray:[DataSets] = []
    var trendModelArray:[TrendModel] = []
    var doneCatchDataProtocol: DoneCatchDataProtocol?
    var doneLoadDataProtocol: DoneLoadDataProtocol?
    var doneLoadUserNameProtocol: DoneLoadUserNameProtocol?
    var doneLoadProfileProtocol: DoneLoadProfileProtocol?
    var doneLoadTrendProtocol:DoneLoadTrendProtocol?

    var db = Firestore.firestore()
    var userNameArray = [String]()

    init(urlString:String){
        self.urlString = urlString
    }
    
    init() {
        
    }
    
    //Json解析
    func search() {
        let encordeUrlString = self.urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        AF.request(encordeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            print(response)
            switch response.result {
            case .success:
                do {
                    let json:JSON = try JSON(data:response.data!)

                    print(json.debugDescription)

                    let totalHitCount = json["pageInfo"]["resultsPerPage"].int
                    if totalHitCount! < 50{
                        self.resultPerPage = totalHitCount!
                    } else {
                        self.resultPerPage = totalHitCount!
                    }
                    print(self.resultPerPage)
                    for i in 0...self.resultPerPage - 1 {
                        if let title = json["items"][i]["snippet"]["title"].string,
                           let description = json["items"][i]["snippet"]["description"].string,
                           let url = json["items"][i]["snippet"]["thumbnails"]["default"]["url"].string,
                           let channelTitle = json["items"][i]["snippet"]["channelTitle"].string,
                           let publishTime = json["items"][i]["snippet"]["publishTime"].string,
                           let channelId = json["items"][i]["snippet"]["channelId"].string {
                            if json["items"][i]["id"]["videoId"].string == channelId {
                                // 何もしない
                            } else {
                                let dataSets = DataSets(videoID: json["items"][i]["id"]["videoId"].string,title: title, description: description, url: url, channelTitle: channelTitle, publishTime: publishTime)
                                
                                if title.contains("Error 404") == true || description.contains("Error 404") == true ||
                                    channelTitle.contains("Error 404") == true ||
                                    publishTime.contains("Error 404") == true {
                                    // 何もしない
                                } else {
                                    self.dataSetsArray.append(dataSets)
                                }
                            }
                            // コントローラー側に値を渡す
                            self.doneCatchDataProtocol?.doneCatchData(array: self.dataSetsArray)
                        } else {
                            print("値に不足があります")
                        }
                    }
                }catch{
                    print("エラー")
                }
            case .failure(_): break
                print("エラー break")
            }
        }
    }
    // 自分のリストを受信
    func loadMyListData(userName: String) {
        db.collection("contents").document(userName).collection("collection").order(by: "postDate").addSnapshotListener { snapShot, error in
            self.dataSetsArray = []
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc {
                    let data = doc.data()
                    print(data.debugDescription)
                    if let videoID = data["videoID"] as? String,
                       let urlString = data["urlString"] as? String,
                       let publishTime = data["publishTime"] as? String,
                       let title = data["title"] as? String,
                       let description = data["description"] as? String,
                       let channelTitle = data["channelTitle"] as? String {
                        let dataSets = DataSets(videoID: videoID, title: title, description: description, url: urlString, channelTitle: channelTitle, publishTime: publishTime)
                        self.dataSetsArray.append(dataSets)
                    }
                }
                
                // コントローラーに値を送る
                self.doneLoadDataProtocol?.doneLoadData(array: self.dataSetsArray)
            }
        }
    }
    
    // ユーザー名を取得
    func loadOtherListData() {
        db.collection("Users").addSnapshotListener { (snapShot, error) in
            if let snapShotDoc = snapShot?.documents{
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let userName = data["userName"] as? String {
                        self.userNameArray.append(userName)
                    }
                }
                // コントローラー側にプロトコルを用いて値を渡す
                self.doneLoadUserNameProtocol?.doneLoadUserName(array: self.userNameArray)
            }
            
        }
    }
    
    // プロフィールの受信
    func loadProfile(userName: String) {
        db.collection("profile").document(userName).addSnapshotListener { (snapShot, error) in
            if error != nil {
                print(error.debugDescription)
                return
            }
            let data = snapShot?.data()
            if let userName = data!["userName"] as? String,
               let profileTextView = data!["profileTextView"] as? String,
               let imageURLString = data!["imageURLString"] as? String{
                
                self.doneLoadProfileProtocol?.doneLoadProfileProtocol(check: 1, userName: userName, profileTextView: profileTextView, imageURLString: imageURLString)
            }
        }
    }
    
    // 急上昇
    func getTrend(urlString:String) {
        let encordeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AF.request(encordeUrlString as! URLConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {(response) in
            print(response)
            switch response.result {
            case .success:
                do {
                    let json:JSON = try JSON(data:response.data!)
                    for i in 0...50 - 1 {
                        if let id = json["items"][i]["id"].string,
                           let title = json["items"][i]["snippet"]["title"].string,
                           let description = json["items"][i]["snippet"]["description"].string,
                           let url = json["items"][i]["snippet"]["thumbnails"]["height"]["url"].string,
                           let channelTitle = json["items"][i]["snippet"]["channelTitle"].string,
                           let viewCount = json["items"][i]["statistics"]["viewCount"].string,
                           let likeCount = json["items"][i]["statistics"]["likeCount"].string,
                           let disLikeCount = json["items"][i]["statistics"]["disLikeCount"].string,
                           let tags = json["items"][i]["snippet"]["tags"].array {
                            
                            let trendModel = TrendModel(videoId: id, title: title, url:url, channelTitle: channelTitle, viewCount: viewCount, likeCount:likeCount, disLikeCount: disLikeCount, description: description, tags:tags)
                            self.trendModelArray.append(trendModel)
                           }
                        self.doneLoadTrendProtocol?.doneLoadTrendProtocol(check: 1, array: self.trendModelArray)
                    }
                }catch{
                    print("エラー")
                }
            case .failure(_): break
                print("エラー break")
            }
        }
    }
}
