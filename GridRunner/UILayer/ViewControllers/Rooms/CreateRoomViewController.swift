//
//  FriendlyViewController.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 17.07.23.
//

import UIKit

class CreateRoomViewController: UIViewController {
    
    var mainViewController: MainViewController!
    private let alertAdapter: AlertAdapter = AlertAdapter()
    private var currentRole: PlayerRole = .unknown
    
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
    
    let selectRoleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select your role"
        label.font = UIFont(name: "Kanit-Semibold", size: Dimensions.subHeadingFont)
        label.textColor = UIColor(named: "Black")
        return label
    }()
    
    let roleViews: [RoomParameterView] = [
        RoomParameterView(setting: PlayerRole.runner),
        RoomParameterView(setting: PlayerRole.seeker),
        RoomParameterView(setting: PlayerRole.random)
    ]
    
    let createRoomButton: PrimaryButton = PrimaryButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "Background")

        self.cancelView.setup(in: self.view)
        self.setupViewLabels()
        self.setupCreateRoomButtonButton()
        self.setupScrollView()
        
        self.setupRoomParameters()
        
        // Close current view, dismiss with animation, on cancel view tap.
        let cancelViewTap = UITapGestureRecognizer(target: self, action: #selector(closeView))
        self.cancelView.addGestureRecognizer(cancelViewTap)
    }
    
    @objc func closeView() {
        self.mainViewController.dismiss(animated: true)
    }
        
    @objc func onCreateRoomTouchDown() {
        self.createRoomButton.onTouchDown()
    }
    
    @objc func onCreateRoomTouchUpOutside() {
        self.createRoomButton.onTouchUpOutside()
    }
    
    @objc func onCreateRoom() {
        self.sendCreateRoomRequest()
    }
        
    private func sendCreateRoomRequest() {
        self.createRoomButton.disable()
        AblyJWTService().getJWT() { response, token in
            switch response {
            case .success:
                guard let token = token else {
                    DispatchQueue.main.async {
                        let alert = self.alertAdapter.createNetworkErrorAlert()
                        self.present(alert, animated: true)
                    }
                    return
                }
            
                AblyService.shared.update(with: token) { response, clientId in
                    switch response {
                    case .success:
                        guard let clientId = clientId else {
                            DispatchQueue.main.async {
                                let alert = self.alertAdapter.createNetworkErrorAlert()
                                self.present(alert, animated: true)
                            }
                            return
                        }
                        
                        switch self.currentRole {
                        case .runner:
                            GameSessionDetails.shared.setRunner(to: clientId)
                        case .seeker:
                            GameSessionDetails.shared.setSeeker(to: clientId)
                        case .random:
                            let randomInt = Int.random(in: 0...100)
                            if randomInt > 50 {
                                GameSessionDetails.shared.setRunner(to: clientId)
                                self.currentRole = .runner
                            } else {
                                GameSessionDetails.shared.setSeeker(to: clientId)
                                self.currentRole = .seeker
                            }
                        default:
                            DispatchQueue.main.async {
                                let alert = self.alertAdapter.createServiceRequestErrorAlert()
                                self.present(alert, animated: true)
                                self.createRoomButton.enable()
                            }
                            return
                        }
                    
                        GameService().createRoom(as: self.currentRole.rawValue, withId: clientId) { response in
                            switch response {
                            case .success:
                                guard let roomCode = Friendly.shared.getRoomCode() else {
                                    DispatchQueue.main.async {
                                        let alert = self.alertAdapter.createDecoderErrorAlert()
                                        self.present(alert, animated: true)
                                    }
                                    return
                                }
                      
                                GameSessionDetails.shared.setRoomCode(to: roomCode)
                                DispatchQueue.main.async {
                                    self.createRoomButton.enable()
                                    self.mainViewController.dismiss(animated: true) {
                                        NotificationCenter.default.post(name: NSNotification.Name("Success::Matchmaking::Custom"), object: nil)
                                    }
                                }
                                
                            case .networkError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createNetworkErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            case .requestError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            case .decoderError:
                                DispatchQueue.main.async {
                                    let alert = self.alertAdapter.createDecoderErrorAlert()
                                    self.present(alert, animated: true)
                                }
                            }
                        }
                    default:
                        DispatchQueue.main.async {
                            let alert = self.alertAdapter.createNetworkErrorAlert()
                            self.present(alert, animated: true)
                        }
                    }
                }
            case .requestError:
                DispatchQueue.main.async {
                    let alert = self.alertAdapter.createServiceRequestErrorAlert()
                    self.present(alert, animated: true)
                }
            default:
                DispatchQueue.main.async {
                    let alert = self.alertAdapter.createNetworkErrorAlert()
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    private func setupViewLabels() {
        self.viewTitle.setup(in: self.view, as: "Create custom room 🚪")
        self.viewSubtitle.setup(in: self.view, as: "make your own customizable game for yourself and your friends. more customization options are coming 🔜")
        
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
            self.scrollView.bottomAnchor.constraint(equalTo: self.createRoomButton.topAnchor, constant: -Dimensions.verticalSpacing20)
        ])
        
        self.scrollView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: Dimensions.verticalSpacing20),
            self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -Dimensions.verticalSpacing20),
            self.stackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40)
        ])
        
        self.stackView.addArrangedSubview(self.selectRoleLabel)
        
        for roleView in roleViews {
            self.stackView.addArrangedSubview(roleView)
        }
    }
    
    private func _setupRoleParameters() {
        for roleView in roleViews {
            roleView.image = UIImage(systemName: "circle")
            roleView.imageColor = UIColor(named: "Black")
            guard let parameter = roleView.setting else { return }
            roleView.tapAction = { [weak self] in
                if var setting = self?.currentRole as? Settable {
                    self?._chooseSetting(setting: &setting, for: parameter, for: self?.createRoomButton, views: self?.roleViews)
                    self?.currentRole = setting as! PlayerRole
                    self?.createRoomButton.shouldBeEnabled(if: self?._shouldEnablePrimaryButton() ?? false)
                }
            }
        }
    }
    
    private func setupCreateRoomButtonButton() {
        self.createRoomButton.disable()
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoom), for: .touchUpInside)
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoomTouchUpOutside), for: .touchUpOutside)
        self.createRoomButton.addTarget(self, action: #selector(onCreateRoomTouchDown), for: .touchDown)
        
        self.createRoomButton.width = UIScreen.main.bounds.width - 40
        self.createRoomButton.height = self.createRoomButton.width / 8
        self.createRoomButton.setup(in: self.view, withTitle: "Create room")
        
        NSLayoutConstraint.activate([
            self.createRoomButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.createRoomButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.createRoomButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func setupRoomParameters() {
        self._setupRoleParameters()
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
        self.currentRole != .unknown
    }
}
