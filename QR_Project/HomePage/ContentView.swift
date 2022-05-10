//
//  ContentView.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 4/5/2022.
//

import SwiftUI




struct ContentView: View {
    
    @State var isShowpresented = false
        
    var icon : some View{
        Image("Icon").resizable().frame(width: 200, height: 200)
    }
    
    var body: some View {
        Color.white.overlay {
            NavigationView{
                VStack(spacing:10){
                    // ImageView for the homePage
                    icon
                    // Title for the homePage
                    Text("QR Code Application").font(.title)
                    // Just give some space between the title and btn
                    Spacer().frame(height: 160)
                    // Button for navigation to the next view
                    Button {
                        self.isShowpresented = true
                    } label: {
                        // Navigation Link to next page
                        NavigationLink("Start", isActive: $isShowpresented) {
                            // Title for the navigation link
                            QR_ProjectContent()
                        }.foregroundColor(.white)
                        .font(.system(size: 16, weight: .thin, design: .default))
                        .padding([.leading,.trailing], 100)
                        .padding([.top,.bottom], 10)
                        .background(Color(.sRGB, red: 180/255, green: 56/255, blue: 56/255, opacity: 1))
                    }.cornerRadius(5.0).shadow(color: .black, radius: 0.7)
                    // Just give some space between the title and btn
                    Spacer()
                }
            }
        }.edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
