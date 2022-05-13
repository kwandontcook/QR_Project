//
//  PicturePicker_Image.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 10/5/2022.
//
import MediaPlayer
import Foundation
import UIKit

class PicturePicker_Image : ObservableObject{
    @Published var picture_file: PictureImage
    @Published var video_file: VideoPicker
    @Published var music_file: MusicPlayer
    
    init(){
        self.picture_file = PictureImage()
        self.video_file = VideoPicker()
        self.music_file = MusicPlayer()
    }
}

struct PictureImage : Hashable, Identifiable{
    var id = UUID()
    var file_data: Data?
    
    init(){
        self.file_data = Data()
    }
    
    init(file : Data){
        self.file_data = file
    }
}

struct VideoPicker : Hashable, Identifiable{
    var id = UUID()
    var file_url: URL?
    
    init(){
        self.file_url = URL(string: "")
    }
    
    init(file : URL){
        self.file_url = file
    }
}

struct MusicPlayer : Hashable, Identifiable{
    var id = UUID()
    var file_url: URL?
    var mediaItems : [MPMediaItem]?
    
    init(){
        guard let mediaItems = MPMediaQuery.songs().items else{
            return;
        }
        self.mediaItems = mediaItems ?? nil
        self.file_url = URL(string: "")
    }
}
