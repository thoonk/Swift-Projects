//
//  WeatherTableViewCell.swift
//  WeatherAPITest
//
//  Created by 김태훈 on 2021/01/26.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
