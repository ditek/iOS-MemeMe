//
//  TableViewController.swift
//  meme
//
//  Created by Diaa on 26/12/2020.
//

import UIKit

private let reuseIdentifier = "TableCell"

class TableViewController: UITableViewController, MemeViewer {

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
        print("table: ", sentMemes.count)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentMemes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.imageView?.image = sentMemes[indexPath.row].memedImage
        cell.textLabel?.text = sentMemes[indexPath.row].topText
        return cell
    }
    
    @objc func newMeme(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewMemeViewController") as! NewMemeViewController
        present(controller, animated: true, completion: nil)
    }
    
    @objc func updateView() {
        print("updated table")
        tableView.reloadData()
    }

}
