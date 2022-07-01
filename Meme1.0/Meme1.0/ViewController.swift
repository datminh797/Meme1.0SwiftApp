//
//  ViewController.swift
//  Meme1.0
//
//  Created by minhdat on 30/06/2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickFromLibBtn: UIButton!
    @IBOutlet weak var pickFromCamBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var botTextField: UITextField!
    
    var textField = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.text = "Top Text"
        topTextField.textAlignment = .center
        topTextField.delegate = textField
        topTextField.defaultTextAttributes = memeTextAttribute
        
        botTextField.text = "Top Text"
        botTextField.textAlignment = .center
        botTextField.delegate = textField
        botTextField.defaultTextAttributes = memeTextAttribute
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickFromCamBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareBtn.isEnabled = false
        
        subscribeToKeyboardNotification()
        hideTheKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
    
    let memeTextAttribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: 10.5
    ]
    
    @IBAction func pickFromLib(_ sender: Any) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        nextController.sourceType = .photoLibrary
        self.present(nextController, animated: true, completion: nil)
    }
    
    @IBAction func pickFromCam(_ sender: Any) {
        let nextController = UIImagePickerController()
        nextController.delegate = self
        self.present(nextController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            shareBtn.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : NSNotification){
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func hideTheKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification : NSNotification){
        view.frame.origin.y = 0
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActivityViewController" {
            let dvc =  segue.destination as! ActivityViewController
            dvc.receivedImage = self.generateMemedImage()
        }
    }
    
    func save(){
            let meme = Meme(topText: topTextField.text!, botText: botTextField.text!, image: imageView.image!, memedImage: generateMemedImage())
        }
}

