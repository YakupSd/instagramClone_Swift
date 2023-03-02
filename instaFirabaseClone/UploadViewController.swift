//
//  UploadViewController.swift
//  instaFirabaseClone
//
//  Created by Yakup Suda on 1.03.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore

class UploadViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //ekrana tıklaman için gereken kod
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func makeAlert(inputTitle: String, inputMessage:String){
        let alert = UIAlertController(title: inputTitle, message: inputMessage, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    func temizle(){
        self.imageView.image = UIImage(named: "saveimage.png")
        self.commentText.text = ""
        self.userText.text = ""
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        //sunucuya yükeleme işlemleri
        let storage = Storage.storage()
        let storageRef = storage.reference()
        //sunucu üzerine klasör açma işlemi
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString // resme id atama
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data,metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(inputTitle: "Error!", inputMessage: error?.localizedDescription ?? "Error!")
                }else {
                    
                    imageRef.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE İşlemleri
                            let firestoreDb = Firestore.firestore()
                            var firestoreRef : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy": Auth.auth().currentUser!.email!,
                                                 "postComment" : self.commentText.text!,"postUser" : self.userText.text!,
                                                 "Date" : FieldValue.serverTimestamp(), "Likes" : 0] as [String : Any]
                            
                            
                            firestoreRef = firestoreDb.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    
                                    self.makeAlert(inputTitle: "Error!", inputMessage: error?.localizedDescription ?? "Error")
                                }else {
                                    //işlem bittikten sonra temizleme
                                    self.temizle()
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    @objc func chooseImage(){
        //kullancı kütüphane erişimi için
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

}
