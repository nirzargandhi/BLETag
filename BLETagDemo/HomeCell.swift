//
//  HomeCell.swift
//  BLETagDemo
//
//  Created by Nirzar Gandhi on 19/02/25.
//

import UIKit
import CoreBluetooth

class HomeCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var authorizeLabel: UILabel!
    
    
    // MARK: - Variables
    
    
    // MARK: - Cell init methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        // Container
        self.container.backgroundColor = UIColor(hex: "#FFFFFF")
        self.container.addRadiusWithBorder(radius: 15.0)
        self.container.clipsToBounds = true
        
        // StackView
        self.stackView.backgroundColor = .clear
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillProportionally
        self.stackView.spacing = 8.0
        
        // Device Name Label
        self.deviceNameLabel.backgroundColor = .clear
        self.deviceNameLabel.textColor = .black
        self.deviceNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.deviceNameLabel.textAlignment = .left
        self.deviceNameLabel.numberOfLines = 0
        self.deviceNameLabel.lineBreakMode = .byWordWrapping
        self.deviceNameLabel.text = ""
        
        // State Label
        self.stateLabel.backgroundColor = .clear
        self.stateLabel.textColor = .black
        self.stateLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.stateLabel.textAlignment = .left
        self.stateLabel.numberOfLines = 0
        self.stateLabel.lineBreakMode = .byWordWrapping
        self.stateLabel.text = ""
        
        // Authorize Label
        self.authorizeLabel.backgroundColor = .clear
        self.authorizeLabel.textColor = .black
        self.authorizeLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.authorizeLabel.textAlignment = .left
        self.authorizeLabel.numberOfLines = 0
        self.authorizeLabel.lineBreakMode = .byWordWrapping
        self.authorizeLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Cell Configuration
    func configureCell(peripheral: CBPeripheral?) {
        
        // Device Name Label
        self.deviceNameLabel.text = "Device Name - "
        if let name = peripheral?.name, name.count > 0 {
            self.deviceNameLabel.attributedText = multiattributedString(strings: ["Device Name - ", name], fonts: [UIFont.systemFont(ofSize: 16, weight: .semibold), UIFont.systemFont(ofSize: 14, weight: .regular)], colors: [.black, .black.withAlphaComponent(0.7)], alignments: [.left, .left])
        }
        
        // State Label
        self.stateLabel.text = "State - "
        if let state = peripheral?.state {
            
            var stateStr = ""
            
            switch state {
                
            case .connected:
                stateStr = "Connected"
                
            case .disconnected:
                stateStr = "Disconnected"
                
            default:
                stateStr = "Unknown"
            }
            
            self.stateLabel.attributedText = multiattributedString(strings: ["State - ", stateStr], fonts: [UIFont.systemFont(ofSize: 16, weight: .semibold), UIFont.systemFont(ofSize: 14, weight: .regular)], colors: [.black, .black.withAlphaComponent(0.7)], alignments: [.left, .left])
        }
        
        // Authorize Label
        self.authorizeLabel.text = "Authorized - "
        if #available(iOS 13.0, *) {
            if let authorized = peripheral?.ancsAuthorized {
                self.authorizeLabel.attributedText = multiattributedString(strings: ["Authorized - ", "\(authorized)"], fonts: [UIFont.systemFont(ofSize: 16, weight: .semibold), UIFont.systemFont(ofSize: 14, weight: .regular)], colors: [.black, .black.withAlphaComponent(0.7)], alignments: [.left, .left])
            }
        }
    }
}
