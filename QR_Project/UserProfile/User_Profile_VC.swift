//
//  User_Profile_VC.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 1/6/2022.
//

import SwiftUI

struct User_Profile_VC: View {
    @EnvironmentObject var obj : QR_Code_Setting
    @StateObject var user_profile = user_service()
    @State var isPresent = false
    @State var isLogOut = false
    
    let calendar_formatter : DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()
    
    var heading: some View{
        VStack(alignment: .leading, spacing: 20){
            // HStack for navigation button
            HStack(spacing: 10){
                
                
                Image(systemName:"person.fill").resizable()
                    .frame(width: 25, height: 25)
                    .tint(Color.black).background(Circle().stroke(Color.white, lineWidth: 2.0))
                
                Spacer()
                
                
                NavigationLink(isActive: $isPresent) {
                    QR_ProjectContent()
                } label: {
                    Button{
                        self.isPresent = true
                    }label: {
                        Image(systemName: "camera.fill").resizable().frame(width: 25, height: 20)
                    }.foregroundColor(Color.black)
                }
                
                
                Button {
                    obj.url = nil
                    obj.translate_url()
                    user_profile.logout()
                    isLogOut = true
                } label: {
                    Image(systemName:"arrow.right.circle").resizable()
                        .frame(width: 25, height: 25)
                }.clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .tint(Color.black).background(Circle().stroke(Color.white, lineWidth: 2.0))
                    .fullScreenCover(isPresented: $isLogOut) {
                        ContentView()
                    }
            }
            
            
            // VStack for Description
            VStack(alignment: .leading){
                Text("Welcome").font(.title2).multilineTextAlignment(.center)
                Text(user_profile.u!.user_first_name + " " + user_profile.u!.user_last_name ).font(.title).fontWeight(.heavy)
            }
        }.padding()
    }
    
    var history_record:some View{
        VStack(alignment: .leading){
            // Text for the history section
            Text("History").font(.title3).fontWeight(.bold)
            // Define the history item
            ForEach(user_profile.u_files){i in
                NavigationLink {
                    QR_Code_Result_View_User(obj: QR_Code_Setting(url: URL(string: "qrcodeapp://generate_qr_code/\(i.file_id)")!))
                } label: {
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 80).overlay {
                        GeometryReader { geo in
                            VStack(alignment : .leading){
                                Text("Records").font(.body).fontWeight(.semibold)
                                Text(i.file_date)
                            }.padding(.vertical).padding(.horizontal, 10)
                        }
                    }.foregroundColor(.black)
                }
            }
        }.padding()
    }
    
    var body: some View {
        ZStack(alignment: .top){
            NavigationView{
                ScrollView(.vertical){
                    VStack(alignment: .leading){
                        heading
                        history_record
                    }
                }.padding(.top, 40).edgesIgnoringSafeArea(.all)
                    .navigationBarHidden(true).onAppear {
                        user_profile.retrieve_user_uploaded_files()
                        user_profile.retrieve_user_detail()
                    }
            }
        }
    }
}

struct User_Profile_VC_Previews: PreviewProvider {
    static var previews: some View {
        User_Profile_VC()
    }
}
