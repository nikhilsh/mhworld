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
    let menuArray = ["Builder", "Skills", "Guides"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "introCell", for: indexPath) as! MenuTableViewCell
        cell.cellLabel.text = menuArray[indexPath.row]
        let view = UIImageView(image: UIImage(named: "\(menuArray[indexPath.row].lowercased())-background"))
        view.contentMode = .scaleAspectFill
        view.alpha = 0.6
        cell.backgroundView = view
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigator = Navigator()
        navigator.register("mhworld://skills") { _,_,_ in
            let storyboard = UIStoryboard.init(name: "Skill", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: "SkillTableViewController")
        }
        navigator.register("mhworld://build") { _,_,_ in
            let storyboard = UIStoryboard.init(name: "Builder", bundle: nil)
            return storyboard.instantiateViewController(withIdentifier: "BuilderTableViewController")
        }
        
        if indexPath.row == 0 {
            navigator.push("mhworld://build")
        } else if indexPath.row == 1 {
            navigator.push("mhworld://skills")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height/3
    }

}

