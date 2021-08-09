//
//  ListViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/08.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DoneLoadDataProtocol {


    var tag = Int()
    var userName = String()
    var dataSetsArray = [DataSets]()
    var userNameArray = [String]()
    var searchAndLoad = SearchAndLoadModel()
    
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
        // 受信
        if tag == 1 {
            // 自分のリスト
        } else if tag == 2 {
            // 皆のリスト
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
           
        }
    }
    
    // 受信
    func doneLoadData(array: [DataSets]) {
        dataSetsArray = array
        tableView.reloadData()
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
