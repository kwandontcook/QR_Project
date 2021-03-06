//
//  QR_ProjectApp.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 4/5/2022.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct QR_ProjectApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    @StateObject var settings = QR_Code_Setting()
    
    var body: some Scene {
        WindowGroup {
            ContentView().onOpenURL { url in
                settings.url = url
                settings.translate_url()
            }.environmentObject(settings)
        }
    }
}


