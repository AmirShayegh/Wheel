//
//  horizontalPickerCollectionViewCell.swift
//  test
//
//  Created by Amir Shayegh on 2019-04-17.
//  Copyright © 2019 Amir Shayegh. All rights reserved.
//

import UIKit

class HorizontalPickerCollectionViewCell: UICollectionViewCell {

    var whenSelected: (()-> Void)?
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func selected(_ sender: UIButton) {
        guard let callback = whenSelected else {return}
        return callback()
    }
    
    func setup(with value: String, isCurrent: Bool, selected: @escaping()-> Void) {
        self.whenSelected = selected
        self.label.text = value
        if isCurrent {select()} else {deselect()}
        style()
    }
    
    func select() {
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let _self = self else {return}
            _self.label.font = Wheel.font
            _self.label.textColor = Wheel.selectedElementColor
        })
    }
    
    func deselect() {
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            guard let _self = self else {return}
            _self.label.font = Wheel.font
            _self.label.textColor = Wheel.elementColor
        })
    }
    
    func style() {
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}
