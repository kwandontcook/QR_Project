//
//  ActivityVC.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 24/5/2022.
//

import SwiftUI

struct ActivityViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
