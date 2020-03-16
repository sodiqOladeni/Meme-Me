//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by sodiqOladeni on 09/03/2020.
//  Copyright © 2020 NotZero Technologies. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITabBarDelegate,
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topShareBarItem: UIBarButtonItem!
    @IBOutlet weak var topMemeText: UITextField!
    @IBOutlet weak var bottomMemeText: UITextField!
    @IBOutlet weak var openCameraBarItem: UITabBarItem!
    @IBOutlet weak var opeGalleryBarItem: UITabBarItem!
    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var uiTabBarForCameraAndGallery: UITabBar!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTabBarForCameraAndGallery.delegate = self
        imagePicker.delegate = self
        topMemeText.delegate = self
        bottomMemeText.delegate = self
        
        setupTextField(tf: topMemeText, text: "TOP")
        setupTextField(tf: bottomMemeText, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        openCameraBarItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func openCamera() {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    func openAlbumGallery() {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    func chooseImageFromCameraOrPhoto(source:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            imagePicker.sourceType = source;
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomMemeText.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomMemeText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    @IBAction func shareMeme() {
        let memedImage  = generateMemedImage()
        let meme = Meme(topMeme: topMemeText.text!, bottomMeme: bottomMemeText.text!, originalImage: memeImage.image!, newImage: memedImage)
        let activityController = UIActivityViewController(activityItems: [meme.newImage], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save(meme: meme)
                self.dismiss(animated: true, completion: nil)
            }
        }
    
        present(activityController, animated: true, completion: nil)
    }
    
    
    func generateMemedImage() -> UIImage {
        
        navigationController?.isToolbarHidden = true
        uiTabBarForCameraAndGallery.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.isToolbarHidden = false
        uiTabBarForCameraAndGallery.isHidden = false
        
        return memedImage
    }
    
    func save(meme:Meme) {
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.strokeColor : UIColor.black,
            NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSAttributedString.Key.strokeWidth : -4.0,
        ]
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text=="TOP" || textField.text=="BOTTOM"){
            textField.text=""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            openCamera()
        case 1:
            openAlbumGallery()
        default:
            return
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        memeImage.image = image
        dismiss(animated:true, completion: nil)
    }
}

