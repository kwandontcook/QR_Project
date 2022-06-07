//
//  User_Backend.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 31/5/2022.
//
import SwiftUI
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

struct files : Identifiable{
    var id = UUID()
    var file_date = ""
    var file_type = ""
    var file_id = ""
    
    init(file_date: String, file_type: String, file_id :String){
        self.file_date = file_date
        self.file_type = file_type
        self.file_id = file_id
    }
}

class user_service : ObservableObject {
    @Published var u : user?
    @Published var backend : FireBase_service?
    @Published var u_files = [files]()
    
    init(){
        self.u = user()
        self.backend = FireBase_service()
        self.retrieve_user_detail()
        self.retrieve_user_uploaded_files()
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        } catch{
            print("failed to logout")
        }
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

            withAnimation(.spring()) {
                self.u = user(user_first_name: user_first_name, user_last_name: user_last_name, user_email: user_email)
            }
        }
    }
    
    func retrieve_user_uploaded_files(){
        let ref = Database.database().reference()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ref.child("users").child(uid).child("files").observe(.value) { snapshot in
            self.u_files.removeAll()
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                guard let dict = rest.value as? [String:Any] else{
                    return
                }
                
                let date = dict ["date"] as! String
                let data_type = dict ["data_type"] as! String
                
                withAnimation(.spring()) {
                    self.u_files.append(files(file_date: date, file_type: data_type, file_id: rest.key))
                }
            }
        }
    }
}
