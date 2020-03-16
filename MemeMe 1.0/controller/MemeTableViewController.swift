//
//  MemeTableViewController.swift
//  MemeMe 1.0
//
//  Created by mac on 11/03/2020.
//  Copyright © 2020 NotZero Technologies. All rights reserved.
//

import UIKit

private let reuseIdentifier = "tableViewCell"
private let detailSegueId = "to_memeDetailController"

class MemeTableViewController: UITableViewController {
    
    private var memes:[Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (UIApplication.shared.delegate as! AppDelegate).memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eachCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let eachMeme = memes[indexPath.row]
        
        eachCell.imageView?.image = eachMeme.newImage
        eachCell.textLabel?.text = "TOP MEME: \(eachMeme.topMeme)  BOTTOM: \(eachMeme.bottomMeme)"
        
        return eachCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailSegueId, sender: memes[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId{
            let memeDetailVC = segue.destination as! MemeDetailViewController
            let meme = sender as! Meme
            memeDetailVC.meme = meme
        }
    }
}
