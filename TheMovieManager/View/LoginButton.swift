//
//  LoginButton.swift
//  TheMovieManager
//
//  Created by Fabiana Petrovick on 18/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        backgroundColor = UIColor.primaryDark
    }
    
}
