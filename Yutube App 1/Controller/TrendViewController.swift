//
//  TrendViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/14.
//

import UIKit
import SwiftyJSON
import Alamofire
import SDWebImage
import youtube_ios_player_helper
import EMAlertController

class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadTrendProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    var searchAndLoad = SearchAndLoadModel()
    var trendModelArray = [TrendModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchAndLoad.doneLoadTrendProtocol = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        searchAndLoad.getTrend(urlString: "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&regionCode=JP&chart=mostPopular&key=AIzaSyBtXzgTmEzb2BTkgx01vNUeW9L4Co4vynU&maxResults=50")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return trendModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: trendModelArray[indexPath.row].url!), completed: nil)
        let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
        titleLabel.text = trendModelArray[indexPath.row].title
        let channeltitleLabel = cell.contentView.viewWithTag(3) as! UILabel
        channeltitleLabel.text = trendModelArray[indexPath.row].channelTitle
        let viewCountLabel = cell.contentView.viewWithTag(4) as! UILabel
        viewCountLabel.text = trendModelArray[indexPath.row].viewCount

        let likeCountLabel = cell.contentView.viewWithTag(5) as! UILabel
        likeCountLabel.text = trendModelArray[indexPath.row].likeCount
        
        let disLikeCountLabel = cell.contentView.viewWithTag(6) as! UILabel
        disLikeCountLabel.text = trendModelArray[indexPath.row].disLikeCount

        return cell
    }
    
    func doneLoadTrendProtocol(check: Int, array:[TrendModel]) {
        if check == 1 {
            trendModelArray = array
            tableView.reloadData()
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
