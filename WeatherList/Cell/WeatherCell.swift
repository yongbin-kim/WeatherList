//
//  WeatherCell.swift
//  WeatherList
//
//  Created by ybKim on 2023/05/02.
//

import UIKit

class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var weatherTitle: UILabel!
    @IBOutlet weak var weatherMax: UILabel!
    @IBOutlet weak var weatherMin: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
