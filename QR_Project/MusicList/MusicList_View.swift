//
//  MusicList_View.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 13/5/2022.
//

import SwiftUI
import MediaPlayer

struct MusicList_View: View {
    @Binding var isShowingData : Bool
    @Binding var music_list : [MPMediaItem]?
    @Binding var music_url : URL?
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView{
            List{
                Section("Your music") {
                    ForEach(music_list ?? [MPMediaItem()], id: \.self) { music in
                        Button {
                            self.music_url = music.assetURL!
                            self.isShowingData = true
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            MusicList_View_Cell(song_title: .constant(music.title ?? "Song title"), song_singer: .constant(music.artist ?? "Artist Name"))
                        }.foregroundColor(Color.black)
                    }
                } .listStyle(.plain)
            }
            .navigationTitle("Music Library").navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }
    }
}


struct MusicList_View_Previews: PreviewProvider {
    static var previews: some View {
        MusicList_View(isShowingData: .constant(false), music_list: .constant([MPMediaItem()]), music_url: .constant(URL(string : "")!))
    }
}
