////
////  databaseManager.swift
////  Chat-App
////
////  Created by Aaryan Kothari on 16/04/20.
////  Copyright © 2020 Aaryan Kothari. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//
//struct SponsorDataII{
//    var name: String?
//    var logoUrl: String?
//    var pageUrl: String?
//}
//
//
//class firebaseNetworking {
//
//    //MARK: - variables
//    static let shared = firebaseNetworking()
//    let database = Database.database().reference()
//
//
//    //MARK: - Function to fetch Sponsors data
//
//     public func getSponsorII(completion: @escaping (Bool, [SponsorDataII]) -> ()) {
//        var sponsor = SponsorDataII()
//        var sponsors = [SponsorDataII]()
//        database.child("sponsors").observeSingleEvent(of: .childAdded, with: { (snapshot) in
//            if  let dictionary = snapshot.value as?[String:AnyObject] {
//                if let name = dictionary["name"] { sponsor.name = name as? String }
//                if let logoUrl = dictionary["logoUrl"] { sponsor.logoUrl = logoUrl as? String }
//                if let pageUrl = dictionary["pageUrl"] { sponsor.pageUrl = pageUrl as? String }
//            }
//            sponsors.append(sponsor)
//            completion(true, sponsors)
//         }) { (error) in
//             completion(false, sponsors)
//             debugPrint(error.localizedDescription)
//         }
//     }
//}
//
//struct SponsorData {
//    var name:[String] = []
//    var logoUrl:[String] = []
//    var pageUrl:[String] = []
//}
//
//
//
//
//
