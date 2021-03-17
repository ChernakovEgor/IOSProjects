//
//  DetailsViewController.swift
//  StormViewer
//
//  Created by Egor Chernakov on 03.03.2021.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var number: Int?
    var total: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let num = number, let tot = total {
            title = " Picture \(num) of \(tot)"
        }
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView?.image?.jpegData(compressionQuality: 0.8), let imageName = selectedImage else {
            print("Image not found.")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image, "\(imageName)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
