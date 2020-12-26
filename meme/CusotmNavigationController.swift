//
//  CusotmNavigationController.swift
//  meme
//
//  Created by Diaa on 26/12/2020.
//

import UIKit

class CusotmNavigationController: UINavigationController {

    var newMemeButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let navigationBar = UINavigationBar()
//        navigationBar.barTintColor = UIColor(named: "blue")
//        view.addSubview(navigationBar)
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMeme))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: .add, style: .plain, target: self, action: #selector(newMeme))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(newMeme))
        
        
        let logo = UIImage(named: "edit")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        isToolbarHidden = false
    }
    

    @objc func newMeme(){
        performSegue(withIdentifier: "ViewController", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
