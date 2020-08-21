//
//  Wheel.swift
//  test
//
//  Created by Amir Shayegh on 2019-04-17.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

public class Wheel {
    private static var tag = 418194141
    public static var font = UIFont.boldSystemFont(ofSize: 14)
    public static var selectedElementColor: UIColor = UIColor.black
    public static var elementColor: UIColor = UIColor.lightGray
    
    // MARK: Bundle
    static var bundle: Bundle? {
        let podBundle = Bundle(for: Wheel.self)
        
        if let bundleURL = podBundle.url(forResource: "Wheel", withExtension: "bundle"), let b = Bundle(url: bundleURL) {
            return b
        } else {
            print("Fatal Error: Could not find bundle for ModalAlert")
        }
        return nil
    }
    
    public static func show(items: [String],in view: UIView, withInitialValue initialValue: String, onChange: @escaping(_ value: String)->Void) -> HorizontalScrollWheel {
        let wheelView: HorizontalScrollWheel = HorizontalScrollWheel.nib(bundle: bundle)
        for subviews in view.subviews where subviews.tag == tag {
            subviews.removeFromSuperview()
        }
        wheelView.frame = view.frame
        wheelView.tag = tag
        view.addSubview(wheelView)
        wheelView.center = view.center
        wheelView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            wheelView.centerXAnchor.constraint(equalTo:  view.centerXAnchor),
            wheelView.centerYAnchor.constraint(equalTo:  view.centerYAnchor),
            wheelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wheelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wheelView.topAnchor.constraint(equalTo: view.topAnchor),
            wheelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
        wheelView.setup(with: items, initial: initialValue, selectionChanged: onChange)
        return wheelView
    }
}
