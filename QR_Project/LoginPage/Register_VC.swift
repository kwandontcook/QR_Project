//
//  Login_VC.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 31/5/2022.
//

import SwiftUI
import Firebase
import FirebaseStorage


struct Register_VC: View {
    
    @State var user_First_name = ""
    @State var user_Last_name   = ""
    @State var user_Email  = ""
    @State var user_Password   = ""
    @State var errorMessage = ""
    
    @State var register_statsus : Bool = false
    @State var register_statsus_error : Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(){
        
    }
    
    func register_user_account(User : user){
        Auth.auth().createUser(withEmail: User.user_email, password: User.user_password, completion: { (user, error) in
            if error != nil{
                self.errorMessage = "Failed to create a button"
                self.register_statsus_error = true
            }else{
                self.add_data_to_fb(User: User)
            }
        })
    }
    
    func add_data_to_fb(User : user){
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else{
            return;
        }
        
        ref.child("users").child(uid).setValue(["date": Date().description, "user_email" : User.user_email, "user_first_name" : User.user_first_name, "user_last_name" : User.user_last_name])
        
        ref.child("users").observeSingleEvent(of: .value) { snapshot in
            if(snapshot.hasChild(uid)){
                self.register_statsus = true
            }
        }
    }
    
    func reset_status(){
        self.register_statsus = false
        self.register_statsus_error = false
    }
    
    
    var body: some View {
        
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            VStack(spacing: 15){
                Text("Register").font(.title).fontWeight(.bold)
                
                Group{
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 50).overlay {
                        HStack{
                            TextField("First Name", text: $user_First_name)
                        }.padding(.leading)
                    }
                    
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 50).overlay {
                        HStack{
                            TextField("Last Name", text: $user_Last_name)
                        }.padding(.leading)
                    }
                    
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 50).overlay {
                        HStack{
                            TextField("Email", text: $user_Email)
                        }.padding(.leading)
                    }
                    
                    RoundedRectangle(cornerRadius: 15.0).fill(Color.init(uiColor: .systemGray6)).frame(height: 50).overlay {
                        HStack{
                            SecureField("Password", text: $user_Password)
                        }.padding(.leading)
                    }
                }
                
                
                Button{
                    if(self.user_Email == "" || self.user_Password == "" || self.user_Last_name == "" || self.user_First_name == ""){
                        self.errorMessage = "Please enter all the detail before you submit"
                        self.register_statsus_error = true
                    }else{
                        self.reset_status()
                        self.register_user_account(User: user(user_first_name: user_First_name, user_last_name: user_Last_name, user_email: user_Email, user_password: user_Password))
                    }
                }label: {
                    Text("Submit").fontWeight(.light)
                }.foregroundColor(.white)
                    .font(.system(size: 16, weight: .thin, design: .default))
                    .frame(width: 230, height: 40, alignment: .center)
                    .background(Color(.sRGB, red: 180/255, green: 56/255, blue: 56/255, opacity: 1))
                    .cornerRadius(15.0).shadow(color: .black, radius: 0.7)
                    .alert(isPresented: $register_statsus_error) {
                        Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
                    }.fullScreenCover(isPresented: $register_statsus) {
                        ContentView()   
                    }
                
                
            }.padding()
            
            
        }.navigationBarTitleDisplayMode(.inline).navigationTitle("")
    }
}

struct  Register_VC_Previews: PreviewProvider {
    static var previews: some View {
        Register_VC()
    }
}
