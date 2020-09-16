//
//  SentMemeCollectionViewController.swift
//  Meme 1.0
//
//  Created by Elina Mansurova on 2020-09-09.
//  Copyright © 2020 Elina Mansurova. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNew))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func configureFlowLayout() {
        let space: CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = self.memes[indexPath.row]

        cell.imageView.image = meme.image

        return cell
    }
    
    @objc func didTapAddNew() {
        let addNewVC = self.storyboard!.instantiateViewController(withIdentifier: "EditiontheMemeViewController") as! EditiontheMemeViewController
        
        addNewVC.modalPresentationStyle = .fullScreen
        navigationController!.present(addNewVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsMeme = self.storyboard?.instantiateViewController(withIdentifier: "DetailsMeme") as! DetailsMeme
        detailsMeme.memeDetail = memes[indexPath.row]
        self.navigationController?.pushViewController(detailsMeme, animated: true)
    }
    
}
