//
//  ProfileViewController.swift
//  MessengerApp
//
//  Created by Bair Nadtsalov on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - UI
    @IBOutlet weak var logoBackgroundView: UIView?
    @IBOutlet weak var logoFirstLetter: UILabel?
    @IBOutlet weak var logoSecondLetter: UILabel?
    @IBOutlet weak var fullNameLabel: UILabel?
    @IBOutlet weak var positionLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?
    @IBOutlet weak var editButtonOutlet: UIButton?
    
    //MARK: - Private
    private func setupView() {
        //viewController title
        title = "My Profile"
        
        //setup logoBackgroundView
        if let cornerRadius = logoBackgroundView?.frame.height {
            logoBackgroundView?.layer.cornerRadius = cornerRadius/2
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLogo))
        logoBackgroundView?.addGestureRecognizer(tapGesture)
        
        editButtonOutlet?.layer.cornerRadius = 14
        
    }
    
    @objc
    private func tapLogo() {
        
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
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    private func setLogoImage(actionType: String) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        switch actionType {
        
        case "Photo library":
            picker.sourceType = .photoLibrary
        case "Take a photo":
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
            } else {
                NSLog("camera is not aviable " + #function)
            }
            
        default:
            NSLog("Action type doesn't exist " + #function)
        }
        
        present(picker, animated: true)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //MARK: - Lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NSLog("editButton frame : \(String(describing: editButtonOutlet?.frame)) " + #function)
        /*Метод инит не вызывается потому что
        Из документации apple:
         This is the designated initializer for this class. When using a storyboard to define your view controller and its associated views, you never initialize your view controller class directly. Instead, view controllers are instantiated by the storyboard either automatically when a segue is triggered or programmatically when your app calls the instantiateViewController(withIdentifier:) method of a storyboard object. When instantiating a view controller from a storyboard, iOS initializes the new view controller by calling its init(coder:) method instead of this method and sets the nibName property to a nib file stored inside the storyboard.
         соответственно этот метод не вызвается в нашем случае, storyboard сам инициализирует вызывая init(coder:)
        */
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NSLog("editButton frame : \(String(describing: editButtonOutlet?.frame)) " + #function)
        //здесь editButtonOutlet еще не создан, так как все outlet'ы создаются после инициализации самого ViewController'a
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("ViewController : \(#function)")
        NSLog("editButton frame : \(String(describing: editButtonOutlet?.frame)) " + #function)
        /*
         На данном этапе жизненного цикла контроллера, размеры view не актуальны, т.е. не такие, какими они будут после вывода на экран. Поэтому, использовать вычисления, основанные на ширине / высоте view, в методе viewDidload не рекомендуется.
         */
        setupView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NSLog("ViewController : " + #function)
        NSLog("editButton frame : \(String(describing: editButtonOutlet?.frame))")
        //Frame отличается потому что - в методе viewDidLoad прописан layout, который установлен в storyboard, а autolayout меняет эти значения согласно constraints в зависимости от фактического устройства
        /*
         Методы, которые вызываются перед и после появления view на экране.
         В случае анимации(появление контроллера в модальном окне, или переход в UINavigationController'e), viewWillAppear будет вызван до анимации, а viewDidAppear — после.
         При вызове viewWillAppear, view уже находится в иерархии отображения (view hierarchy) и имеет актуальные размеры, так, что здесь можно производить расчеты, основанные на ширине / высоте view.
         */
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSLog("ViewController : " + #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NSLog("ViewController : " + #function)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        //saving logo image
        let imageName = "avatar"
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.7) {
            try? jpegData.write(to: imagePath)
        }
        
        dismiss(animated: true)
    }
}

