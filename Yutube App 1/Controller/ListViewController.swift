//
//  ListViewController.swift
//  Yutube App 1
//
//  Created by USER on 2021/08/08.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    var tag = Int()
    var userName = String()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName:  "VideoCell", bundle: nil),
                           forCellReuseIdentifier: "VideoCell")
        tableView.register(UINib(nibName:  "UserNameCell", bundle: nil),
                           forCellReuseIdentifier: "Cell")
        
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
        } else if tag == 2 {
            self.navigationItem.title == "皆のリスト"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tag == 1 {
            self.navigationItem.title == "自分のリスト"
        } else if tag == 2 {
            self.navigationItem.title == "皆のリスト"
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
