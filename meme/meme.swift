//
//  meme.swift
//  meme
//
//  Created by Diaa on 20/12/2020.
//

import Foundation
import UIKit

struct Meme {
    static let newMemeNotification = NSNotification.Name("NewMemeNotification")

    var topText: String?
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

// Used to trigger updating the table/collection view
protocol MemeViewer {
    func updateView()
}
