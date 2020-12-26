//
//  CollectionViewController.swift
//  meme
//
//  Created by Diaa on 26/12/2020.
//

import UIKit

private let reuseIdentifier = "CollectionCell"

class CollectionViewController: UICollectionViewController, MemeViewer {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var sentMemes: [Meme] {
        return appDelegate.sentMemes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMeme))
        navigationItem.title = "Sent Memes"
    
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: Meme.newMemeNotification,
                                               object: nil)
    }

    override func viewWillAppear(_: Bool){
        super.viewWillAppear(true)
        print("collection: ", sentMemes.count)
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentMemes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.imageView?.image = sentMemes[indexPath.row].memedImage
        return cell
    }

    
    @objc func newMeme(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController") as! NewMemeViewController
        present(controller, animated: true, completion: nil)
    }
    
    @objc func updateView() {
        print("updated coll")
        collectionView.reloadData()
    }

}
