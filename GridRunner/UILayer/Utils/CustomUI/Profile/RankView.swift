//
//  RankView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 03.09.23.
//

import UIKit

class RankView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 0
        
        return stackView
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.headingFont)
        return label
    }()
    
    private let rankTypeLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Kanit-Regular", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Gray")
        return label
    }()
    
    // Computed properties.
    var rank: Int? {
        didSet {
            self.rankLabel.text = "\(self.rank ?? 0) GR"
        }
    }
    
    var rankType: RankType? {
        didSet {
            self.rankTypeLabel.text = "your \(self.rankType?.rawValue ?? "player") rank"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.addSubview(stackView)

        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        
        self.stackView.addArrangedSubview(rankLabel)
        self.stackView.addArrangedSubview(rankTypeLabel)
        
        self.layer.cornerRadius = 20
        self.backgroundColor = .white
    }
    
}
