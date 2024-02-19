//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by lebedev on 2/19/24.
//

import UIKit

class ViewController: UIViewController {


    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        print (buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Loaded!")
    }
    

}

