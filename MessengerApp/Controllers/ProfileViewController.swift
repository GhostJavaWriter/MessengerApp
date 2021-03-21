//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: - UI
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var workInfoTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var editButtonOutlet: AppButton!
    @IBOutlet weak var logoView: UIButton!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    
    lazy var cancelEditButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569163918, blue: 0.9567491412, alpha: 1)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelBtnTapped), for: .touchUpInside)
        return button
    }()
    lazy var saveGCDButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save GCD", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.9567790627, green: 0.9569163918, blue: 0.9567491412, alpha: 1)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveGCDBtnTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var verStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var indicatorView : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 10).isActive = true
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        return indicator
    }()
    
    //MARK: - Actions
    @IBAction func closeProfileBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        
        configureSaveButtons()
        
        editingMode(enable: true)
    }
    
    @objc
    private func cancelBtnTapped() {
        logoView.setImage(tempLogoImage, for: .normal)
        nameTextField.text = tempNameText
        workInfoTextField.text = tempWorkText
        locationTextField.text = tempLocationText
        
        editingMode(enable: false)
    }
    
    @objc
    private func saveGCDBtnTapped() {
        if let nameText = nameTextField.text,
           let workText = workInfoTextField.text,
           let location = locationTextField.text {
            indicatorView.startAnimating()
            saveGCDButton.isEnabled = false
            gcdDataManager.saveData(toFile: "userData.json",
                                    name: nameText,
                                    workInfo: workText,
                                    location: location) { [weak self] result in
                DispatchQueue.main.async {
                    self?.indicatorView.stopAnimating()
                }
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.showSavingSucceedAlert()
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self?.showSavingFailAlert()
                    }
                }
            }
        } else {
            print("fields error")
        }
        
        if let image = logoView.imageView?.image {
            gcdDataManager.saveImage(imageString: "logo.jpg", image: image) { (result) in
                switch result {
                case .success(let image):
                    print(image)
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            print("there is no image")
        }
        
        
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
    
    private var tempLogoImage: UIImage?
    private var tempNameText: String?
    private var tempWorkText: String?
    private var tempLocationText: String?
    
    private let gcdDataManager = DataManagerGCD()
    
    private func showSavingSucceedAlert() {
        let alert = UIAlertController(title: "Data saved", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.editingMode(enable: false)
            }
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showSavingFailAlert() {
        let alert = UIAlertController(title: "Error", message: "Saving fail, please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (_) in
            DispatchQueue.main.async {
                self?.editingMode(enable: false)
            }
        }
        let repeatAction = UIAlertAction(title: "Try again", style: .default) { [weak self] (_) in
            self?.saveGCDBtnTapped()
        }
        alert.addAction(okAction)
        alert.addAction(repeatAction)
        present(alert, animated: true)
    }
    
    private func setupLogoView() {
        
        let logoHeight = CGFloat(view.frame.width * 0.6)
        logoView.layer.cornerRadius = logoHeight/2
        logoView.titleLabel?.font = UIFont.systemFont(ofSize: logoHeight / 2)
        
        editButtonOutlet.layer.cornerRadius = 14
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
        
        let ac = UIAlertController(title: "Camera usage",
                                   message: "Please go to settings and allow camera usage",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    private func loadUserDataGCD() {
        gcdDataManager.loadData(fileName: "userData.json") { [weak self] (result) in
            switch result {
            case .success(let data):
                
                parseUserInfoModel(jsonData: data) { (result) in
                    switch result {
                    case .success(let dictionary):
                        self?.nameTextField.text = dictionary["name"]
                        self?.workInfoTextField.text = dictionary["workInfo"]
                        self?.locationTextField.text = dictionary["location"]
                    case .failure:
                        print("parsing error")
                    }
                }
            case .failure:
                print("error loading")
            }
        }
        
        gcdDataManager.loadImage(imageString: "logo.jpg") { [weak self] result in
            switch result {
            case .success(let image):
                self?.logoView.setImage(image, for: .normal)
            case .failure:
                self?.logoView.setImage(nil, for: .normal)
            }
        }
    }
    
    private func editingMode(enable: Bool) {
        
        if enable {
            //save current info for cancel case
            tempLogoImage = logoView.imageView?.image
            tempNameText = nameTextField.text
            tempWorkText = workInfoTextField.text
            tempLocationText = locationTextField.text
            
            editButtonOutlet.isHidden = true
            
            nameTextField.isEnabled = true
            workInfoTextField.isEnabled = true
            locationTextField.isEnabled = true
            
            nameTextField.becomeFirstResponder()
            
            configureSaveButtons()
        } else {
            editButtonOutlet.isHidden = false
            
            nameTextField.isEnabled = false
            workInfoTextField.isEnabled = false
            locationTextField.isEnabled = false
            
            verStackView.removeFromSuperview()
        }
    }
    
    private func configureSaveButtons() {
        
        verStackView.addSubview(cancelEditButton)
        verStackView.addSubview(saveGCDButton)
        
        view.addSubview(verStackView)
        
        NSLayoutConstraint.activate([
            verStackView.topAnchor.constraint(greaterThanOrEqualTo: locationTextField.bottomAnchor, constant: 30),
            verStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            verStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            verStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            
            cancelEditButton.topAnchor.constraint(equalTo: verStackView.topAnchor),
            cancelEditButton.leadingAnchor.constraint(equalTo: verStackView.leadingAnchor),
            cancelEditButton.trailingAnchor.constraint(equalTo: verStackView.trailingAnchor),
            cancelEditButton.bottomAnchor.constraint(equalTo: saveGCDButton.topAnchor, constant: -10),
            cancelEditButton.heightAnchor.constraint(equalToConstant: 40),
            
            saveGCDButton.leadingAnchor.constraint(equalTo: verStackView.leadingAnchor),
            saveGCDButton.trailingAnchor.constraint(equalTo: verStackView.trailingAnchor),
            saveGCDButton.bottomAnchor.constraint(equalTo: verStackView.bottomAnchor),
            saveGCDButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 90
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserDataGCD()
        
        nameTextField.delegate = self
        workInfoTextField.delegate = self
        locationTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupLogoView()
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        editingMode(enable: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        logoView.setImage(image, for: .normal)
        logoView.titleLabel?.text = ""
        
        dismiss(animated: true)
        
        saveGCDButton.isEnabled = true
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        saveGCDButton.isEnabled = true
        
        return true
    }
}

