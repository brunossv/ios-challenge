//
//  AppAuthentication.swift
//  ios-challange
//
//  Created by Bruno Soares on 23/01/25.
//
import UIKit
import LocalAuthentication

struct AppAuthentication {
    private let laContext = LAContext()
    
    func askAuthentication(_ completion: @escaping (String?) -> Void) {
        switch self.laContext.biometryType {
        case .faceID, .touchID, .opticID:
            self.settingUpAuthentication(policy: .deviceOwnerAuthenticationWithBiometrics, completion)
            break
        case .none:
            self.settingUpAuthentication(policy: .deviceOwnerAuthentication, completion)
            break
        default:
            DispatchQueue.main.async {
                completion("Authentication not available")
            }
        }
    }
    
    private func settingUpAuthentication(policy: LAPolicy,_ completion: @escaping (String?) -> Void) {
        var error: NSError?
        guard self.laContext.canEvaluatePolicy(policy, error: &error) else {
            DispatchQueue.main.async {
                completion(error?.localizedDescription ?? "Can't evaluate policy")
            }
            return
        }
        
        Task {
            do {
                try await self.laContext.evaluatePolicy(policy, localizedReason: "Unlock screen")
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
    }
}
