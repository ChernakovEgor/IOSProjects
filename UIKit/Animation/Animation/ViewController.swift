//
//  ViewController.swift
//  Animation
//
//  Created by Egor Chernakov on 01.04.2021.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView: UIImageView!
    var animation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tap(_ sender: UIButton) {
        sender.isHidden = true
        
        //UIView.animate(withDuration: 1, delay: 0, options: []) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.animation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 4, y: 2)
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -250, y: 250)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.5
                self.imageView.backgroundColor = UIColor.systemBlue
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.white
            default:
                break
            }
        }, completion: { _ in
            sender.isHidden = false
        })

        animation += 1
        if animation > 7 {
            animation = 0
        }
    }
    
}

