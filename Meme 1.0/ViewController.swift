//
//  ViewController.swift
//  Meme 1.0
//
//  Created by Elina Mansurova on 2020-09-01.
//  Copyright © 2020 Elina Mansurova. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    func generateMemedImage() -> UIImage {
        // Render view to an image
        self.toolBar.isHidden = true
        self.navBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.toolBar.isHidden = false
        self.navBar.isHidden = false

        return memedImage
    }
    
    @IBAction func didTapShareButton(_ sender: UIBarButtonItem) {
        shareButton.isEnabled = true
        let memedImage = generateMemedImage()
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
                self.dismiss(animated: true, completion: nil)
            }
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 40)!,
            NSAttributedString.Key.strokeWidth: 3.0,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        textField1.defaultTextAttributes = memeTextAttributes
        textField2.defaultTextAttributes = memeTextAttributes
        shareButton.isEnabled = false
    }
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    //Sign up to be notified when the keyboard appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeForKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @objc func keyBoardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyBoardHeight(notification)
        dismissButton.isEnabled = true
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
        dismissButton.isEnabled = false
    }
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat { let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
    func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            imageView.image = img
            shareButton.isEnabled = imageView.image != nil
            dismiss(animated: true, completion: nil)
        }
    }
}

