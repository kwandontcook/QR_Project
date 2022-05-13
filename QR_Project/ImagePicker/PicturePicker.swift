//
//  PicturePicker.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 9/5/2022.
//

import SwiftUI

struct PicturePicker : UIViewControllerRepresentable{
    @Binding var sourceType : UIImagePickerController.SourceType
    @Binding var file_data : Data?
    @Binding var file_url : URL?
    @Binding var isShowingData : Bool
    @Binding var mediaType : [String]
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        vc.delegate = context.coordinator
        vc.allowsEditing = true
        vc.sourceType = sourceType
        vc.mediaTypes = mediaType
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
            
            if let image_url = info[.editedImage] as? UIImage{
                do{
                    self.picPicker.file_data = image_url.pngData()
                    self.picPicker.isShowingData = true
                }catch{
                    print("Failed to fetch data")
                }
            }
            
            if let video_url = info[.mediaURL] as? URL{
                self.picPicker.file_url = video_url
                self.picPicker.isShowingData = true
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picPicker: self)
    }
}
