//
//  UserPostsViewController.swift
//  UserPost
//
//  Created by Kavindu Hansajith on 2024-10-08.
//

import UIKit

class UserPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    


    @IBOutlet weak var tableView: UITableView!
    var userId: Int? // Property to store the selected user's ID
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let rightBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        fetchUserPosts() // Call this method to fetch the posts
    }
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count // Return the number of posts
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell with data from your posts array
        let post = posts[indexPath.row]
        cell.textLabel?.text = post.title // Display post title
        
        return cell
    }
    
    // MARK: - Fetch User Posts
    
    func fetchUserPosts() {
        // Replace {user_id} with the actual user ID
        let userId = "1" // Example user ID, you might want to pass this dynamically
        let urlString = "https://gorest.co.in/public/v2/users/\(userId)/posts"
        
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer f554dbb43244c9ef5fa41a133e9c23dbfeb78570da299d6093f897bc692e4e74", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                // Decode the JSON data into the posts array
                self.posts = try JSONDecoder().decode([Post].self, from: data)
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding posts: \(error)")
            }
        }
        
        task.resume() // Start the network request
    }
    
    @objc func addButtonTapped() {
        print("Add button tapped")
        // Here you can implement the functionality you want to perform when the button is tapped
    }
}
