//
//  TableViewCell.swift
//  CalendarTest
//
//  Created by 김태훈 on 2021/02/06.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
