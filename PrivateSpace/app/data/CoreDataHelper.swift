//
//  CoreDataHelper.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/27.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import CoreData

// 获取appDelegate中的Context
func getContext () -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    return appDelegate.persistentContainer.viewContext
}

// 存储新好友
func store(createtime : String, modifytime : String, content : String, title : String){
    let context = getContext()
    // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
    let entity = NSEntityDescription.entity(forEntityName: "Breakup", in: context)
    let breakup = NSManagedObject(entity: entity!, insertInto: context)
    breakup.setValue(createtime, forKey: "createtime")
    breakup.setValue(modifytime, forKey: "modifytime")
    breakup.setValue(content, forKey: "content")
    breakup.setValue(title, forKey: "title")
    save()
}

//保存
func save() {
    do {
        try getContext().save()
    }catch{
        print(error)
    }
}

// 查找,未找到返回nil
func lookup(indentification :String) -> Breakup?{
    for breakup in fetchAllBreakup()!{
        if breakup.mark == indentification {
            return breakup
        }
    }
    return nil
}

//获取所有对象
func fetchAllBreakup() -> [Breakup]?{
    do {
        return try getContext().fetch(Breakup.fetchRequest()) as [Breakup]
    } catch  {
        print(error)
    }
    return nil
}

func alertController(title :String ,message :String? ,action :String ,master :AnyObject) -> Void {
    let alertControllerStyle = UIAlertControllerStyle(rawValue: 1)
    let alert = UIAlertController(title: title,message: message,preferredStyle: alertControllerStyle!)
    alert.addAction(UIAlertAction(title: action,style: UIAlertActionStyle.default,handler: nil))
    master.present(alert, animated: true, completion: nil)
}


class CoreDataHelper: NSObject {
    
    
}
