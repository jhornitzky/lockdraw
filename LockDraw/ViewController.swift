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
    @IBOutlet weak var changeImageButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    @IBOutlet weak var welcomeView: UIView!
    
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
        blurEffectView2.frame = self.lockView.bounds
        blurEffectView2.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.controlView.addSubview(blurEffectView2)
        self.controlView.sendSubview(toBack: blurEffectView2)
        
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
    
    
    //image area
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.mainImageView
    }
    
    
    //slide lock/unlock
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right && !isLocked {
            lock();
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left && isLocked {
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
        isLocked = true
        
        self.lockText.text = "Slide left to unlock"
        self.lockStatusImage.image = UIImage(named: "Locked Status")
        
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
        isLocked = false
        
        self.lockText.text = "Slide right to lock"
        self.lockStatusImage.image = UIImage(named: "Unlocked Status")
        
        self.mainScrollView.isUserInteractionEnabled = true
        
        AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        
        self.controlView.isHidden = false
        self.lockRightArrow.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.controlView.alpha = 1.0
            self.lockLeftArrow.alpha = 0.0
            self.lockRightArrow.alpha = 1.0
        }, completion: { _ in
            self.lockLeftArrow.isHidden = true
        })
    }
    
    //Image picker
    @IBAction func changeImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //set the image
            self.mainImageView.contentMode = .scaleAspectFit
            self.mainImageView.image = pickedImage
            
            //show the scrollview
            self.mainScrollView.isHidden = false
            
            //add a border to the image
            self.mainImageView.layer.borderWidth = 2
            self.mainImageView.layer.borderColor = UIColor(red:255/255, green:255/255, blue:255/255, alpha: 0.5).cgColor
            
            //remove welcome view
            self.welcomeView.isHidden = true
        }
        
        dismiss(animated: true, completion: {
            //animate background color change for better drawing
            UIView.animate(withDuration: 0.5, animations: {
                self.backgroundImageView.alpha = 0.0
            }, completion: { _ in
                self.backgroundImageView.isHidden = true
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

