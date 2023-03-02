//
//  FeedCell.swift
//  instaFirabaseClone
//
//  Created by Yakup Suda on 2.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var ppImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        let fireStoreDb = Firestore.firestore()
        if let likeCount = Int(likeLabel.text!){
            let likeStore = ["Likes" : likeCount + 1] as [String : Any]
            fireStoreDb.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
       
    }
}
