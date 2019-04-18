//
//  ViewController.swift
//  Wheel
//
//  Created by AmirShayegh on 04/18/2019.
//  Copyright (c) 2019 AmirShayegh. All rights reserved.
//

import UIKit
import Wheel

class ViewController: UIViewController {

    let isos:[Int] = [32,50,64,80,100,125,160,200,250,320,400,500,640,800,1000,1250,1600,1800]
    var shutters:[Int] = [1,2,4,8,15,30,60,125,250,500,1000,2000,4000,8000]
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let stringArray = self.isos.map { "\($0)" }
        
        let wheel = Wheel.show(items: stringArray, in: self.view, withInitialValue: stringArray.first ?? "") { (new) in
            print(new)
        }
        
        wheel.select(item: "125")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            wheel.select(item: "320")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                wheel.select(item: "500")
            }
        }
    }

}

