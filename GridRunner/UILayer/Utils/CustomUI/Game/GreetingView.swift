//
//  GreetingView.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 11.09.23.
//

import UIKit

class GreetingView: UIView {
    var playerType: PlayerType!
    
    let viewTitle: TitleLabel = TitleLabel()
    let viewSubtitle: SubtitleLabel = SubtitleLabel()
    let button: PrimaryButton = PrimaryButton()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size.width = UIScreen.main.bounds.width / 2
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor(named: "Background")
        
        self.setupViewLabels()
        self.setupImage()
        self.setupButton()
    }
    
    @objc func onButtonTouchDown() {
        self.button.onTouchDown()
    }

    @objc func onButtonTouchUpOutside() {
        self.button.onTouchUpOutside()
    }

    @objc func onButton() {
        self.removeFromSuperview()
    }
    
    func remove() {
        self.removeFromSuperview()
    }
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self)
        self.viewSubtitle.setup(in: self)
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupButton() {
        self.button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
        self.button.addTarget(self, action: #selector(onButtonTouchUpOutside), for: .touchUpOutside)
        self.button.addTarget(self, action: #selector(onButtonTouchDown), for: .touchDown)
        
        self.button.width = UIScreen.main.bounds.width - 40
        self.button.height = self.button.width / 8
        self.button.setup(in: self, withTitle: "Let's Go!")
                
        NSLayoutConstraint.activate([
            self.button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.button.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupImage() {
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupLabels() {
        if playerType == .runner {
            self.viewTitle.text = "You are Runner"
            self.viewSubtitle.text = "your goal is to escape the maze! map usually has several exit points, so head up to them. beware as you are being tailed by the seeker. escape the maze without being caught!"
            self.imageView.image = UIImage(named: "RedSneakerIcon")
        } else if playerType == .seeker {
            self.viewTitle.text = "You are Seeker"
            self.viewSubtitle.text = "your goal is to find a runner! runner would navigate to one of the exits to escape, so be prepared to chase them around through the maze. find the runner before they escape!"
            self.imageView.image = UIImage(named: "BlackSneakerIcon")
        }
       
    }
}
