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

class TrendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadTrendProtocol, YTPlayerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var descLabel: UILabel!

    var searchAndLoad = SearchAndLoadModel()
    var trendModelArray = [TrendModel]()
    var youtubeView = YTPlayerView()
    var urlString = String()
    var tagContents = String()
    var loading = Loading()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchAndLoad.doneLoadTrendProtocol = self

        tagButton.isHidden = true
        closeButton.isHidden = true
        descLabel.isHidden = true
        blurView.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        loading.startAnimation(view: self.view)
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
            DispatchQueue.main.async {
                self.loading.stopAnimation()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 自分のリスト((YouTubeを再生)
        youtubeView.removeFromSuperview()
        // ステータスバーの高さを取得
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        // ナビゲーションバーの高さを取得
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        youtubeView = YTPlayerView(frame: CGRect(x: 0, y: statusBarHeight + navBarHeight!, width: view.frame.size.width, height: 240))
        youtubeView.delegate = self
        youtubeView.load(widthVideoId: String(trendModelArray[indexPath.row].videoId!), playerVars: ["playersinline":1])
        view.addSubview(youtubeView)
        
        descLabel.text = trendModelArray[indexPath.row].description
        urlString = trendModelArray[indexPath.row].url!
        print(trendModelArray[indexPath.row].tags!)
        print(trendModelArray[indexPath.row].tags!.description)
        tagContents = trendModelArray[indexPath.row].tags!.description
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        descLabel.alpha = 0.0
        descLabel.isHidden = false
        UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveLinear) {
            self.descLabel.alpha = 1.0
            self.navigationController?.navigationBar.alpha = 0.0
        } completion: { (result) in
            self.blurView.isHidden = false
            self.closeButton.isHidden = false
            self.tagButton.isHidden = false
            playerView.playVideo()
        }
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.descLabel.isHidden = true
        self.closeButton.isHidden = true
        self.blurView.isHidden = true
        self.tagButton.isHidden = true
        self.navigationController?.navigationBar.alpha = 1.0
        youtubeView.removeFromSuperview()
    }
    
    @IBAction func showTagAlert(_ sender: Any) {
        showProfile()
    }
    
    func showProfile() {
        let alert = EMAlertController(title: "この動画に設定されてるタグ", message: tagContents)
        let close = EMAlertAction(title: "閉じる", style: .cancel)
        alert.cornerRadius = 10.0
        alert.iconImage = getImageURL(url:urlString)
        alert.addAction(close)
        present(alert, animated: true, completion: nil)
    }

    func getImageURL(url:String) -> UIImage {
        let url = URL(string: url)
        do{
            let data = try Data(contentsOf: url!)
            return UIImage (data: data)!
        }catch {
            print("画像取得エラー")
        }
        return UIImage()
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
