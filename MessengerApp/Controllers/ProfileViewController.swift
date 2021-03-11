//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - UI
    @IBOutlet weak var fullNameLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var editButtonOutlet: UIButton?
    @IBOutlet weak var logoView: UIButton?
    @IBOutlet weak var closeButtonOutlet: UIButton?
    
    //MARK: - Actions
    @IBAction func closeProfileBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        print("edit tapped")
        
    }
    
    @IBAction func logoViewTapped(_ sender: Any) {
        
        let ac = UIAlertController(title: "Set photo from ...", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { [weak self] action in
            if let title = action.title {
                self?.setLogoImage(actionType: title)
            } else {
                print("Action type error in " + #function)
            }
        }))
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            ac.addAction(UIAlertAction(title: "Take a photo", style: .default, handler: { [weak self] action in
                if let title = action.title {
                    self?.setLogoImage(actionType: title)
                } else {
                    print("Action type error in " + #function)
                }
            }))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    //MARK: - Private
    private func setupLogoView() {
        
        let logoHeight = CGFloat(view.frame.width * 0.6)
        logoView?.layer.cornerRadius = logoHeight/2
        logoView?.titleLabel?.font = UIFont.systemFont(ofSize: logoHeight / 2)
        
        editButtonOutlet?.layer.cornerRadius = 14
        descriptionLabel?.text = "iOS course student\nIrkutsk, Russia sdfsdf sdfsdf sdf sdf sdfsd fsfs sdfsdfsdfs sdfsfsf done sdfsdf sdf sf sdfs r"
    }
    
    private func setLogoImage(actionType: String) {
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if actionType == "Photo library" {
            
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        } else if actionType == "Take a photo" {
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                
                case .authorized:
                    
                    picker.sourceType = .camera
                    present(picker, animated: true, completion: nil)
                    
                case .notDetermined:
                    
                    AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                        if granted {
                            DispatchQueue.main.async {
                                picker.sourceType = .camera
                                self?.present(picker, animated: true, completion: nil)
                            }
                        }
                    }
                
                case .denied:
                    askPermissionForCameraUsage()
                    return
                case .restricted:
                    askPermissionForCameraUsage()
                    return
                @unknown default:
                    return
                }
                
            } else {
                NSLog("camera is not aviable " + #function)
            }
            
        } else {
            NSLog("Action type doesn't exist " + #function)
        }
    }
    
    private func askPermissionForCameraUsage() {
        let ac = UIAlertController(title: "Camera usage", message: "Please go to settings and allow camera usage", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLogoView()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        logoView?.setImage(image, for: .normal)
        logoView?.titleLabel?.text = ""
        
        dismiss(animated: true)
    }
}

