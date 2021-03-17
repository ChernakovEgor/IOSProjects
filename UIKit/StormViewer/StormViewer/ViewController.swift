//
//  ViewController.swift
//  StormViewer
//
//  Created by Egor Chernakov on 03.03.2021.
//

import UIKit

class ViewController: UITableViewController {
    
    private var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(shareButtonTapped))
        
        performSelector(inBackground: #selector(fetchImages), with: nil)
    }
    
    @objc func fetchImages() {
        let fm = FileManager()
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        print(items)
        
        var pics = [String]()
        for item in items {
            if item.hasPrefix("nssl") {
                pics.append(item)
            }
        }
        pictures = pics.sorted()
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func shareButtonTapped() {
        guard let picture = pictures.first, let jpgImage = UIImage(named: picture)?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let message = "Hey! Check out this app:"
        let link = "https://wowSuchGreatApp.com"
        let vc = UIActivityViewController(activityItems: [message, link, jpgImage], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}


//MARK: TableView
extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailsViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.number = indexPath.row + 1
            vc.total = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

