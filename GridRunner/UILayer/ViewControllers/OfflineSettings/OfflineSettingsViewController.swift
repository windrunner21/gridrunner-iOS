//
//  OfflineSettingsViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 24.10.23.
//

import UIKit

class OfflineSettingsViewController: UIViewController {
    
    var mainViewController: MainViewController!
    private let alertAdapter: AlertAdapter = AlertAdapter()
    private var currentDifficulty: Difficulty = .unknown
    private var currentRole: PlayerRole = .unknown
    private var currentMap: MapType = .unknown
    
    // Programmable UI properties.
    let cancelView: CancelView = CancelView()
    let viewTitle: TitleLabel = TitleLabel()
    let viewSubtitle: SubtitleLabel = SubtitleLabel()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Dimensions.verticalSpacing20
        return stackView
    }()
    
    let selectDifficultyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select AI difficulty 🆚"
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    let selectRoleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select your role 👀"
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    let selectMapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select map type 🗺️"
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    let easyDifficultyView: RoomParameterView = RoomParameterView()
    let mediumDifficultyView: RoomParameterView = RoomParameterView()
    let hardDifficultyView: RoomParameterView = RoomParameterView()
    
    let runnerRoleView: RoomParameterView = RoomParameterView()
    let seekerRoleView: RoomParameterView = RoomParameterView()
    let randomRoleView: RoomParameterView = RoomParameterView()
    
    let basicMapView: RoomParameterView = RoomParameterView()
    let borderedMapView: RoomParameterView = RoomParameterView()
    let shapedMapView: RoomParameterView = RoomParameterView()
    
    let playOfflineButton: PrimaryButton = PrimaryButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupPlayOfflineButton()
        self.setupScrollView()
        self.setupRoomParameters()
                
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
        
        let runnerRoleTap = UITapGestureRecognizer(target: self, action: #selector(chooseRole))
        self.runnerRoleView.addGestureRecognizer(runnerRoleTap)
        let seekerRoleTap = UITapGestureRecognizer(target: self, action: #selector(chooseRole))
        self.seekerRoleView.addGestureRecognizer(seekerRoleTap)
        let randomRoleTap = UITapGestureRecognizer(target: self, action: #selector(chooseRole))
        self.randomRoleView.addGestureRecognizer(randomRoleTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
            
    @objc func onStartOfflineMode() {
        self.dismiss(animated: true) {
            let gameViewController: GameViewController = GameViewController()
            gameViewController.isOnline = false
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
        }
    }
    
    @objc func chooseRole(_ gestureRecognizer: UITapGestureRecognizer) {
        self.playOfflineButton.enable()
        
        switch gestureRecognizer.view {
        case self.runnerRoleView:
            self.currentRole = .runner
            
            self.runnerRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.runnerRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.runnerRoleView.imageColor = UIColor(named: "Red")
            
            self.seekerRoleView.removeAnyBorder()
            self.seekerRoleView.image = UIImage(systemName: "circle")
            self.seekerRoleView.imageColor = UIColor(named: "Black")
            
            self.randomRoleView.removeAnyBorder()
            self.randomRoleView.image = UIImage(systemName: "circle")
            self.randomRoleView.imageColor = UIColor(named: "Black")
            
        case self.seekerRoleView:
            self.currentRole = .seeker
            
            self.runnerRoleView.removeAnyBorder()
            self.runnerRoleView.image = UIImage(systemName: "circle")
            self.runnerRoleView.imageColor = UIColor(named: "Black")
            
            self.seekerRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.seekerRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.seekerRoleView.imageColor = UIColor(named: "Red")
            
            self.randomRoleView.removeAnyBorder()
            self.randomRoleView.image = UIImage(systemName: "circle")
            self.randomRoleView.imageColor = UIColor(named: "Black")
            
        case self.randomRoleView:
            self.currentRole = .random
            
            self.runnerRoleView.removeAnyBorder()
            self.runnerRoleView.image = UIImage(systemName: "circle")
            self.runnerRoleView.imageColor = UIColor(named: "Black")
            
            self.seekerRoleView.removeAnyBorder()
            self.seekerRoleView.image = UIImage(systemName: "circle")
            self.seekerRoleView.imageColor = UIColor(named: "Black")
            
            self.randomRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.randomRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.randomRoleView.imageColor = UIColor(named: "Red")
        default:
            self.playOfflineButton.disable()
            break
        }
    }
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Versus AI Settings ⚙️")
        self.viewSubtitle.setup(in: self.view, as: "configure settings for your offline game. select AI difficulty, your desired role and game map!")
        
        NSLayoutConstraint.activate([
            self.viewTitle.topAnchor.constraint(equalTo: self.cancelView.bottomAnchor, constant: Dimensions.verticalSpacing20),
            self.viewTitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewTitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            self.viewSubtitle.topAnchor.constraint(equalTo: self.viewTitle.bottomAnchor),
            self.viewSubtitle.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            self.viewSubtitle.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.viewSubtitle.bottomAnchor, constant: Dimensions.verticalSpacing20 * 1.5),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.playOfflineButton.topAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.scrollView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Dimensions.verticalSpacing20),
            self.stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        self.stackView.addArrangedSubview(self.selectDifficultyLabel)
        
        self.stackView.addArrangedSubview(self.easyDifficultyView)
        self.stackView.addArrangedSubview(self.mediumDifficultyView)
        self.stackView.addArrangedSubview(self.hardDifficultyView)
        
        self.stackView.addArrangedSubview(self.selectRoleLabel)
        
        self.stackView.addArrangedSubview(self.runnerRoleView)
        self.stackView.addArrangedSubview(self.seekerRoleView)
        self.stackView.addArrangedSubview(self.randomRoleView)
        
        self.stackView.addArrangedSubview(self.selectMapLabel)
        
        self.stackView.addArrangedSubview(self.basicMapView)
        self.stackView.addArrangedSubview(self.borderedMapView)
        self.stackView.addArrangedSubview(self.shapedMapView)
    }
    
    private func setupRoomParameters() {
        self._setupDifficultyParameters()
        self._setupRoleParameters()
        self._setupMapParameters()
    }
    
    private func setupPlayOfflineButton() {
        self.playOfflineButton.disable()
        self.playOfflineButton.addTarget(self, action: #selector(onStartOfflineMode), for: .touchUpInside)
        
        self.playOfflineButton.width = UIScreen.main.bounds.width - 40
        self.playOfflineButton.height = self.playOfflineButton.width / 8
        self.playOfflineButton.setup(in: self.view, withTitle: "Play")
        
        NSLayoutConstraint.activate([
            self.playOfflineButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.playOfflineButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.playOfflineButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func _setupDifficultyParameters() {
        self.easyDifficultyView.settingName = Difficulty.easy
        self.mediumDifficultyView.settingName = Difficulty.medium
        self.hardDifficultyView.settingName = Difficulty.hard
        
        self.easyDifficultyView.image = UIImage(systemName: "circle")
        self.easyDifficultyView.imageColor = UIColor(named: "Black")
        self.mediumDifficultyView.image = UIImage(systemName: "circle")
        self.mediumDifficultyView.imageColor = UIColor(named: "Black")
        self.hardDifficultyView.image = UIImage(systemName: "circle")
        self.hardDifficultyView.imageColor = UIColor(named: "Black")
    }
    
    private func _setupRoleParameters() {
        self.runnerRoleView.settingName = PlayerRole.runner
        self.seekerRoleView.settingName = PlayerRole.seeker
        self.randomRoleView.settingName = PlayerRole.random
        
        self.runnerRoleView.image = UIImage(systemName: "circle")
        self.runnerRoleView.imageColor = UIColor(named: "Black")
        self.seekerRoleView.image = UIImage(systemName: "circle")
        self.seekerRoleView.imageColor = UIColor(named: "Black")
        self.randomRoleView.image = UIImage(systemName: "circle")
        self.randomRoleView.imageColor = UIColor(named: "Black")
    }
    
    private func _setupMapParameters() {
        self.basicMapView.settingName = MapType.basic
        self.borderedMapView.settingName = MapType.bordered
        self.shapedMapView.settingName = MapType.shaped
        
        self.basicMapView.image = UIImage(systemName: "circle")
        self.basicMapView.imageColor = UIColor(named: "Black")
        self.borderedMapView.image = UIImage(systemName: "circle")
        self.borderedMapView.imageColor = UIColor(named: "Black")
        self.shapedMapView.image = UIImage(systemName: "circle")
        self.shapedMapView.imageColor = UIColor(named: "Black")
    }
}
