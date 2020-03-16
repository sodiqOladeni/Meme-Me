//
//  MemeCollectionViewController.swift
//  MemeMe 1.0
//
//  Created by mac on 11/03/2020.
//  Copyright © 2020 NotZero Technologies. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionViewCell"
private let detailSegueId = "to_memeDetailController"

class MemeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    private var memes:[Meme]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memes = (UIApplication.shared.delegate as! AppDelegate).memes
        collectionView.reloadData()
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
               
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let eachMeme = memes?[indexPath.row]
        
        cell.contentImageView.image = eachMeme?.newImage
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailSegueId, sender: memes?[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueId {
            let memeDetailVC = segue.destination as! MemeDetailViewController
            let meme = sender as! Meme
            memeDetailVC.meme = meme
        }
    }
}
