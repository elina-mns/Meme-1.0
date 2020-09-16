//
//  TableVC.swift
//  Meme 1.0
//
//  Created by Elina Mansurova on 2020-09-11.
//  Copyright © 2020 Elina Mansurova. All rights reserved.
//

import Foundation
import UIKit

class TableVC: UITableViewController {
    
    var memes: [Meme]! {
       let object = UIApplication.shared.delegate
       let appDelegate = object as! AppDelegate
       return appDelegate.memes
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddNew))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.image
        cell.textLabel?.text = "\(meme.text1)...\(meme.text2)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMeme = memes[indexPath.row]
        let memeDetailController = storyboard?.instantiateViewController(identifier: "DetailsMeme") as! DetailsMeme
        memeDetailController.memeDetail = selectedMeme
        navigationController?.pushViewController(memeDetailController, animated: true)
    }
    
    @objc func didTapAddNew() {
        let addNewVC = self.storyboard!.instantiateViewController(withIdentifier: "EditiontheMemeViewController") as! EditiontheMemeViewController
        
        addNewVC.modalPresentationStyle = .fullScreen
        navigationController!.present(addNewVC, animated: true)
    }
}
