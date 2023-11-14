//
//  GreetingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class GreetingView: UIView {
    
    var playerType: PlayerType!
    
    private let overlayView = UIView()
    private let contentView = UIView()
    
    private let viewTitle: TitleLabel = TitleLabel()
    private let viewSubtitle: SubtitleLabel = SubtitleLabel()
    private let button: PrimaryButton = PrimaryButton()
            
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
        // Add overlay to disable user interaction and clearly seperate design wise.
        self.overlayView.backgroundColor = UIColor(named: "PureBlack")?.withAlphaComponent(0.5)
        self.overlayView.frame = UIScreen.main.bounds
        self.overlayView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(overlayView)
        
        self._setupContentView()
        self._setupViewLabels()
        self._setupButton()
    }
    
    @objc private func onButtonTouchDown() {
        self.button.onTouchDown()
    }

    @objc private func onButtonTouchUpOutside() {
        self.button.onTouchUpOutside()
    }

    @objc private func onButton() {
        self.removeFromSuperview()
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    private func _setupContentView() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = UIColor(named: "Background")
        self.contentView.addElevation()
        self.contentView.layer.cornerRadius = 10
        
        self.overlayView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            self.contentView.centerXAnchor.constraint(equalTo: self.overlayView.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.overlayView.centerYAnchor),
            self.contentView.heightAnchor.constraint(equalToConstant: 200),
            self.contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
    }
    
    private func _setupViewLabels() {
        self.viewTitle.setup(in: self.contentView)
        self.viewSubtitle.setup(in: self.contentView)
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func _setupButton() {
        self.button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(onButtonTouchUpOutside), for: .touchUpOutside)
        self.button.addTarget(self, action: #selector(onButtonTouchDown), for: .touchDown)
        
        self.button.width = UIScreen.main.bounds.width - 80
        self.button.height = self.button.width / 8
        self.button.setup(in: self, withTitle: "Let's Go!")
                
        NSLayoutConstraint.activate([
            self.button.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.button.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.button.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func setupLabels() {
        if playerType == .runner {
            self.viewTitle.text = "You are Runner"
            self.viewSubtitle.text = "your goal is to escape the maze! map usually has several exit points, so head up to them. beware as you are being tailed by the seeker. escape the maze without being caught!"
        } else if playerType == .seeker {
            self.viewTitle.text = "You are Seeker"
            self.viewSubtitle.text = "your goal is to find a runner! runner would navigate to one of the exits to escape, so be prepared to chase them around through the maze. find the runner before they escape!"
        }
       
    }
}
