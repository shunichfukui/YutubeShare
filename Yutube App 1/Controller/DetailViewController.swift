//
//  DetailViewController.swift
//  Pods
//
//  Created by USER on 2021/08/09.
//

import UIKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseFirestore
import EMAlertController

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadDataProtocol, YTPlayerViewDelegate, DoneLoadProfileProtocol {
    


    var userName = String()
    var dataSetsArray = [DataSets]()
    var userID = String()
    var db = Firestore.firestore()
    var youtubeView = YTPlayerView()
    var searchAndLoad = SearchAndLoadModel()

    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:  "VideoCell", bundle: nil),forCellReuseIdentifier: "VideoCell")
        searchAndLoad.doneLoadDataProtocol = self
        searchAndLoad.doneLoadProfileProtocol = self
        searchAndLoad.loadMyListData(userName: userName)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return dataSetsArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.titleLabel.text = dataSetsArray[indexPath.row].title
        cell.thumnailImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].url!), completed: nil)
        cell.channelTitleLabel.text = dataSetsArray[indexPath.row].channelTitle
        cell.dateLabel.text = dataSetsArray[indexPath.row].publishTime
        return cell
    }
    
    
    func doneLoadData(array: [DataSets]) {
        dataSetsArray = array
        tableView.reloadData()
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
        youtubeView.load(widthVideoId: String(dataSetsArray[indexPath.row].videoID!), playerVars: ["playersinline":1])
        view.addSubview(youtubeView)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    @IBAction func showProfile(_ sender: Any) {
        searchAndLoad.loadProfile(userName: userName)
    }

    func doneLoadProfileProtocol(check: Int, userName: String, profileTextView: String, imageURLString: String) {
        if check == 1 {
            // アラートを出す
            showAlert(userName: userName, profileTextView: profileTextView, imageURLString: imageURLString)
        }
    }

    func showAlert(userName: String, profileTextView:String,imageURLString:String) {
        let alert = EMAlertController(title: userName, message: profileTextView)
        let close = EMAlertAction(title: "閉じる", style: .cancel)
        alert.cornerRadius = 10.0
        alert.iconImage = getImageURL(url:imageURLString)
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
