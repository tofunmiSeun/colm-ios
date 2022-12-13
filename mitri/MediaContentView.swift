//
//  MediaContentView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 13/12/2022.
//

import SwiftUI

struct MediaContentView: View {
    let mediaContent: MediaContent
    
    @State private var data: Data?
    
    var body: some View {
        VStack {
            if let rawData = data {
                Image(uiImage:  UIImage(data: rawData)!)
                    .resizable()
                    .scaledToFill()
                    .border(Color(white: 0.75))
                    .clipped()
                    .cornerRadius(4)
            }
        }.task {
            await loadMediaDataContent()
        }
    }
    
    
    private func loadMediaDataContent() async {
        let uri = "/media-content/\(mediaContent.id)/raw-data"
        Api.get(uri: uri) { data in
            DispatchQueue.main.async {
                self.data = data
            }
        }
    }
}

struct MediaContentView_Previews: PreviewProvider {
    static var previews: some View {
        MediaContentView(mediaContent: MediaContent.mocks[0])
    }
}
