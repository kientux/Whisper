//
//  ViewController.swift
//  WhisperDemo
//
//  Created by Kien Nguyen on 5/21/19.
//  Copyright © 2019 Kien Nguyen. All rights reserved.
//

import UIKit
import Whisper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isWhisperShowing ? .lightContent : .default
    }

    @IBAction func notify() {
        ColorList.Shout.background = UIColor(red: 0, green: 136 / 255, blue: 1, alpha: 1)
        ColorList.Shout.title = .white
        ColorList.Shout.subtitle = .white
        
        let announcement = Announcement(title: "Success!", subtitle: "", image: #imageLiteral(resourceName: "verified"), duration: 2.5)
        
        isWhisperShowing = true
        Whisper.show(shout: announcement, to: self) {
            self.isWhisperShowing = false
        }
    }
}

protocol PropertyStoring {
    
    associatedtype T
    
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T
    func setAssociatedObject(_ key: UnsafeRawPointer!, value: T)
}

extension PropertyStoring {
    func getAssociatedObject(_ key: UnsafeRawPointer!, defaultValue: T) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            return defaultValue
        }
        return value
    }
    
    func setAssociatedObject(_ key: UnsafeRawPointer!, value: T) {
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

extension UIViewController: PropertyStoring {
    
    typealias T = Bool
    
    private struct CustomProperties {
        static var isWhisperShowing = false
    }
    
    var isWhisperShowing: Bool {
        get {
            return getAssociatedObject(&CustomProperties.isWhisperShowing, defaultValue: CustomProperties.isWhisperShowing)
        }
        set {
            setAssociatedObject(&CustomProperties.isWhisperShowing, value: newValue)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
