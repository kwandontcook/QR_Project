//
//  MusicList_View_Cell.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 13/5/2022.
//

import SwiftUI

struct MusicList_View_Cell: View {
    @Binding var song_title : String
    @Binding var song_singer : String
    
    var body: some View {
        VStack{
            Text(song_title).font(.title2).frame(maxWidth: 300, alignment: .leading)
            Text(song_singer).font(.system(size: 14.0, weight: .regular, design: .default)).foregroundColor(.secondary).frame(maxWidth: 300, alignment: .leading)
        }
    }
}

struct MusicList_View_Cell_Previews: PreviewProvider {
    static var previews: some View {
        MusicList_View_Cell(song_title: .constant("123"), song_singer: .constant("122")).previewLayout(.fixed(width: 300, height: 100))
    }
}
