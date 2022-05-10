//
//  PicturePicker.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 9/5/2022.
//

import SwiftUI

struct PicturePicker : UIViewControllerRepresentable{
    @Binding var sourceType : UIImagePickerController.SourceType
    @Binding var image: UIImage
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = context.coordinator
        vc.sourceType = sourceType
        vc.mediaTypes = ["public.image", "public.movie"]
        return vc 
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let picPicker : PicturePicker
        
        init (picPicker : PicturePicker){
            self.picPicker = picPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.imageURL] as? UIImage{
                picPicker.image = image
            }
            
            picPicker.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picPicker: self)
    }
    
}
