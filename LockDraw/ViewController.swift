//
//  ViewController.swift
//  LockDraw
//
//  Created by James Hornitzky on 10/7/17.
//  Copyright © 2017 James Hornitzky. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var lockView: UIView!
    @IBOutlet weak var lockText: UILabel!
    @IBOutlet weak var lockLeftArrow: UIImageView!
    @IBOutlet weak var lockRightArrow: UIImageView!
    @IBOutlet weak var lockStatusImage: UIImageView!
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    @IBOutlet weak var welcomeView: UIView!
    
    let imagePicker = UIImagePickerController()
    
    var isLocked = false
    var currentFilter = "Original"
    var pickedImage = UIImage()
    var screenBrightness = CGFloat(0.0)
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup image picker
        imagePicker.delegate = self
        
        //set bar radius and effects
        self.lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.lockView.layer.cornerRadius = 10.0
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.lockView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.lockView.addSubview(blurEffectView)
        self.lockView.sendSubview(toBack: blurEffectView)
        
        self.controlView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        self.controlView.layer.cornerRadius = 10.0
        let blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect2)
        blurEffectView2.frame = self.controlView.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.controlView.addSubview(blurEffectView2)
        self.controlView.sendSubview(toBack: blurEffectView2)
        
        self.takePhotoButton.layer.cornerRadius = 10.0
        self.changeImageButton.layer.cornerRadius = 10.0
        self.applyFilterButton.layer.cornerRadius = 10.0
        
        self.welcomeView.layer.cornerRadius = 10.0
        
        //setup slide area lock
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.lockView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.lockView.addGestureRecognizer(swipeRight)
        
        /*
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
         */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //scroll view + image view
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mainImageView
    }
    
    
    //slide lock/unlock
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right && !self.isLocked {
            lock();
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left && self.isLocked {
            unlock();
        }
    }
    
    private func lock() {
        self.isLocked = true
        
        self.lockText.text = "Slide left to unlock"
        self.lockStatusImage.image = UIImage(named: "Locked Status")
        
        self.screenBrightness = UIScreen.main.brightness
        
        self.mainScrollView.isUserInteractionEnabled = false
        
        switch UIApplication.shared.statusBarOrientation{
            case .portrait:
                AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait)
            case .portraitUpsideDown:
                AppUtility.lockOrientation(UIInterfaceOrientationMask.portraitUpsideDown)
            case .landscapeLeft:
                AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeLeft)
            case .landscapeRight:
                AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight)
            case .unknown:
                AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait)
        }
        
        self.lockLeftArrow.isHidden = false
        UIScreen.main.brightness = CGFloat(1.0)
        UIView.animate(withDuration: 0.5, animations: {
            self.controlView.alpha = 0.0
            self.lockLeftArrow.alpha = 1.0
            self.lockRightArrow.alpha = 0.0
        }, completion: { _ in
            self.controlView.isHidden = true
            self.lockRightArrow.isHidden = true
        })
    }
    
    private func unlock() {
        self.isLocked = false
        
        self.lockText.text = "Slide right to lock"
        self.lockStatusImage.image = UIImage(named: "Unlocked Status")
        
        self.mainScrollView.isUserInteractionEnabled = true
        
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
        self.controlView.isHidden = false
        self.lockRightArrow.isHidden = false
        UIScreen.main.brightness = self.screenBrightness
        UIView.animate(withDuration: 0.5, animations: {
            self.controlView.alpha = 1.0
            self.lockLeftArrow.alpha = 0.0
            self.lockRightArrow.alpha = 1.0
        }, completion: { _ in
            self.lockLeftArrow.isHidden = true
        })
    }
    
    
    //Image picker & filtering
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Camera not available", message: "The camera is not available on your device.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        let action = UIAlertController.actionSheetWithItems(
            items: [("Original","Original"),("Grayscale","Grayscale"),("B&W Contrast","B&W Contrast")],
            currentSelection: self.currentFilter,
            action: { (value)  in
                self.currentFilter = value
                self.processFilter()
            })
        action.addAction(UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Present the controller
        self.present(action, animated: true, completion: nil)
    }
    
    private func processFilter() {
        switch self.currentFilter {
        case "Original":
            self.mainImageView.image = self.pickedImage
        case "Grayscale":
            let ciImage = CIImage(image: self.pickedImage)!
            let blackAndWhiteCiImage = ciImage.applyingFilter("CIColorControls", withInputParameters: ["inputSaturation": 0])
            self.mainImageView.image = UIImage(ciImage: blackAndWhiteCiImage)
        case "B&W Contrast":
            let ciImage = CIImage(image: self.pickedImage)!
            let blackAndWhiteCiImage = ciImage.applyingFilter("CIColorControls", withInputParameters: ["inputSaturation": 0, "inputContrast": 3])
            self.mainImageView.image = UIImage(ciImage: blackAndWhiteCiImage)
        default:
            return //do nothing, which should never happen
        }
    }
    
    //MARK: - Add image to Library
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //set the image
            self.pickedImage = pickedImage
            
            //save the image if it came from the camera
            if imagePicker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(self.pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            
            //update image view
            self.mainImageView.image = self.pickedImage
            
            //add a border to the image
            self.mainImageView.layer.borderWidth = 2
            self.mainImageView.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.5).cgColor
            
            //show the scrollview
            self.mainScrollView.isHidden = false
            
            //remove welcome view + background
            self.welcomeView.isHidden = true
            self.backgroundImageView.isHidden = true
            
            //get the views ready
            self.lockView.alpha = 0.0
            self.controlView.alpha = 0.0
            self.lockView.isHidden = false
            self.controlView.isHidden = false
            
            //dismiss modal and trigger control animations
            dismiss(animated: true, completion: {
                //animate background color change for better drawing
                UIView.animate(withDuration: 0.5, animations: {
                    self.lockView.alpha = 1.0
                    self.controlView.alpha = 1.0
                })
            })
        } else {
            dismiss(animated: true, completion: nil) //this should never really happen, but its hear just in case
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

