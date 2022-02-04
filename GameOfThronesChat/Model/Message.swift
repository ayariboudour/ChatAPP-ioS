//
//  Message.swift
//  GameOfThronesChat
//
//  Created by sarah sghair on 15/08/2018.
//  Copyright © 2018 Boudour Ayari. All rights reserved.
//

import UIKit
import Firebase
@objcMembers
class Message: NSObject {
    @objc var fromId: String?
    @objc var text: String?
    @objc var toId: String?
    @objc var timestamp: NSNumber?
    @objc var imageUrl: String?
    @objc var imageWidth: NSNumber?
    @objc var imageHeight: NSNumber?
    @objc var videoUrl: String?

    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
    init(dictionary: [String: AnyObject]) {
        super.init()
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageUrl = dictionary["imageUrl"] as? String
        text = dictionary["text"] as? String
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String

    }
}
