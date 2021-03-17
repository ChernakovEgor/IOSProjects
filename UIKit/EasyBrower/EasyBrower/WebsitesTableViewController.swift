//
//  WebsitesTableViewController.swift
//  EasyBrower
//
//  Created by Egor Chernakov on 04.03.2021.
//

import UIKit

class WebsitesTableViewController: UITableViewController {
    @IBOutlet var cellTitle: UILabel!
    
    let allowedSites = ["apple.com", "microsoft.com", "sony.com"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Simple Browser"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allowedSites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        cell.textLabel?.text = allowedSites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Web") as? ViewController {
            vc.initialSite = allowedSites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
