//
//  testPFQueryTableViewController.swift
//  testParseLibrary
//
//  Created by Nick Ponce on 2/14/18.
//  Copyright © 2018 Ellokids. All rights reserved.
//

import UIKit
import Parse

class testPFQueryTableViewController: PFQueryTableViewController {
    
    var titles = [String]()
    var authors = [String]()
    var coverPictures = [PFFile]()
    var selectedObjectId = String()
    var selectedTitle = String()
    
    override init(style: UITableViewStyle, className: String?) {
        super .init(style: style, className: className)
        
        pullToRefreshEnabled = true
        parseClassName = "Book"
        paginationEnabled = true
        objectsPerPage = 25
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        
        pullToRefreshEnabled = true
        parseClassName = "Book"
        paginationEnabled = true
        objectsPerPage = 25
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery<PFObject> {
        let query = PFQuery(className: parseClassName!);
        
        return query;
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // Might crash if no objects at all
        return self.objects!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellID = "pfcell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? TestParseTableViewCell
        
        if cell == nil {
            cell = PFTableViewCell(style: .subtitle, reuseIdentifier: cellID) as? TestParseTableViewCell
        }
        
        if let object = object {
            let coverData = object["coverPicture"] as? PFFile
            
            cell?.bookTitleLabel.text! = object["name"] as! String
            cell?.authorLabel.text! = object["author"] as! String
//            cell?.textLabel?.text = object["name"] as? String
//            cell?.imageView?.image = UIImage(named: "placeholder.jpg")
//            cell?.imageView?.file = object["coverPicture"] as? PFFile
//            cell?.coverPictureImageView.image = UIImage(named: "placeholder.jpg")
//            cell?.coverPictureImageView.file! = object["coverPicture"] as! PFFile
//            cell?.coverPictureImageView.loadInBackground() // Parse says this will be fine

            // Load PFFile as book image
            coverData!.getDataInBackground(block: { (cover, error) -> Void in
                if let downloadedImage = UIImage(data: cover!) {
                    cell?.coverPictureImageView.image = downloadedImage
                    print("This is the image: \(downloadedImage)");
                }
                else {
                    print("Cell Error occured: \(error.debugDescription)")
                }
            })
        }
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "tvc_test_cell", for: indexPath) as? TestParseTableViewCell
//
//        // Add cell initialization
//        cell?.bookTitleLabel.text = titles[indexPath.row]
//        cell?.authorLabel.text = authors[indexPath.row]
//
//        // Load PFFile as book image
//        coverPictures[indexPath.row].getDataInBackground(block: { (cover, error) -> Void in
//            if let downloadedImage = UIImage(data: cover!) {
//                cell?.coverPictureImageView.image = downloadedImage
//            }
//            else {
//                print("Cell Error occured: \(error.debugDescription)")
//            }
//        })
//
//        return cell!
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
