//
//  Login_VC.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 1/6/2022.
//

import SwiftUI
import Firebase

struct Login_VC: View {
    @State var user_Email : String = ""
    @State var user_Password  : String = ""
    @State var isRegisterPresented : Bool = false
    @State var isLoginPresented : Bool = false
    @State var errorMessage : String = ""
    @State var isAlertPresented : Bool = false
    
    func login_to_firebase(){
        Auth.auth().signIn(withEmail: user_Email, password: user_Password, completion: { (auth, error) in
            if let _ = error {
                self.errorMessage = "Provided detail is not corrrect"
                self.isAlertPresented = true
            } else {
                if let _ = auth?.user {
                    self.isLoginPresented = true
                }
            }
        })
    }
    
    func reset_status(){
        self.errorMessage = ""
        self.isAlertPresented = false
        self.isLoginPresented = false
    }
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 15){
                Image("Icon").resizable().aspectRatio(contentMode: .fit).frame(width: 200, height: 200)
                
                Group{
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(maxWidth: UIScreen.main.bounds.width-50, maxHeight: 50).overlay {
                        HStack{
                            TextField("Email", text: $user_Email).autocapitalization(.none)
                        }.padding(.leading)
                    }
                    
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(maxWidth: UIScreen.main.bounds.width-50, maxHeight: 50).overlay {
                        HStack{
                            SecureField("Password", text: $user_Password).autocapitalization(.none)
                        }.padding(.leading)
                    }
                }
                
                Group{
                    NavigationLink("", isActive: $isRegisterPresented){
                        Register_VC()
                    }
                    
                    Button{
                        self.reset_status()
                        
                        if(self.user_Email == "" || self.user_Password == ""){
                            self.errorMessage = "You should provide all the information"
                            self.isAlertPresented = true
                        }else{
                            self.login_to_firebase()
                        }
                    }label: {
                        Text("Submit").fontWeight(.light)
                    }.foregroundColor(.white)
                        .font(.system(size: 16, weight: .thin, design: .default))
                        .frame(width: 230, height: 40, alignment: .center)
                        .background(.blue)
                        .cornerRadius(15.0).shadow(color: .black, radius: 0.7).alert(isPresented: $isAlertPresented) {
                            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
                        }.fullScreenCover(isPresented: $isLoginPresented) {
                            User_Profile_VC()
                        }
                    
                    Button{
                        self.isRegisterPresented = true
                    }label: {
                        Text("Register a new account")
                    }
                }
            }.padding()
        }
    }
}

struct Login_VC_Previews: PreviewProvider {
    static var previews: some View {
        Login_VC()
    }
}
