//
//  ViewController.swift
//  InstaFilter
//
//  Created by Egor Chernakov on 17.03.2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensitySlider: UISlider!
    @IBOutlet var changeFilterButton: UIButton!
    
    var currentImage: UIImage!
    
    var context: CIContext!
    var filter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))
        
        context = CIContext()
        filter = CIFilter(name: "CISepiaTone")
        changeFilterButton.titleLabel!.text = "CISepiaTone"
    }
    
    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func filterChanged(_ sender: UIButton) {
        let ac = UIAlertController(title: "Select filter", message: nil, preferredStyle: .actionSheet)

        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Please select an image", message: "There is no image selected.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK!", style: .default, handler: nil))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    func applyProcessing() {
        let keys = filter.inputKeys
        
        if keys.contains(kCIInputIntensityKey) {
            filter.setValue(intensitySlider.value, forKey: kCIInputIntensityKey)
        }
        
        if keys.contains(kCIInputRadiusKey) {
            filter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
        }
        
        if keys.contains(kCIInputScaleKey) {
            filter.setValue(intensitySlider.value * 10, forKey: kCIInputScaleKey)
        }
        
        if keys.contains(kCIInputCenterKey) {
            filter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        guard let outputImage = filter.outputImage else { return }
    
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
    
    func setFilter(_ action: UIAlertAction) {
        guard let title = action.title else { return }
        guard currentImage != nil else { return }
        
        filter = CIFilter(name: title)
        let beginImage = CIImage(image: currentImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        changeFilterButton.titleLabel?.text = title
        applyProcessing()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        var title = "Saved!"
        var message = "Photo was saved to your library."
        if let errorUnwrapped = error {
            title = "Error"
            message = errorUnwrapped.localizedDescription
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK!", style: .default, handler: nil))
        present(ac, animated: true)
    }
}

