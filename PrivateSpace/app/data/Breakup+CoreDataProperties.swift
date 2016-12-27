//
//  Breakup+CoreDataProperties.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/27.
//  Copyright © 2016年 ly. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Breakup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breakup> {
        return NSFetchRequest<Breakup>(entityName: "Breakup");
    }

    @NSManaged public var createtime: String?
    @NSManaged public var modifytime: String?
    @NSManaged public var content: String?

}
