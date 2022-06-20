//
//  QR_Code_View.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 17/5/2022.
//

import Firebase
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QR_Code_View: View {
    // Properties to store qr code data
    @Binding var qr_code_data : Data
    @Binding var qr_code_type : ActiveSheet
    @StateObject var service = FireBase_service()
    @Environment (\.presentationMode) var presentationMode
    
    var Uploading_View : some View {
        VStack(spacing: 15){
            ProgressView().progressViewStyle(.circular).scaleEffect(2)
            Text("Processing to upload files")
        }.padding()
            .onAppear(perform: {
                guard let id = Auth.auth().currentUser?.uid else{
                    self.service.login_to_firebase(user_email: "kwandontcook@gmail.com", password: "s02048123",data: self.qr_code_data, type: self.qr_code_type)
                    return
                }
                self.service.data_to_real_time_db(data: self.qr_code_data, type: self.qr_code_type)
            })
    }
    
    var navigationView : some View{
        HStack{
            Button{
                presentationMode.wrappedValue.dismiss()
            }label: {
                Image(systemName: "arrow.backward")
            }
        }.padding()
        
    }
    
    var body: some View {
        
        ZStack(alignment: .top){
            if(self.service.isUploading == false){
                navigationView.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                VStack{
                    Uploading_View.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                }
            }else{
                SF_view_page(service_link: .constant(service.baseurl)).edgesIgnoringSafeArea(.all)
            }
        }.navigationBarHidden(true)
    }
}

struct QR_Code_View_Previews: PreviewProvider {
    static var previews: some View {
        QR_Code_View(qr_code_data : .constant(Data()), qr_code_type: .constant(.Video))
    }
}
