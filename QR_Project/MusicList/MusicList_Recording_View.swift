//
//  MusicList_Recording_View.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 17/5/2022.
//

import SwiftUI
import AVFoundation

struct MusicList_Recording_View: View {
    
    func hours_translation (totalSeconds: Int) -> String{
        return String(totalSeconds/3600) + ":" + String((totalSeconds/60) % 60) + ":" + String(totalSeconds % 60)
    }
    
    func date_translation() -> String{
        let current_date = Date()
        let date_translator = DateFormatter()
        date_translator.dateFormat = "MM-dd-yyyy HH:mm"
        
        let date_str = date_translator.string(from: current_date)
        return date_str.replacingOccurrences(of: " ", with: "_").replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: ":", with: "_")
    }
    
    func recording_audio(){
        self.recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession!.setCategory(.playAndRecord, mode: .default)
            try recordingSession!.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try recordingSession!.setActive(true)
                    
            recordingSession!.requestRecordPermission() { allowed in
                if(allowed){
                    self.audio_record()
                }
            }
        } catch {
            print("Failed to grant recording accession")
        }
    }
    
    func audio_record(){
        if(created_file == nil){
            let current_dateTime = date_translation()
            let file_url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(current_dateTime+".m4a")
            self.created_file = file_url
            
            // If url is not null
            let setting =  [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
                
            do{
                self.audioRecord = try AVAudioRecorder(url: file_url, settings:  setting)
                self.audioRecord!.prepareToRecord()
                self.audioRecord!.record()
            }catch{
                print("error")
            }
        }else{
            print("continue recording")
            self.audioRecord?.record()
        }
    }
    
    func stop_recording(){
        do{
            self.audioRecord?.pause()
        }catch{
            print("error")
        }
    }
    
    // Environment variable - Dismiss view purpose
    @Environment(\.presentationMode) var presentationMode
    // Properities to call AVAudio
    @State var audioRecord: AVAudioRecorder?
    @State var recordingSession: AVAudioSession?
    // Properties to count the second
    @State var timer_str = 0
    // Properties to track whether it is recording
    @State var recording_statu = false
    @Binding var created_file : URL?
    @Binding var isShowingData: Bool
    // Timer Property
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView{
            
            VStack{
                VStack(spacing: 0){
                    Text(recording_statu ? "Recording audio" : "Ready to record audio").padding(.top)
                    
                    Text((hours_translation(totalSeconds: timer_str)))
                        .onReceive(timer) { time in
                            if(recording_statu){
                                timer_str+=1
                            }
                        }.padding(.top)
                    
                    Button {
                        if(self.recording_statu){
                            self.stop_recording()
                        }else{
                            self.recording_audio()
                        }
                        
                        self.recording_statu.toggle()
                    } label: {
                        if(recording_statu){
                            Image(systemName: "stop.circle").resizable().frame(width: 50, height: 50)
                                .tint(Color.red)
                        }else{
                            Image(systemName: "record.circle").resizable().frame(width: 50, height: 50)
                                .tint(Color.red)
                        }
                    }.padding(.top)
                    
                }
                
                
            }.toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if(self.created_file != nil){
                        Button {
                            self.isShowingData = true
                            self.audioRecord?.stop()
                            self.presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Save")
                        }
                    }
                }
            })
            .navigationTitle("Recording Page")
            .navigationBarTitleDisplayMode(.inline)
        }
 
    }
}

struct MusicList_Recording_View_Previews: PreviewProvider {
    static var previews: some View {
        MusicList_Recording_View(created_file: .constant(URL(string: "")!), isShowingData: .constant(false))
    }
}
