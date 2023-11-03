//
//  AblyAuthDelegate.swift
//  GridRunner
//
//  Created by Imran Hajiyev on 06.07.23.
//
import Ably

struct AblyAuthCallbackDelegate {
    
    private let ablyManager: AblyManager = AblyManager()
    
    func tokenRequest(_ tokenParams: ARTTokenParams?, callback: @escaping (ARTTokenDetails?, Error?) -> Void) {
        // Generate or fetch the necessary token request and pass it to the callback.
        self.ablyManager.retrieveToken { response, token in
            switch response {
            case .success:
                guard let token = token else {
                    NSLog("Token returned as nil in AblyAuthCallbackDelegate.")
                    return
                }
                
                let tokenDetails = ARTTokenDetails(token: token)
                callback(tokenDetails, nil)
            default:
                NSLog("Could not get token from AblyJWTService in AblyAuthCallbackDelegate.")
                callback(nil, AblyAuthenticationError.noToken)
            }
        }
    }
}
