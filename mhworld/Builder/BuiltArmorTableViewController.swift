//
//  BuiltArmorTableViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 14/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import UIKit
import Moya
import ObjectMapper
import Moya_ObjectMapper

class BuiltArmorTableViewController: UITableViewController {
    var chosenSkills = [Skill]()
    var provider = MoyaProvider<MyService>()
    var armorList = [Builder]()
    var slots = [String: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSkills()
    }
    
    func fetchSkills() {
        let skillsDictionary = self.chosenSkills.map { (skill) -> [String: Any] in
            skill.toJSON()
        }
        provider.request(.builder(skills: skillsDictionary, slots: ["level1": 0, "level2": 0])) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let armor = try moyaResponse.mapArray(Builder.self)
                    self.armorList = armor
                } catch {
                    print("armor array nothing")
                }
                self.tableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return armorList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "builtArmorCell", for: indexPath) as! BuiltArmorTableViewCell
        let armor = armorList[indexPath.row]
        cell.headLabel.text = armor.head
        cell.armsLabel.text = armor.arms
        cell.waistLabel.text = armor.waist
        cell.chestLabel.text = armor.body
        cell.legsLabel.text = armor.legs
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 216
    }
}
