
import UIKit
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper
import FirebaseAuth

class FeedVC: UITableViewController, UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentUserImageUrl: String!
    var posts = [postStruct]()
    var selectedPost: Post!
    var currentPostsArray = [postStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        getPosts()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
   //     tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getUsersData(){

        guard let userID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
            if let postDict = snapshot.value as? [String : AnyObject] {
                self.tableView.reloadData()
            }
        }
    }
    
    struct postStruct {
        let name : String!
        let contactEmail : String!
        let contactPhoneNum : String!
        let age : String!
        let gender : String!
        let lastSeen : String!
        let profileDescription : String!
    }
    
    func getPosts() {
        let databaseRef = Database.database().reference()
        databaseRef.child("firstName").queryOrderedByKey().observe( .childAdded, with: {
                    snapshot in
                    let name = (snapshot.value as? NSDictionary)!["name"] as? String
                    let contactEmail = (snapshot.value as? NSDictionary
                    )!["contactEmail"] as? String
                    let contactPhoneNum = (snapshot.value as? NSDictionary
                    )!["contactPhoneNum"] as? String
                    let age = (snapshot.value as? NSDictionary
                    )!["age"] as? String
                    let gender = (snapshot.value as? NSDictionary
                    )!["gender"] as? String
                    let lastSeen = (snapshot.value as? NSDictionary
                    )!["lastSeen"] as? String
                    let profileDescription = (snapshot.value as? NSDictionary
                    )!["profileDescription"] as? String
            self.posts.append(postStruct(name: name,contactEmail:contactEmail, contactPhoneNum:contactPhoneNum, age:age, gender:gender, lastSeen:lastSeen, profileDescription:profileDescription))
            DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("posts count = ", posts.count)
        return posts.count

   }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      //  tableView.dequeueReusableCell(withIdentifier: "PostCell")!.frame.size.height
        return 230
    }
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else { return UITableViewCell() }
    cell.nameLabel?.text = posts[indexPath.row].name
        cell.contactEmailLabel?.text = posts[indexPath.row].contactEmail
        cell.contactPhoneNumLabel?.text = posts[indexPath.row].contactPhoneNum
        cell.ageLabel?.text = posts[indexPath.row].age
        cell.genderLabel?.text = posts[indexPath.row].gender
        cell.lastSeenLabel?.text = posts[indexPath.row].lastSeen
        cell.profileDescriptionLabel?.text = posts[indexPath.row].profileDescription
        print(posts)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // filteredPosts = []
        //if searchText == ""{
          //  for post in posts {
            //            filteredPosts.append(post.name)
              //         }
            //}
       // else{
        //for post in posts {
          //  if post.name?.lowercased().contains(searchText.lowercased()) == true {
            //    filteredPosts.append(post.name)
            //}
        //}
        //self.tableView.reloadData()
            
    }
   // }
}


