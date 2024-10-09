//
//  ViewController.swift
//  UserPost
//
//  Created by Kavindu Hansajith on 2024-10-08.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var users: [User] = []  // This will store the list of users

        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            
            fetchUsers()  // Fetch users when the screen loads
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedUser = users[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let userPostsVC = storyboard.instantiateViewController(withIdentifier: "UserPostsViewController") as? UserPostsViewController {
                userPostsVC.userId = selectedUser.id  // Pass the selected user ID
                self.navigationController?.pushViewController(userPostsVC, animated: true)
            }
        }
    
    

        // MARK: - TableView DataSource Methods
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return users.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = users[indexPath.row].name  // Assuming User model has a 'name' property
            return cell
        }
        
        // MARK: - Fetch Users from API
        func fetchUsers() {
            guard let url = URL(string: "https://gorest.co.in/public/v2/users") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer f554dbb43244c9ef5fa41a133e9c23dbfeb78570da299d6093f897bc692e4e74", forHTTPHeaderField: "Authorization")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }

                if let data = data {
                    do {
                        self.users = try JSONDecoder().decode([User].self, from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } catch let jsonError {
                        print("Failed to decode JSON: \(jsonError)")
                    }
                }
            }
            task.resume()
        }
    }
