//
//  SF_view_page.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 24/5/2022.
//

import SwiftUI

struct SF_view_page: View {
    @State var isOpeningWeb: Bool = true
    @Binding var service_link : String
    
    var body: some View {
        ZStack{
            VStack{
                if(self.isOpeningWeb){
                    SFSafariVC(website: $service_link, isPressingDone: $isOpeningWeb)
                }
            }
        }
    }
}

struct SF_view_page_Previews: PreviewProvider {
    static var previews: some View {
        SF_view_page(service_link: .constant(""))
    }
}
