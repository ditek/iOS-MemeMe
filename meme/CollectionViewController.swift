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

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newMeme))
        navigationItem.title = "Sent Memes"
    
        // New meme notification
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateView),
                                               name: Meme.newMemeNotification,
                                               object: nil)
        
        // Flow layout setup
        let space: CGFloat = 3.0
        let width = (view.frame.size.width - (2 * space)) / 3.0
        let height = (view.frame.size.height - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: width, height: height)
    }

    override func viewWillAppear(_: Bool){
        super.viewWillAppear(true)
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailController.image = sentMemes[indexPath.row].memedImage
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CollectionShowDetails":
            guard let vc = segue.destination as? DetailsViewController else {
                fatalError("Expected DetailsViewController")
            }
            vc.imageView.image = (sender as! Meme).memedImage
        default:
            fatalError("Unexpected segue: " + segue.identifier!)
        }
    }

    // MARK: Callbacks
    
    @objc func newMeme(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController") as! NewMemeViewController
        present(controller, animated: true, completion: nil)
    }
    
    @objc func updateView() {
        collectionView.reloadData()
    }

}
