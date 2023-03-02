//
//  FeedViewController.swift
//  instaFirabaseClone
//
//  Created by Yakup Suda on 1.03.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        
        // Do any additional setup after loading the view.
    }
    func getDataFromFirestore(){
        //veri çekme işlemleri
        let firestoreDb = Firestore.firestore()
       /*
        //tarih ayarı
        let settings = firestoreDb.settings
        firestoreDb.settings = settings
        */
        firestoreDb.collection("Posts").order(by: "Date", descending: true)//order sayaseinde filtreleme
            .addSnapshotListener { snapshot, error in
            if error != nil{
                print(error?.localizedDescription)
            }else {
                if snapshot?.isEmpty != true && snapshot != nil{
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    for document in  snapshot!.documents{
                        let documantId = document.documentID
                        self.documentIdArray.append(documantId)
                        
                        //çektiğimiz verileri oluşturdğuğmuz dizilere atarak tutuyoruz
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("Likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.ppImage.image = UIImage(named: "bash.png")
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }
    

   

}
