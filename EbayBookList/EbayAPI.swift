//
//  EbayAPI.swift
//  EbayBookList
//
//  Created by Austins Work on 9/27/16.
//  Copyright © 2016 AustinsIronYard. All rights reserved.
//

import Foundation

struct EbayAPI {
    
    enum Error: Swift.Error {
        case invalidJSONData
    }
    
    static let streamURL = URL(string: "https://de-coding-test.s3.amazonaws.com/books.json")!
    
    static func books(with json: Data) throws ->  [Book]{
        guard let objectRepresentation = try! JSONSerialization.jsonObject(with: json, options: []) as? [[String: AnyObject]] else {
            throw Error.invalidJSONData
        }
        
        var returnValue: [Book] = []

        for dictionary in objectRepresentation{
            if let book = book(with: dictionary){
                returnValue.append(book)
            }
        }
        
        if returnValue.count != objectRepresentation.count{
            throw Error.invalidJSONData
        }
        
        let session = URLSession.shared

        let task = session.dataTask(with: EbayAPI.streamURL, completionHandler: { (data, response, error) in
            print("\n\n\n")
            if let data = optionalData {
                let books = try! (EbayAPI.books(with: data))
            }else{
                print("didnt recieve data")
            }
        })
        task.resume()
        return returnValue
        
    }
    
    static func book(with dictRepresentation: [String: AnyObject])  -> Book?{
        guard let title = dictRepresentation["title"] as? String else {return nil}
        let author = dictRepresentation["author"] as? String
        let imageURL = dictRepresentation["imageURL"] as? String
        
        let book = Book(title: title, author: author, imageURL: imageURL)
        return book
    }
    
    
    
}
