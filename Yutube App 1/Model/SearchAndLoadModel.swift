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
