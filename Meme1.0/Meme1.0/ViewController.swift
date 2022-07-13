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
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var botTextField: UITextField!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    
    var textField = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareTextField(defaultTextField: topTextField, defaultText: "Top")
        prepareTextField(defaultTextField: botTextField, defaultText: "Bottom")
    }
    
    func prepareTextField(defaultTextField : UITextField, defaultText : String) {
        defaultTextField.text = "\(defaultText) Text"
        defaultTextField.textAlignment = .center
        defaultTextField.delegate = textField
//        defaultTextField.delegate = self
        defaultTextField.defaultTextAttributes = memeTextAttribute
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickFromCamBtn.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareBtn.isEnabled = false
        
        subscribeToKeyboardNotification()
//        hideTheKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    let memeTextAttribute: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.5
    ]
    
    @IBAction func pickFromLib(_ sender: UIImagePickerController.SourceType) {
        pickImage(sender)
    }
    
    @IBAction func pickFromCam(_ sender: UIImagePickerController.SourceType) {
        pickImage(sender)
    }
    
    func pickImage(_ sourceType : UIImagePickerController.SourceType) {
        let nextVC = UIImagePickerController()
        nextVC.delegate = self
        self.present(nextVC, animated: true, completion: nil)
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification : NSNotification){
        if botTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification : NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    func save(){
        _ = Meme(topText: topTextField.text!, botText: botTextField.text!, image: imageView.image!, memedImage: generateMemedImage())

        print("saved")
        }
    
    @IBAction func shareButton(_ sender: Any) {
    
        let image = imageView.image
        let imageToShare = [image!]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.completionWithItemsHandler = {activityViewController, completed, items, error in
            if completed {
                self.save()
            }
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
