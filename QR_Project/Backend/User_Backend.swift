//
//  User_Backend.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 31/5/2022.
//

import Foundation
import Firebase
import FirebaseStorage

struct user : Identifiable{
    var id = UUID()
    var user_first_name = ""
    var user_last_name = ""
    var user_email = ""
    var user_password = ""
    
    init(){
        
    }
    
    init(user_first_name: String, user_last_name: String, user_email: String){
        self.user_first_name = user_first_name
        self.user_last_name = user_last_name
        self.user_email = user_email
    }
    
    init(user_first_name: String, user_last_name: String, user_email: String, user_password : String){
        self.user_email = user_email
        self.user_password = user_password
        self.user_last_name = user_last_name
        self.user_first_name = user_first_name
    }
}

class user_service : ObservableObject {
    @Published var u : user?
    
    init(){
        self.u = user()
        self.retrieve_user_detail()
    }
    
    func retrieve_user_detail(){
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dict = snapshot.value as? [String:Any] else{
                return;
            }
            
            let user_first_name = dict["user_first_name"] as! String
            let user_last_name = dict["user_last_name"] as! String
            let user_email = dict["user_email"] as! String

            self.u = user(user_first_name: user_first_name, user_last_name: user_last_name, user_email: user_email)
            print(" i am done ")
        }
    }
    
}
