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

class BuilderTableViewController: UITableViewController, UISearchBarDelegate, UISearchResultsUpdating, UITextFieldDelegate {
    var provider = MoyaProvider<MyService>()
    var skillArray = [Skill]()
    var filteredSkillArray = [Skill]()
    var skillChosenArray = [Skill]()
    var currentSkill: Skill?
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchSkills()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search skills"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
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
        if isFiltering() {
            return filteredSkillArray.count
        }
        
        return skillArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "buildCell", for: indexPath) as! BuilderTableViewCell
        let skill: Skill
        if isFiltering() {
            skill = filteredSkillArray[indexPath.row]
        } else {
            skill = skillArray[indexPath.row]
        }
        cell.skillLabel.text = skill.name
        if let skillLevel = skill.level {
            cell.skillLevelLabel.text = String(skillLevel)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var skill: Skill
        if isFiltering() {
            skill = filteredSkillArray[indexPath.row]
        } else {
            skill = skillArray[indexPath.row]
        }
        currentSkill = skill
        guard let maxSkillLevel = skill.max else {
            return
        }
        let alertController = UIAlertController(title: skill.name, message: "Enter the skill level required. \nMax level: \(String(maxSkillLevel))", preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.keyboardType = .numberPad
            textfield.placeholder = "Skill level"
            textfield.delegate = self
        }
        let saveAction = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let textfield = alertController.textFields?.first else {
                return
            }
            if let name = skill.name, let id = skill.id, let level = Int(textfield.text!) {
                let chosenSkill = Skill(name: name, level: level, id: id)
                skill.level = level
                if self.isFiltering() {
                    self.filteredSkillArray[indexPath.row] = skill
                } else {
                    self.skillArray[indexPath.row] = skill
                }
                self.skillChosenArray.append(chosenSkill)
            }
            self.searchController.searchBar.text = ""
            tableView.reloadRows(at: [indexPath], with: .fade)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let skill = currentSkill else {
            return false
        }
        guard let text = textField.text else {
            return false
        }
        let newString = text.replacingCharacters(in: Range(range, in: text)!, with: string)
        if newString.isEmpty {
            return true
        }
        guard let intValue = Int(newString) else {
            return false
        }
        return (intValue > 0 && intValue <= skill.max!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResults = searchController.searchBar.text else {
            return
        }
        filterContentForSearchText(searchResults)
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredSkillArray = skillArray.filter({(skill: Skill) -> Bool in
            return skill.name!.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
