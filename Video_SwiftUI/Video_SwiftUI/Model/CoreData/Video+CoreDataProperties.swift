//
//  Video+CoreDataProperties.swift
//  Video_SwiftUI
//
//  Created by Shotaro Hirano on 2022/01/10.
//
//

import Foundation
import CoreData


extension Video {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Video> {
        return NSFetchRequest<Video>(entityName: "Video")
    }

    @NSManaged public var addedDate: Date?
    @NSManaged public var urlString: String?
    @NSManaged public var title: String?

}

extension Video : Identifiable {

}
