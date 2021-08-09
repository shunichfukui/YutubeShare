//
//  ListViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/08.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadDataProtocol, DoneLoadUserNameProtocol, YTPlayerViewDelegate {
    


    var tag = Int()
    var userName = String()
    var dataSetsArray = [DataSets]()
    var userNameArray = [String]()
    var searchAndLoad = SearchAndLoadModel()
    var youtubeView = YTPlayerView()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:  "VideoCell", bundle: nil),
                           forCellReuseIdentifier: "VideoCell")
        tableView.register(UINib(nibName:  "UserNameCell", bundle: nil),
                           forCellReuseIdentifier: "Cell")
        
        searchAndLoad.doneLoadDataProtocol = self
        searchAndLoad.doneLoadUserNameProtocol = self
        // 受信
        if tag == 1 {
            // 自分のリスト
            searchAndLoad.loadMyListData(userName: userName)
        } else if tag == 2 {
            // 皆のリスト(名前)
            searchAndLoad.loadOtherListData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if tag == 1 {
            self.navigationItem.title == "自分のリスト"
        } else {
            self.navigationItem.title == "皆のリスト"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tag == 1 {
            return dataSetsArray.count
        } else {
            return userNameArray.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
            cell.titleLabel.text = dataSetsArray[indexPath.row].title
            cell.thumnailImageView.sd_setImage(with: URL(string: dataSetsArray[indexPath.row].url!), completed: nil)
            cell.channelTitleLabel.text = dataSetsArray[indexPath.row].channelTitle
            cell.dateLabel.text = dataSetsArray[indexPath.row].publishTime
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserNameCell
            cell.userNameLabel.text = userNameArray[indexPath.row]
            return cell
        }
    }
    
    // 受信
    func doneLoadData(array: [DataSets]) {
        dataSetsArray = array
        tableView.reloadData()
    }
    

    func doneLoadUserName(array: [String]) {
        userNameArray = []
        // 重複を消す
        let orderedSet = NSOrderedSet(array: array)
        print(orderedSet.debugDescription)
        userNameArray = orderedSet.array as! [String]
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tag == 1 {
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
        } else {
            // DetailVCへ移動
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
            detailVC.userName =  userNameArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
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
