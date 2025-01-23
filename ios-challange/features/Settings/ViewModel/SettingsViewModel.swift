//
//  
//  SettingsViewModel.swift
//  ios-challange
//
//  Created by Bruno Soares on 21/01/25.
//
//

import Foundation

class SettingsViewModel {
    enum Settings: Int, CaseIterable {
        case faceID = 0
        
        var id: String {
            switch self {
            case .faceID:
                return "face_id_userdefault"
            }
        }
        
        var title: String {
            switch self {
            case .faceID:
                return "Face ID"
            }
        }
        
        var icon: String {
            switch self {
            case .faceID:
                return "faceid"
            }
        }
    }
    
    var values: [Settings: Bool] = {
        var values: [Settings: Bool] = [:]
        Settings.allCases.forEach { field in
            values[field] = UserDefaults.standard.bool(forKey: field.id)
        }
        return values
    }()
}
