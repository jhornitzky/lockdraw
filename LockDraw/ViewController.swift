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
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var controlView: UIView!
    
    let imagePicker = UIImagePickerController()
    
    var isLocked = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup image picker
        imagePicker.delegate = self
        
        //set bar radius and effects
        self.lockView.layer.cornerRadius = 10.0
        /*let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.lockView.addSubview(blurEffectView)*/
        
        self.controlView.layer.cornerRadius = 10.0
        /*let blurEffect2 = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView2 = UIVisualEffectView(effect: blurEffect2)
        blurEffectView2.frame = view.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.controlView.addSubview(blurEffectView2)*/
        
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
    
    
    //image area
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mainImageView
    }
    
    
    //slide lock/unlock
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right && !isLocked {
            print("Locking")
            lock();
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left && isLocked {
            print("Unlocking")
            unlock();
        }
        /*
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
         */
    }
    
    private func lock() {
        self.mainScrollView.isUserInteractionEnabled = false
        self.controlView.isHidden = true
        self.lockText.text = "Swipe left to unlock"
        
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
        
        isLocked = true
    }
    
    private func unlock() {
        self.mainScrollView.isUserInteractionEnabled = true
        self.controlView.isHidden = false
        self.lockText.text = "Swipe right to lock"
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
        isLocked = false
    }
    
    //Image picker
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.image = pickedImage
            self.backgroundImageView.isHidden = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

