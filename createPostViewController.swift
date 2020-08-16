import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class createPostViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactPhoneNum: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var lastSeen: UITextField!
    @IBOutlet weak var profileDescription: UITextField!
    @IBOutlet weak var postBtn: UIButton!
    
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createPostViewController.handleSelect))
        profileImage.addGestureRecognizer(tapGesture)
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        postBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    

    @objc func handleSelect(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func post(_ sender: AnyObject) {
        let userID = Auth.auth().currentUser?.uid
        Database.database().reference().child("profiles").child(userID!).observe(.value, with: { (snapshot) in
            let post: Dictionary<String, AnyObject> = [
               // "userImg":  as AnyObject,
                "name": self.name.text as AnyObject,
                "contactEmail": self.contactEmail.text as AnyObject,
                "contactPhoneNum": self.contactPhoneNum.text as AnyObject,
                "age": self.age.text as AnyObject,
                "gender": self.gender.text as AnyObject,
                "lastSeen": self.lastSeen.text as AnyObject,
                "profileDescription": self.profileDescription.text as AnyObject,
            ]
            
            let firebasePost = Database.database().reference().child("profiles").childByAutoId()
            firebasePost.setValue(post)
        })
        
    }
    
    func uploadImageToFireBase(image: UIImage) {
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path FILE_NAME
        Storage.storage().reference().child("posts").putData(image.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                print((error?.localizedDescription))
                return
            }
            
            Storage.storage().reference().child("posts").downloadURL { (imageUrl, error) in
                if let error = error {
                    print("error: ", error.localizedDescription)
                    return
                }
                if let userID = Auth.auth().currentUser?.uid {
                    let currentUserRef = Database.database().reference().child("profiles").child(userID)
                    currentUserRef.updateChildValues(["profileImage": imageUrl])
                }
            }
        }
    }
    
    //func uploadToCloud(fileURL : URL) {
      //  let storage = Storage.storage()
        
        //let data = Data()
        
        //let storageRef = storage.reference()
        
        //let localFule = fileURL
        
        //let userID = Auth.auth().currentUser?.uid
        
        //let photoRef = storageRef.child("profilePhoto\(userID)")
        
        //let uploadTask = photoRef.putFile(from: localFule, metadata: nil) { (metadata, err) in
          //  guard let metadata = metadata else {
            //    print(err?.localizedDescription)
              //  return
            //}
            //print("Photo Upload")
            
       // }
   // }
}

extension createPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
              profileImage.image = image
                uploadImageToFireBase(image: image)
          } else {
              print("image wasnt selected")
          }

        dismiss(animated: true, completion: nil)
    }
}
