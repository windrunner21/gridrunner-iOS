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
    
    let runnerRoleView: RoomParameterView = RoomParameterView()
    let seekerRoleView: RoomParameterView = RoomParameterView()
    let randomRoleView: RoomParameterView = RoomParameterView()
    
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
        
    @objc func onCreateRoomTouchDown() {
        self.createRoomButton.onTouchDown()
    }
    
    @objc func onCreateRoomTouchUpOutside() {
        self.createRoomButton.onTouchUpOutside()
    }
    
    @objc func onCreateRoom() {
        self.sendCreateRoomRequest()
    }
    
    @objc func chooseRole(_ gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.view {
        case self.runnerRoleView:
            self.currentRole = .runner
            
            self.runnerRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.runnerRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.runnerRoleView.imageColor = UIColor(named: "Red")
            
            self.seekerRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.seekerRoleView.image = UIImage(systemName: "circle")
            self.seekerRoleView.imageColor = UIColor(named: "Black")
            
            self.randomRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.randomRoleView.image = UIImage(systemName: "circle")
            self.randomRoleView.imageColor = UIColor(named: "Black")
            
        case self.seekerRoleView:
            self.currentRole = .seeker
            
            self.runnerRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.runnerRoleView.image = UIImage(systemName: "circle")
            self.runnerRoleView.imageColor = UIColor(named: "Black")
            
            self.seekerRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.seekerRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.seekerRoleView.imageColor = UIColor(named: "Red")
            
            self.randomRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.randomRoleView.image = UIImage(systemName: "circle")
            self.randomRoleView.imageColor = UIColor(named: "Black")
            
        case self.randomRoleView:
            self.currentRole = .random
            
            self.runnerRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.runnerRoleView.image = UIImage(systemName: "circle")
            self.runnerRoleView.imageColor = UIColor(named: "Black")
            
            self.seekerRoleView.addBorder(color: UIColor(named: "Gray"), width: 1)
            self.seekerRoleView.image = UIImage(systemName: "circle")
            self.seekerRoleView.imageColor = UIColor(named: "Black")
            
            self.randomRoleView.addBorder(color: UIColor(named: "Red"), width: 2)
            self.randomRoleView.image = UIImage(systemName: "checkmark.circle.fill")
            self.randomRoleView.imageColor = UIColor(named: "Red")
        default:
            break
        }
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
        
        self.stackView.addArrangedSubview(self.runnerRoleView)
        self.stackView.addArrangedSubview(self.seekerRoleView)
        self.stackView.addArrangedSubview(self.randomRoleView)
    }
    
    private func setupRoomParameters() {
        self.runnerRoleView.role = .runner
        self.seekerRoleView.role = .seeker
        self.randomRoleView.role = .random
        
        self.runnerRoleView.image = UIImage(systemName: "circle")
        self.runnerRoleView.imageColor = UIColor(named: "Black")
        self.seekerRoleView.image = UIImage(systemName: "circle")
        self.seekerRoleView.imageColor = UIColor(named: "Black")
        self.randomRoleView.image = UIImage(systemName: "circle")
        self.randomRoleView.imageColor = UIColor(named: "Black")
    }
    
    private func setupCreateRoomButtonButton() {
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
}
