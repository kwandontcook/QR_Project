//
//  QR_ProjectContent.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 6/5/2022.
//
import SwiftUI
import AVKit

enum ActiveSheetOption : Identifiable{
    case open_camera, choose_picture_library, choose_video_library, choose_music_library
    
    var id: String {
        switch self {
        case .open_camera:
            return "Open Camera"
        case .choose_picture_library:
            return "Choose picture from library"
        case .choose_video_library:
            return "Choose video from library"
        case .choose_music_library:
            return "Choose music from library"
        }
    }
}
enum ActiveSheet: Identifiable {
    case Video, Audio, Picture
    
    var id: String {
        switch self {
        case .Video:
            return "Video"
        case .Audio:
            return "Audio"
        case .Picture:
            return "Picture"
        }
    }
}


struct QR_ProjectContent: View {
    // @State variable
    @State var isBtnStatus = false
    @State var isChoosingService = false
    @State var isShowingAlert = false
    @State var isShowingStatus = false
    @State var isShowingData = false
    // @State variable to remember the activeSheet option
    @State private var activeSheet: ActiveSheet? = .Video
    @State private var activeSheetOption : ActiveSheetOption? = .open_camera
    // An object to init and call ImagePickerView
    @StateObject var image_set = PicturePicker_Image()
    // Array for the icon and iconNames
    var arr = ["Video","Picture","Audio"]
    
    var video_view : some View{
        VStack{
            Button("Open Camera") {
                self.isBtnStatus = true
                self.activeSheetOption = .open_camera
            }
            
            Button("Choose video from library") {
                self.isBtnStatus = true
                self.activeSheetOption = .choose_video_library
            }
        }
    }
    
    var picture_view : some View{
        VStack{
            Button("Open Camera") {
                self.isBtnStatus = true
                self.activeSheetOption = .open_camera
            }
            
            Button("Choose picture from library") {
                self.isBtnStatus = true
                self.activeSheetOption = .choose_picture_library
            }
        }
    }
    
    var audio_view : some View{
        VStack{
            Button("Choose music from library") {
                self.isBtnStatus = true
                self.activeSheetOption = .choose_music_library
            }
        }
    }
    
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing:30){
                // Title for the Page
                Text("Choose a service").font(.title)
                // Set condition to print different data
                if(self.isShowingData){
                    if(self.activeSheet == .Picture){
                        Image(uiImage: UIImage(data: image_set.picture_file.file_data!)!)
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                    }else if(self.activeSheet == .Video){
                        VideoPlayer(player: AVPlayer(url: image_set.video_file.file_url!)).frame(width: 250, height: 150)
                    }else if (self.activeSheet == .Audio){
                        VideoPlayer(player: AVPlayer(url: image_set.music_file.file_url!)).frame(width: 250, height: 150)
                    }
                }
                
                // Set up btn for the Page
                VStack{
                    ForEach(arr, id: \.self){data in
                        Button {
                            if(data == "Video"){
                                self.activeSheet = .Video
                            }else if(data == "Audio"){
                                self.activeSheet = .Audio
                            }else{
                                self.activeSheet = .Picture
                            }
                            self.isChoosingService = true
                            self.isShowingData = false
                        } label: {
                            QR_ProjectContentRow(column_image: .constant(data), column_text: .constant(data)).padding()
                        }.tint(Color.black)
                            .confirmationDialog("Select one of the option", isPresented: $isChoosingService) {
                                if(self.activeSheet == .Video){
                                    video_view
                                }else if(self.activeSheet == .Picture){
                                    picture_view
                                }else{
                                    audio_view
                                }
                            }.fullScreenCover(isPresented: $isBtnStatus) {
                                if(activeSheetOption == .choose_picture_library){
                                    PicturePicker(sourceType: .constant(.photoLibrary), file_data: $image_set.picture_file.file_data, file_url: .constant(URL(string: "")), isShowingData: $isShowingData, mediaType: .constant(["public.image"])).edgesIgnoringSafeArea(.all)
                                }else if(activeSheetOption == .open_camera && activeSheet == .Picture){
                                    PicturePicker(sourceType: .constant(.camera), file_data: $image_set.picture_file.file_data, file_url: .constant(URL(string: "")), isShowingData: $isShowingData, mediaType: .constant(["public.image"])).edgesIgnoringSafeArea(.all)
                                }else if(activeSheetOption == .open_camera && activeSheet == .Video){
                                    PicturePicker(sourceType: .constant(.camera), file_data: .constant(Data()), file_url: $image_set.video_file.file_url, isShowingData: $isShowingData, mediaType: .constant(["public.movie"])).edgesIgnoringSafeArea(.all)
                                }else if(activeSheetOption == .choose_video_library){
                                    PicturePicker(sourceType: .constant(.photoLibrary), file_data: .constant(Data()), file_url: $image_set.video_file.file_url, isShowingData: $isShowingData, mediaType: .constant(["public.movie"])).edgesIgnoringSafeArea(.all)
                                }else if(activeSheetOption == .choose_music_library){
                                    MusicList_View(isShowingData: $isShowingData, music_list: $image_set.music_file.mediaItems, music_url: $image_set.music_file.file_url).edgesIgnoringSafeArea(.all)
                                }
                            }
                    }
                }.frame(width: 300, height:300, alignment: .topLeading)
                
                NavigationLink(destination: Text("1234"), isActive: $isShowingStatus) {
                }
                
                Button {
                    if(self.isShowingData){
                        self.isShowingAlert = false
                        self.isShowingStatus = true
                    }else{
                        self.isShowingAlert = true
                        self.isShowingStatus = false
                    }
                } label: {
                    Text("See the result").foregroundColor(.white)
                        .font(.system(size: 16, weight: .thin, design: .default))
                        .padding([.leading,.trailing], 80)
                        .padding([.top,.bottom], 10)
                        .background(Color(.sRGB, red: 180/255, green: 56/255, blue: 56/255, opacity: 1))
                        .cornerRadius(5.0).shadow(color: .black, radius: 0.7)
                }.alert(isPresented: self.$isShowingAlert) {
                    Alert(title: Text("Error"), message: Text("You should choose one of the options"), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
            }.navigationViewStyle(.automatic)
        }
    }
}

struct QR_ProjectContent_Previews: PreviewProvider {
    static var previews: some View {
        QR_ProjectContent()
    }
}
