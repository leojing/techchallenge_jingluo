//
//  HourlyCollectionViewCell.swift
//  techchallenge_jingluo
//
//  Created by JINGLUO on 27/1/18.
//  Copyright © 2018 JINGLUO. All rights reserved.
//

import Foundation
import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func reuseId() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(_ weather: WeatherDetail?) {
        guard let weather = weather else {
            return
        }
        
        if let icon = weather.icon, let iconType = ThemeColor.fromDescription(icon)?.convertToIcon() {
            iconImageView.setIcon(icon: iconType, textColor: .white, backgroundColor: .clear, size: nil)
        }
        let date = Date(timeIntervalSince1970: Double(weather.time ?? 0))
        timeLabel.text = date.timeOfHour()
        temperatureLabel.text = "\(String.fromInt(Int((weather.temperature ?? 0))))℉"
    }
}
