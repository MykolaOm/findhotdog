//
//  ViewController.swift
//  SeeFood
//
//  Created by Nikolas Omelianov on 30.10.17.
//  Copyright © 2017 Nikolas Omelianov. All rights reserved.
//

import UIKit
import CoreML
import Vision


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    imagePicker.delegate = self
        imagePicker.sourceType = .camera
//        imagePicker.sourceType = .photoLibrary

    imagePicker.allowsEditing = false
        shareButton.isHidden = true
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("can't convert UIImage to CIImage")
        }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
        func detect(image: CIImage) {
            guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else{
                fatalError("loading coreml failed")
              
                }
            
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else{
                    fatalError("model fail to processimage")
                }
                if let firstResult = results.first{
                    if firstResult.identifier.contains("hotdog"){
                        self.navigationItem.title = "Hotdog!"
                        self.shareButton.isHidden = false
                        
                    }
                    else{
                        self.navigationItem.title = "Not Hotdog!"
                    }
                }
            
            }
            let handler = VNImageRequestHandler(ciImage: image)
            do {
                try handler.perform([request])
            }
            catch {
                print(error)
            }
            
        }
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTaped(_ sender: UIButton) {
//        let activityController = UIActivityViewController(activityItems: ["test message from my app", imageView.image!], applicationActivities: nil)
//        present(activityController, animated: true , completion: nil)
        let shareText = "Hello, world!"
        
        if let image = imageView.image {
            let vc = UIActivityViewController(activityItems: [image, shareText], applicationActivities: [])
            present(vc, animated: true)
        }

    }
    
}

