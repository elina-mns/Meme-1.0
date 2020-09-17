//
//  EditiontheMemeViewController.swift
//  Meme 1.0
//
//  Created by Elina Mansurova on 2020-09-01.
//  Copyright © 2020 Elina Mansurova. All rights reserved.
//

import UIKit

class EditiontheMemeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
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
        activityViewController.completionWithItemsHandler = { _, completed, _, _ in
            guard completed else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            let meme = Meme(image: memedImage,
                            text1: self.textField1.text ?? "",
                            text2: self.textField2.text ?? "")
            appDelegate.memes.append(meme)
        }
        self.present(activityViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMemeTextField(textField: textField1, text: "")
        configureMemeTextField(textField: textField2, text: "")
        shareButton.isEnabled = false
        
        navBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        self.textField1.delegate = self
        self.textField2.delegate = self
    }
    
    func configureMemeTextField(textField: UITextField, text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        textField.text = text
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
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
        if textField2.isEditing {
            view.frame.origin.y = -getKeyBoardHeight(notification)
        }
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        if textField2.isEditing {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat { let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

