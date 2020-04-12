//
//  ViewController.swift
//  Smart Weather
//
//  Created by Игорь Силаев on 10/04/2020.
//  Copyright © 2020 Игорь Силаев. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UIViewController {
    
    @IBOutlet weak var textFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func startSearch(_ sender: UIButton) {
        if textFiled.text != "" {
        performSegue(withIdentifier: "event", sender: sender)
        } else {
            textFiled.shakeTextField()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "event" {
            let weatherVC = segue.destination as? WeatherViewController
            weatherVC?.city = textFiled.text
        }
    }
    
    @IBAction func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        textFiled.resignFirstResponder()
    }

}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFiled.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func shakeTextField()
    {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        
        self.attributedPlaceholder = NSAttributedString(string: "Enter city",
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        
    }
}

