//
//  LoginViewController.swift
//  ELLAPP2017
//
//  Created by Nick Ponce on 11/16/17.
//  Copyright © 2017 Ellokids. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {


    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var currentUserGlobal = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
    // First try to log in to the database
        login(user: usernameTextField.text!, pass: passwordTextField.text!) {
            (userObj: PFUser?) in
            
            // If the login was successful, clear the password and navigate to the dashboard
            if let result = userObj {
                result.password = ""
                self.passwordTextField.text = ""
                
                self.navigateToDashboard(userObj: result)
            }
                // Otherwise, clear the password and print an error message
            else {
                // TODO: Consider reimplementing pop-ups for errors and notifications
                self.loginErrorLabel.text = "Login failed. Try checking your password again"
                self.passwordTextField.text = ""
            }
        }
    }
    
    // Logs in with username and password. Result is a PFUser on success, nil on faiure
    func login(user: String, pass: String, completion: @escaping (_ result: PFUser?) -> Void) {
        // Attempt to log in with said PFUser
        PFUser.logInWithUsername(inBackground: user, password: pass, block: {
            (PFUser : PFUser?, Error: Error?) -> Void in
            
            // If the user info is valid and login succeeds
            if Error == nil {
                completion(PFUser!)
            }
            else {
                completion(nil)
            }
        })
    }
    
    // Navigates to userObj's dashboard
    func navigateToDashboard(userObj: PFUser) {
        
        // Get the user's roles
        getUserRoles(userObj: userObj) {
            (userRoles: [String]) in
            
            // Naviagate to the appropriate screen
            self.currentUserGlobal = userObj
            if userRoles.contains("teacher") || userRoles.contains("admin") {
                self.performSegue(withIdentifier: "sw_parse_table", sender: nil)
            }
            else if userRoles.contains("student") {
                // Navigates to one side always
                self.performSegue(withIdentifier: "sw_parse_table", sender: nil)
            }
            else {
                //TODO: user belongs to no roles...? (or an error getting roles)
            }
        }
    }
    
    // Returns an array containing all available roles, array is empty if an error occurs
    func getAllRoles(completion: @escaping (_ result: [PFObject]) -> Void) {
        
        // Get the PFQuery<PFObject> for the Role class
        let roleQuery = PFQuery(className: "_Role")
        //                    roleQuery.findObjectsInBackground(block: <#T##(([PFObject]?, Error?) -> Void)?##(([PFObject]?, Error?) -> Void)?##([PFObject]?, Error?) -> Void#>)
        //                    roleQuery.getObjectInBackground(withId: <#T##String#>, block: <#T##((PFObject?, Error?) -> Void)?##((PFObject?, Error?) -> Void)?##(PFObject?, Error?) -> Void#>)
        //                    roleQuery.whereKey("title", equalTo: "Pizza Chef")
        
        // Find all objects in the PFQuery<PFObject> and put them into a PFObject array or throw an error
        roleQuery.findObjectsInBackground(block: { (roles: [PFObject]?, error: Error?) -> Void in
            
            // If the query is successful, return the list of roles
            if let result = roles {
                completion(result)
            }
                // Otherwise return an empty list and update the error label
            else {
                self.loginErrorLabel.text = "Query error occured \(error.debugDescription))"
                completion([])
            }
        })
    }
    
    // Gets the roles of a user (TODO: must be called after user is authenticated??)
    func getUserRoles(userObj: PFUser, completion: @escaping (_ result: [String]) -> Void) {
        
        // First get all the roles, so we can check if the user belongs to each one
        getAllRoles() {
            (roles: [PFObject]) in
            
            var userRoles = [String]()
            var rolesChecked = 0
            
            // If the user doesn't belong to any roles, return an empty array
            if roles.count == 0 {
                completion(userRoles)
            }
            
            // Search through each role to find the ones the user belongs to
            for role in roles {
                // Check to see if they belong
                self.doesUserBelongToRole(userObj: userObj, role: role) {
                    (belongs: Bool) in
                    
                    // If they do, add this role the the list of the user's roles
                    if belongs {
                        userRoles.append(role["name"] as! String)
                    }
                    
                    // If this is the last role to check, send back the result
                    // TODO: It's likely this might need/want semaphores
                    rolesChecked += 1
                    if rolesChecked >= roles.count {
                        completion(userRoles)
                    }
                    
                }
            }
        }
    }
    
    // Checks whether a user belongs to a role, false if an error occurs
    func doesUserBelongToRole(userObj: PFUser, role: PFObject, completion: @escaping (_ result: Bool) -> Void) {
        // Get the users that pertain to the role
        let userRelations = role["users"] as! PFRelation<PFUser>
        
        // Query the PFQuery<PFUsers> of the role and find all the PFUsers that pertain to it
        userRelations.query().findObjectsInBackground(block: { (users: [PFUser]?, err: Error?) -> Void in
            // If the objects are found without issue
            if err != nil {
                // TODO: Add error handling
                print("Error querying the user objects of a role")
                completion(false)
                return
            }
            
            // True if the role contains our user, false otherwise
            completion(users!.contains(where: {$0.username == userObj.username!}))
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sw_parse_table" {
            // Us: Magic conch, what do we do now?
            // EllApp: ...Nothing
        }
    }
    
}

