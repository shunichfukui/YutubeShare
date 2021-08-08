//
//  SearchViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/02.
//

import UIKit
import youtube_ios_player_helper
import FirebaseAuth
import FirebaseFirestore

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var dataSetsArray = [DataSets]()
    var userName = String()
    var db = Firestore.firestore()
    var userID = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:  "VideoCell", bundle: nil),
                           forCellReuseIdentifier: "VideoCell")

        // Do any additional setup after loading the view.
        if UserDefaults.standard.object(forKey: "userName") != nil {
            userName = UserDefaults.standard.object(forKey: "userName") as! String
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell",
            for: indexPath) as! VideoCell
        
    }
    @IBAction func search(_ sender: Any) {
        //textFoeldに入ってるキーワードを元に、Youtubeの検索を行う
        let urlString = "https://www.googleapis.com/youtube/v3/search?key=AIzaSyBtXzgTmEzb2BTkgx01vNUeW9L4Co4vynU&part=snippet&q=\(searchTextField.text!)&maxResults=50"
       
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
