//
//  NotificationCollectionViewCell.swift
//  EliteSISSwift
//
//  Created by Vivek Garg on 28/02/18.
//  Copyright © 2018 Vivek Garg. All rights reserved.
//

import UIKit

class NotificationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tblViewDetails: UITableView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        tblViewDetails.rowHeight = UITableViewAutomaticDimension
        tblViewDetails.register(UINib(nibName:Constants.Nib.NibIdentifier.notificationTableViewCell, bundle: nil), forCellReuseIdentifier: Constants.Nib.ReusableIdentifier.notificationTableViewCell)
        tblViewDetails.separatorStyle = .none
    }

}
