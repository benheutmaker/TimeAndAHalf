//
//  THError.swift
//  Time and a Half
//
//  Created by Benjamin Heutmaker on 8/14/15.
//  Copyright © 2015 Benjamin Heutmaker. All rights reserved.
//

import Foundation

enum NetworkError: ErrorType {
    case DownloadFail(error: NSError?)
    case UploadFail(error: NSError?)
}