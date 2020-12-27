//
//  DetailsViewController.swift
//  meme
//
//  Created by Diaa on 26/12/2020.
//

import UIKit

class DetailsViewController: UIViewController {
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        imageView?.image = image
    }
}
