//
//  BuiltArmorDetailsViewController.swift
//  mhworld
//
//  Created by Nikhil Sharma on 18/2/18.
//  Copyright © 2018 nikhil. All rights reserved.
//

import Foundation
import UIKit

class BuiltArmorDetailsViewController: UIViewController {
    @IBOutlet weak var headgearLabel: UILabel!
    @IBOutlet weak var chestLabel: UILabel!
    @IBOutlet weak var armsLabel: UILabel!
    @IBOutlet weak var waistLabel: UILabel!
    @IBOutlet weak var legsLabel: UILabel!
    
    @IBOutlet weak var skillsDetailLabel: UILabel!
    var builtSkill: Builder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLabels()
    }
    
    func loadLabels() {
        guard let builtSkill = builtSkill else {
            return
        }
        
        headgearLabel.text = builtSkill.head
        chestLabel.text = builtSkill.body
        armsLabel.text = builtSkill.arms
        waistLabel.text = builtSkill.waist
        legsLabel.text = builtSkill.legs
        
        skillsDetailLabel.text = generateSkillLabel(skill: builtSkill)
    }
    
    func generateSkillLabel(skill: Builder) -> String {
        var text = ""
        guard let keys = skill.skills?.keys else {
            return "Skills not found"
        }
        guard let skills = skill.skills else {
            return "GGBALLS.COM"
        }
        for key in keys {
            if let skillValue = skills[key] {
                text.append("\(key): \(skillValue)\n")
            }
        }
        return text
    }
}
