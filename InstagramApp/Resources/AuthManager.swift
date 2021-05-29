//
//  AuthManager.swift
//  InstagramApp
//
//  Created by 陳飛 on 1/4/21.
//

import FirebaseAuth

public class AuthManager {
    
    static let shared = AuthManager()
    
    // MARK: - Public
    
    public func registerNewUser(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        /*
         - Check if username is available
         - Check if email is available
        */
        DatabaseManager.shared.canCreateNewUser(with: email, username: username) { canCreate in
            
            if canCreate {
                /*
                 - Create account
                 - Insert account to database
                */
                Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                    
                    guard authResult != nil, error == nil else {
                        // Firebase auth could not create account
                        print("1")
                        completion(false)
                        return
                    }
                    
                    // Insert into database
                    DatabaseManager.shared.insertNewUser(with: email, username: username) { inserted in
                        
                        if inserted {
                            completion(true)
                            return
                        }
                        else {
                            // failed to insert to database
                            print("2")
                            completion(false)
                            return
                        }
                    }
                }
            }
            else {
                // Either username or email does not exist
                print("3")
                completion(false)
            }
        }
    }
    
    public func loginUser(username: String?, email: String?, password: String, completion: @escaping ((Bool) -> Void)) {
        
        if let email = email {
            // email log in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                
                guard authResult != nil, error == nil else {
                    completion(false)
                    return
                }
                
                completion(true)
            }
        }
        else if let username = username {
            // username log in
            
            print(username)
        }
        
    }
    
    /// Attempt to log out firebase user
    public func logOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }
}
