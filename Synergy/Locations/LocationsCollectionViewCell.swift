//
//  LocationsCollectionViewCell.swift
//  getting-started-ios-sdk
//
//  Created by omar on 2019-01-19.
//  Copyright © 2019 Smartcar. All rights reserved.
//

import UIKit

class LocationsCollectionViewCell: UICollectionViewCell {

    
    let productImage : UIImageView = {
        var userImage = UIImageView()
        userImage.layer.masksToBounds = true
        userImage.backgroundColor = .black
        userImage.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        userImage.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        userImage.layer.borderWidth = 3.0
        userImage.layer.cornerRadius = 20
        userImage.clipsToBounds =  true
        userImage.contentMode = .scaleAspectFit
        userImage.translatesAutoresizingMaskIntoConstraints = false
        return userImage
    }()
    
    let Description: UILabel = {
        let detailText = UILabel(frame: CGRect(x: UIScreen.main.bounds.width * 0.3 , y: UIScreen.main.bounds.height * 0.05 , width: UIScreen.main.bounds.width * 0.55 , height: UIScreen.main.bounds.height * 0.1))
        detailText.textAlignment = .left
        detailText.numberOfLines = 0
        detailText.sizeToFit()
        detailText.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        detailText.font = UIFont.boldSystemFont(ofSize: 15)
        return detailText
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Setting up the background color of the cell as white to match the main view
        backgroundColor = .white
        addSubview(productImage)
        addSubview(Description)
        
        NSLayoutConstraint.activate([
            
            productImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            productImage.centerYAnchor.constraint(equalTo: topAnchor, constant: UIScreen.main.bounds.height * 0.07),
            productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.13),
            productImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.13),
            
            
            ])
        
    }
    
    
    
    
    //This is required but nobody ever uses it,
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
