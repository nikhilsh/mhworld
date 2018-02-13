//
//  BuilderTableViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 13/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import UIKit
import Moya
import ObjectMapper
import Moya_ObjectMapper
import URLNavigator

class BuilderTableViewController: UITableViewController, UISearchBarDelegate {
    var provider = MoyaProvider<MyService>()
    var skillArray = [Skill]()
    var skillChosenArray = [Skill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSkills()
    }
    
    func fetchSkills() {
        provider.request(.skills) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    let skills = try moyaResponse.mapArray(Skill.self)
                    self.skillArray = skills
                } catch {
                    print("skill array nothing")
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
        return skillArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildCell", for: indexPath) as! BuilderTableViewCell
        let skill = skillArray[indexPath.row]
        cell.skillLabel.text = skill.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let skill = skillArray[indexPath.row] as Skill
        let alertController = UIAlertController(title: skill.name, message: "Enter the skill level required", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
            textfield.placeholder = "Skill level"
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let textfield = alertController.textFields?.first else {
                return
            }
            if let name = skill.name, let id = skill.id, let level = Int(textfield.text!) {
                let chosenSkill = Skill(name: name, level: level, id: id)
                self.skillChosenArray.append(chosenSkill)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    @IBAction func handleDoneButton(_ sender: Any) {
        
        let navigator = Navigator()
        navigator.register("mhworld://builder/results") { _,_,_ in
            let storyboard = UIStoryboard.init(name: "Builder", bundle: nil)
            let viewController: BuiltArmorTableViewController = storyboard.instantiateViewController(withIdentifier: "BuiltArmorTableViewController") as! BuiltArmorTableViewController
            viewController.chosenSkills = self.skillChosenArray
            return viewController
        }
        
        navigator.push("mhworld://builder/results")
        
    }
}
