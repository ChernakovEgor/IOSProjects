//
//  ViewController.swift
//  AdvancedConstraints
//
//  Created by Egor Chernakov on 05.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var viewsDictionary: [String:UILabel] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewsDictionary.updateValue(createLabel("THESE", .red), forKey: "label1")
        viewsDictionary.updateValue(createLabel("ARE", .cyan), forKey: "label2")
        viewsDictionary.updateValue(createLabel("SOME", .green), forKey: "label3")
        viewsDictionary.updateValue(createLabel("AWESOME", .purple), forKey: "label4")
        viewsDictionary.updateValue(createLabel("LABELS", .orange), forKey: "label5")
        
        
//MARK: Visual Fromat Language
        
        for label in viewsDictionary {
            view.addSubview(label.value)
        }
//
//        for label in viewsDictionary.keys {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        let metrics = ["labelHeight" : 88]
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
        
//MARK: Anchor Constraints
        
        var topLabel: UILabel? = nil
        
        for label in viewsDictionary.values {
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
            label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -20).isActive = true
            if let topLabel = topLabel {
                label.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            }
            topLabel = label
        }
        
    }
    
    func createLabel(_ text: String, _ color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = color
        label.text = text
        label.sizeToFit()
        return label
    }

}

