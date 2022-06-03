//
//  User_Profile_VC.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 1/6/2022.
//

import SwiftUI

struct User_Profile_VC: View {
    @StateObject var user_profile = user_service()
    @State var isPresent = false
    
    let calendar_formatter : DateFormatter = {
        let d = DateFormatter()
        d.dateFormat = "yyyy-MM-dd"
        return d
    }()

    var heading: some View{
        VStack(alignment: .leading, spacing: 20){
            // HStack for navigation button
            HStack(spacing: 10){
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal").resizable().frame(width: 25, height: 20)
                }.tint(Color.black)
                
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
                    
                } label: {
                    Image(systemName:"person.fill").resizable()
                        .frame(width: 25, height: 25)
                }.clipShape(RoundedRectangle(cornerRadius: 15.0))
                    .tint(Color.black).background(Circle().stroke(Color.white, lineWidth: 2.0))
            }
            
            
            // VStack for Description
            VStack(alignment: .leading){
                Text("Welcome").font(.title2).multilineTextAlignment(.center)
                Text(user_profile.u!.user_first_name + " " + user_profile.u!.user_last_name ).font(.title).fontWeight(.heavy)
            }.animation(.easeIn, value: user_profile.u?.user_first_name)
                .animation(.easeIn, value: user_profile.u?.user_last_name)
            
        }.padding()
    }
    
    var history_record:some View{
        VStack(alignment: .leading){
            // Text for the history section
            Text("History").font(.title3).fontWeight(.bold)
            // Define the history item
            ForEach(0..<4){i in
                RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 80).overlay {
                    GeometryReader { geo in
                        VStack(alignment : .leading){
                            Text("Record \(i)").font(.body).fontWeight(.semibold)
                            Text("\(calendar_formatter.string(from: Date()))")
                        }.padding(.vertical).padding(.horizontal, 10)
                    }
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
                    .navigationBarHidden(true)
            }
        }
    }
}

struct User_Profile_VC_Previews: PreviewProvider {
    static var previews: some View {
        User_Profile_VC()
    }
}
