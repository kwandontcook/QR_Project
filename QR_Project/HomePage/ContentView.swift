//
//  ContentView.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 4/5/2022.
//

import SwiftUI
import Firebase



class QR_Code_Setting: ObservableObject {
    @Published var url : URL?
    @Published var status : Bool?
    
    init(){
        
    }
    
    init(url : URL){
        self.url = url
    }
    
    func translate_url(){
        let path = url
        let fileNo = path?.lastPathComponent
        let parent = path?.deletingLastPathComponent()
        
        if(fileNo != nil && parent != nil){
            print("FileNo" + fileNo!.description)
            print("Parent " + parent!.description)
            status = true
        }else{
            status = false
        }
    }
}


struct ContentView: View {
    @EnvironmentObject var obj : QR_Code_Setting
    
    var body: some View {
        VStack{
            if(obj.status == true){
                if let uid = Auth.auth().currentUser?.uid {
                    if uid == "" {
                        Text("Failed to fetch user data \n please restart the app").multilineTextAlignment(.center)
                    }else if uid == "rHKLQVAd1ZYSWMLv1b8OMcCddQ62"{
                        Text("Failed to load the user id").multilineTextAlignment(.center)
                    }else{
                        User_Profile_VC()
                    }
                }else{
                    QR_Code_Result_View()
                }
            }else{
                ContentView_body()
            }
        }.animation(.spring(), value: obj.status)
    }
}

struct ContentView_body: View{
    @State var isShowpresented = false
    @State var isLoginpresented = false
    
    
    var body: some View{
        
        
        ZStack{
            NavigationView{
                VStack(spacing: 10){
                    // ImageView for the homePage
                    Image("Icon").resizable().aspectRatio(contentMode: .fit).frame(maxWidth :230, maxHeight: 230)
                    // Title for the homePage
                    Text("QR Code Application").font(.title)
                    // Button for navigation to the next view
                    
                    NavigationLink("", isActive: $isShowpresented){
                        QR_ProjectContent()
                    }
                    NavigationLink("", isActive: $isLoginpresented){
                        Login_VC()
                    }
                    
                    VStack(spacing: 15){
                        Button {
                            self.isShowpresented = true
                        } label: {
                            // Navigation Link to next page
                            Text("Start")
                        }.foregroundColor(.white)
                            .font(.system(size: 16, weight: .thin, design: .default))
                            .frame(width: 230, height: 40, alignment: .center)
                            .background(Color(.sRGB, red: 180/255, green: 56/255, blue: 56/255, opacity: 1))
                            .cornerRadius(5.0).shadow(color: .black, radius: 0.7)
                        
                        
                        Button{
                            self.isLoginpresented = true
                        } label: {
                            Text("Login")
                        }.foregroundColor(.white)
                            .font(.system(size: 16, weight: .thin, design: .default))
                            .frame(width: 230, height: 40, alignment: .center)
                            .background(Color(.sRGB, red: 180/255, green: 56/255, blue: 56/255, opacity: 1))
                            .cornerRadius(5.0).shadow(color: .black, radius: 0.7)
                    }
                    
                }.navigationBarHidden(true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
