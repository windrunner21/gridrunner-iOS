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
    
    let difficultyViews: [RoomParameterView] = [
        RoomParameterView(setting: Difficulty.easy),
        RoomParameterView(setting: Difficulty.medium),
        RoomParameterView(setting: Difficulty.hard)
    ]
        
    let roleViews: [RoomParameterView] = [
        RoomParameterView(setting: PlayerRole.runner),
        RoomParameterView(setting: PlayerRole.seeker),
        RoomParameterView(setting: PlayerRole.random)
    ]
    
    let mapViews: [RoomParameterView] = [
        RoomParameterView(setting: MapType.basic),
        RoomParameterView(setting: MapType.bordered),
        RoomParameterView(setting: MapType.shaped)
    ]
    
    let playOfflineButton: PrimaryButton = PrimaryButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupPlayOfflineButton()
        self.setupScrollView()
        self.setupOfflineSettingParameters()
                
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
            
    @objc func onStartOfflineMode() {
        let manager: GameManager = GameManager(offline: true, difficulty: currentDifficulty)
        let offlineConfiguration = OfflineGameConfig(role: currentRole, map: currentMap)
        GameConfig.shared.update(with: offlineConfiguration)
        
        self.dismiss(animated: true) {
            let gameViewController: GameViewController = GameViewController(with: manager)
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.transitionViewController.transition(to: gameViewController, with: [.transitionCurlUp])
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
        
        for difficultyView in difficultyViews {
            self.stackView.addArrangedSubview(difficultyView)
        }
        
        self.stackView.addArrangedSubview(self.selectRoleLabel)
        
        for roleView in roleViews {
            self.stackView.addArrangedSubview(roleView)
        }
        
        self.stackView.addArrangedSubview(self.selectMapLabel)
        
        for mapView in mapViews {
            self.stackView.addArrangedSubview(mapView)
        }
    }
    
    private func setupOfflineSettingParameters() {
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
        for difficultyView in difficultyViews {
            difficultyView.image = UIImage(systemName: "circle")
            difficultyView.imageColor = UIColor(named: "Black")
            guard let parameter = difficultyView.setting else { return }
            difficultyView.tapAction = { [weak self] in
                if var setting = self?.currentDifficulty as? Settable {
                    self?._chooseSetting(setting: &setting, for: parameter, for: self?.playOfflineButton, views: self?.difficultyViews)
                    self?.currentDifficulty = setting as! Difficulty
                    self?.playOfflineButton.shouldBeEnabled(if: self?._shouldEnablePrimaryButton() ?? false)
                }
            }
        }
    }
    
    private func _setupRoleParameters() {
        for roleView in roleViews {
            roleView.image = UIImage(systemName: "circle")
            roleView.imageColor = UIColor(named: "Black")
            guard let parameter = roleView.setting else { return }
            roleView.tapAction = { [weak self] in
                if var setting = self?.currentRole as? Settable {
                    self?._chooseSetting(setting: &setting, for: parameter, for: self?.playOfflineButton, views: self?.roleViews)
                    self?.currentRole = setting as! PlayerRole
                    self?.playOfflineButton.shouldBeEnabled(if: self?._shouldEnablePrimaryButton() ?? false)
                }
            }
        }
    }
    
    private func _setupMapParameters() {
        for mapView in mapViews {
            mapView.image = UIImage(systemName: "circle")
            mapView.imageColor = UIColor(named: "Black")
            guard let parameter = mapView.setting else { return }
            mapView.tapAction = { [weak self] in
                if var setting = self?.currentMap as? Settable {
                    self?._chooseSetting(setting: &setting, for: parameter, for: self?.playOfflineButton, views: self?.mapViews)
                    self?.currentMap = setting as! MapType
                    self?.playOfflineButton.shouldBeEnabled(if: self?._shouldEnablePrimaryButton() ?? false)
                }
            }
        }
    }
    
    private func _chooseSetting(setting: inout Settable, for parameter: Settable, for button: PrimaryButton?, views: [RoomParameterView]?) {

        guard let views = views else { return }
        
        for view in views {
            if view.setting?.rawValue == parameter.rawValue {
                setting = parameter
                view.addBorder(color: UIColor(named: "Red"), width: 2)
                view.image = UIImage(systemName: "checkmark.circle.fill")
                view.imageColor = UIColor(named: "Red")
            } else {
                view.removeAnyBorder()
                view.image = UIImage(systemName: "circle")
                view.imageColor = UIColor(named: "Black")
            }
        }
    }
    
    private func _shouldEnablePrimaryButton() ->  Bool {
        self.currentDifficulty != .unknown && self.currentRole != .unknown && self.currentMap != .unknown
    }
}
