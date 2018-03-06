//
//  TestParseTableViewController.swift
//  testParseLibrary
//
//  Created by Nick Ponce on 1/26/18.
//  Copyright © 2018 Ellokids. All rights reserved.
//

import UIKit
import Parse

class TestParseTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var testTableView: UITableView!
    
    var titles = [String]()
    var authors = [String]()
    var coverPictures = [PFFile]()
    var selectedObjectId = String()
    var selectedTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get all book objects and extract their data into arrays
        getAllBooks() {
            (books: [PFObject]) in
            for book in books {
                self.titles.append(book["name"] as! String)
                self.authors.append(book["author"] as! String)
                self.coverPictures.append(book["coverPicture"] as! PFFile)
                
                self.testTableView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllBooks(completion: @escaping (_ result: [PFObject]) -> Void) {
        // Get the PFQuery<Object> for the Books class
        let bookQuery = PFQuery(className: "Book")
        
        bookQuery.findObjectsInBackground(block: { (books: [PFObject]?, error: Error?) -> Void in
            if let result = books {
                completion(result)
            }
            else {
                completion([])
            }
        })
    }
    
    // Tableview Datasource Functions
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        // The number of columns
        return 1
    }
    
    // The number of rows is dynamic
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Hopefully won't return anything if the table fails.
        print("The number of titles: \(titles.count)")
        return titles.count
    }
    
    // Populates each cell with the appropriate data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = testTableView.dequeueReusableCell(withIdentifier: "tvc_test_cell", for: indexPath) as? PersonalParseTableViewCell
        
        // Add cell initialization
        cell?.bookTitleLabel.text = titles[indexPath.row]
        cell?.authorLabel.text = authors[indexPath.row]
        
        cell?.coverPictureImageView.image = UIImage(named: "placeholder.jpg")
        cell?.coverPictureImageView.file = coverPictures[indexPath.row]
        cell?.coverPictureImageView.loadInBackground()

        // Load PFFile as book image
//        coverPictures[indexPath.row].getDataInBackground(block: { (cover, error) -> Void in
//            if let downloadedImage = UIImage(data: cover!) {
//                cell?.coverPictureImageView.image = downloadedImage
//            }
//            else {
//                print("Cell Error occured: \(error.debugDescription)")
//            }
//        })
        
        return cell!
    }
    
    // Defines what should happen when a cell is selected
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
