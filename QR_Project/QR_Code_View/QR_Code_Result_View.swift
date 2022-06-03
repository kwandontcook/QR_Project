//
//  QR_Code_Result_View.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 27/5/2022.
//

import SwiftUI

import CoreImage.CIFilterBuiltins
struct QR_Code_Result_View: View {
    @EnvironmentObject var obj : QR_Code_Setting
    @State var isActivityVC: Bool = false
    @State var isPresented: Bool = false
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    let baseURL = "https://qrcodescanapp.herokuapp.com/qr_code?file=files&id="
    var body: some View {
        VStack(spacing: 10){
            if(self.obj.url != nil){
                Image(uiImage: generateQRCode(url: baseURL+obj.url!.lastPathComponent)).resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                
                Button {
                    UIImageWriteToSavedPhotosAlbum(generateQRCode(url : baseURL+obj.url!.lastPathComponent), nil, nil, nil)
                } label: {
                    Text("Saved the image")
                }
                
                Button {
                    self.isActivityVC = true
                } label: {
                    Text("Share Image to others")
                }.sheet(isPresented: $isActivityVC) {
                    ActivityViewController(activityItems: [generateQRCode(url: baseURL+obj.url!.lastPathComponent), "QR Code Image"], applicationActivities: nil)
                }
                
                Button{
                    self.obj.url = nil
                    self.obj.translate_url()
                    self.isPresented = true
                }label: {
                    Text("Restart the application")
                }.fullScreenCover(isPresented: $isPresented) {
                    ContentView()
                }
            }
        }
    }
    
    func generateQRCode(url : String) -> UIImage {
        filter.message = Data(url.utf8)
        
        guard let outputImage = filter.outputImage, let CGimage = context.createCGImage(outputImage, from: outputImage.extent) else {
            print("Failed to fetch the QR Code")
            return UIImage()
        }
        
        return UIImage(cgImage: CGimage)
    }
    
    
    
}

struct QR_Code_Result_View_Previews: PreviewProvider {
    static var previews: some View {
        QR_Code_Result_View()
    }
}
