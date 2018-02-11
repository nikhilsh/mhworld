//
//  SkillTableViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 11/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import UIKit
import Moya
import ObjectMapper
import Moya_ObjectMapper

class SkillTableViewController: UITableViewController, UISearchBarDelegate {
    var provider = MoyaProvider<MyService>()
    var skillArray = [Skill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSkills()
    }
    
    func fetchSkills() {
        var success = true
        provider.request(.skills) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let skills = try moyaResponse.mapArray(Skill.self)
                    self.skillArray = skills
                } catch {
                    success = false
                }
                self.tableView.reloadData()
            case let .failure(error):
                guard let error = error as? CustomStringConvertible else {
                    break
                }
                print(error)
                success = false
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return skillArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "skillCell", for: indexPath) as! SkillTableViewCell

        guard let skill = skillArray[indexPath.row] as? Skill else {
            return UITableViewCell()
        }
        cell.skillLabel.text = skill.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
