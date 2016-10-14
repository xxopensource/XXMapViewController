//
//  AddressListTableViewCell.swift
//  XXMapViewController
//
//  Created by Wangyun on 16/10/11.
//  Copyright © 2016年 Wangyun. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {
    
    
    let titleLabel = UILabel()
    let descLabel = UILabel()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.frame =  CGRect(x: 0, y: 0, width: self.contentView.frame.width, height: 35)
        titleLabel.textColor = UIColor(colorLiteralRed: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        titleLabel.font = UIFont.systemFontOfSize(17.0)
        self.contentView.addSubview(titleLabel)
        descLabel.frame =  CGRect(x: 0, y: 35, width: self.contentView.frame.width, height: 35)
        descLabel.textColor = UIColor(colorLiteralRed: 138.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1.0)
        descLabel.font = UIFont.systemFontOfSize(15.0)
        self.contentView.addSubview(descLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
