//
//  QR_ProjectContentRow.swift
//  QR_Project
//
//  Created by kwok chung  kwan on 6/5/2022.
//

import SwiftUI

struct QR_ProjectContentRow: View {
    @Binding var column_image : String
    @Binding var column_text : String
    
    var body: some View {
        HStack{
            Image(column_image).resizable().frame(width: 75, height: 75)
            Text(column_text)
        }
    }
}

struct QR_ProjectContentRow_Previews: PreviewProvider {
    static var previews: some View {
        QR_ProjectContentRow(column_image: .constant("Icon"), column_text: .constant("Hi123"))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
