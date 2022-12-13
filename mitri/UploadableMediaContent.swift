//
//  UploadableMediaContent.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 13/12/2022.
//

import Foundation
struct UploadableMediaContent {
    let name: String
    let data: Data
    var fileName: String?
    var mimeType: String?
}
