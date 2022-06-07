//
//  Backend.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 18/5/2022.
//

import Foundation
import Firebase
import FirebaseStorage

class FireBase_service : ObservableObject{
    @Published var isUploading = false
    @Published var baseurl = ""
    
    init(){
        
    }
    
    func login_to_firebase(user_email : String, password : String, data: Data, type : ActiveSheet){
        Auth.auth().signIn(withEmail: user_email, password: password, completion: { (auth, error) in
            if let e = error {
                print(e)
            }else{
                self.data_to_real_time_db(data: data, type: type)
                try! Auth.auth().signOut()
            }
        })
        
    }
    
    
    func data_to_real_time_db(data: Data, type : ActiveSheet){
        let ref = Database.database().reference()
        
        guard let uid = Auth.auth().currentUser?.uid as? String else {
            print("failed to grab user id")
            return;
        }
        
        var upload_ref : DatabaseReference?
        
        if(uid == "rHKLQVAd1ZYSWMLv1b8OMcCddQ62"){
            upload_ref = ref.child("files").childByAutoId()
        }else{
            upload_ref = ref.child("users").child(uid).child("files").childByAutoId()
        }
        
        upload_ref!.setValue(["date": Date().description, "data_type" : type.id])
        
        if let key = upload_ref!.key{
            self.baseurl = "https://qrcodescanapp.herokuapp.com/qr_code?file=files&id=\(key)"
            self.data_upload(data: data, key: key , type : type)
        }else{
            print("Failed to grab the key")
        }
    }
    
    func translate_name(type : ActiveSheet) -> String{
        if type == .Video{
            return "film.mov"
        }else if type == .Picture{
            return "picture.png"
        }else{
            return "audio.m4a"
        }
    }
    
    func data_upload(data: Data, key: String, type : ActiveSheet){
        let storage_ref = Storage.storage().reference()
        let upload_ref = storage_ref.child("files").child(key).child(translate_name(type: type))
        
        guard let user_id = Auth.auth().currentUser?.uid as? String else {
            print("failed to grab user id")
            return;
        }
        
        guard let d = data as? Data else{
            print("error to get data")
            return
        }
        
        upload_ref.putData(d, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                self.isUploading = true
                print("failed to get meta data")
                return
            }
            
            print("data uploaded")
            self.isUploading = true
        }
    }
}
