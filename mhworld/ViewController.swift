//
//  ViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 6/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import UIKit
import Moya
import URLNavigator

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        setupNetworkLayer()
    }
    
//    func setupNetworkLayer() {
//        // Tuck this away somewhere where it'll be visible to anyone who wants to use it
//        var provider: MoyaProvider<MyService>!
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "introCell", for: indexPath) as! MenuTableViewCell
        switch indexPath.row {
        case 0:
            cell.cellLabel.text = "Builder"
        case 1:
            cell.cellLabel.text = "Skills"
        case 2:
            cell.cellLabel.text = "Guides"
        default:
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigator = Navigator()
        navigator.register("mhworld://skills") {_,_,_ in
            let storyboard = UIStoryboard.init(name: "Skill", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: "SkillTableViewController")
        }
        navigator.push("mhworld://skills")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height/3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

