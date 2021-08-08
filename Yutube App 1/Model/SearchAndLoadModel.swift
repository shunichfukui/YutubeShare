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


class SearchAndLoadModel {

    var urlString = String()
    var resultPerPage = Int()
    var dataSetsArray:[DataSets] = []

    init(urlString:String){
        self.urlString = urlString
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
                        } else {
                            print("値に不足があります")
                        }
                    }
                }catch{
                    print("エラー")
                }
            case .failure(_): break
                <#code#>
            }
        }
    }
}
