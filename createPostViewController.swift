import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class createPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
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
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
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
    
    
    
   // func uploadImageToFireBase(image: UIImage) {
        // Create the file metadata
     //   let metadata = StorageMetadata()
       // metadata.contentType = "image/jpeg"
        //let storageRef = Storage.storage().reference()
        //let profileRef = storageRef.child("images/rivers.jpg")
        // Upload the file to the path FILE_NAME
        //Storage.storage().reference().child("FILE_NAME").putData(image/.jpegData(compressionQuality: 0.42)!, metadata: metadata) { (metadata, error) in
            //guard let metadata = metadata else {
              // Uh-oh, an error occurred!
              //print((error?.localizedDescription)!)
              //return
            //}
            // Metadata contains file metadata such as size, content-type.
            //let size = metadata.size
            
            //print("Upload size is \(size)")
            //print("Upload success")
        //}
    //}
    
  func uploadImagePic(image: UIImage, name: String, filePath: String) {
    guard let imageData: Data = image.jpegData(compressionQuality: 0.1) else {
        return
    }

    let metaDataConfig = StorageMetadata()
    metaDataConfig.contentType = "image/jpg"

    let storageRef = Storage.storage().reference(withPath: filePath)

    storageRef.putData(imageData, metadata: metaDataConfig){ (metaData, error) in
        if let error = error {
            print(error.localizedDescription)

            return
        }

        storageRef.downloadURL(completion: { (url: URL?, error: Error?) in
            print(url?.absoluteString) // <- Download URL
        })
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
               self.profileImage.image = pickedImage
               self.postBtn.isHidden = true
               uploadImagePic(image: pickedImage)
               picker.dismiss(animated: true, completion: nil)
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
//}
}

