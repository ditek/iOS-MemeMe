//
//  ViewController.swift
//  meme
//
//  Created by Diaa on 19/12/2020.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    // MARK: Lifecycle

    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        shareButton.isEnabled = false
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraButton.isEnabled = false
        }
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth:  -4.0,
        ]
        topText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.defaultTextAttributes = memeTextAttributes
        bottomText.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: Notofication handling
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        print("keyboard show")
        // Sometimes the show event is triggered twice.
        // We check the animation duration and if it is 0 then it's a fake one
        if bottomText.isEditing,
           let duration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Float,
           duration > 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        print("keyboard hide")
        if bottomText.isEditing {
            view.frame.origin.y = 0
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    // MARK: Callbacks
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            picker.dismiss(animated: true, completion: nil)
            shareButton.isEnabled = true
        } else {
            print("Error while displaying image")
        }
    }
    
    func selectImages(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func selectFromLibrary(_ sender: Any) {
        selectImages(source: .photoLibrary)
    }
    
    @IBAction func selectFromCamera(_ sender: Any) {
        selectImages(source: .camera)
    }
    
    @IBAction func share() {
        topBar.isHidden = true
        bottomBar.isHidden = true
        let memeImage = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activity.completionWithItemsHandler = { (type, completed, items, error) in
            if completed {
                let meme = Meme(
                    topText: self.topText.text!,
                    bottomText: self.bottomText.text!,
                    originalImage: self.imageView.image!,
                    memedImage: memeImage
                )
                print(meme)
            }
        }
        present(activity, animated: true, completion: nil)
        topBar.isHidden = false
        bottomBar.isHidden = false
    }
    
    @IBAction func resetUI(_ sender: Any) {
        topText.text = ""
        bottomText.text = ""
        imageView.image = nil
        shareButton.isEnabled = false
    }
    
    
    // MARK: Other
    
    // Render view to an image
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
}

