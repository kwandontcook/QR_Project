//
//  QR_Code_View.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 17/5/2022.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QR_Code_View: View {
    // Properties to store qr code data
    @Binding var qr_code_data : Data
    @Binding var qr_code_type : ActiveSheet
    @StateObject var service = FireBase_service()
    
    var Uploading_View : some View {
        VStack(spacing: 15){
            ProgressView().progressViewStyle(.circular).scaleEffect(2)
            Text("Processing to upload files")
        }.padding()
            .onAppear(perform: {
                self.service.login_to_firebase(data: self.qr_code_data, type: self.qr_code_type)
            })
    }
    
    var body: some View {
        ZStack{
            if(self.service.isUploading){
                Uploading_View
            }else{
                SF_view_page(service_link: .constant(service.baseurl))
            }
        }
        .navigationBarHidden(self.service.isUploading ? false : true)
        .edgesIgnoringSafeArea(.all)
    }
}

struct QR_Code_View_Previews: PreviewProvider {
    static var previews: some View {
        QR_Code_View(qr_code_data : .constant(Data()), qr_code_type: .constant(.Video))
    }
}
