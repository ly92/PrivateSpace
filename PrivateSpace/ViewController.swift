//
//  ViewController.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/27.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTF: UITextView!
    @IBOutlet weak var savaBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneEdit(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    //之前的日记
    @IBAction func recordData(_ sender: UIBarButtonItem) {
    
    }
    
    //保存
    @IBAction func saveAction() {
        guard titleTF.text != "" else {
            alertController(title: "error", message: "title empty", action: "OK", master: self)
            return
        }
        
        let nowDate = Date()
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let cTime = formatter.string(from: nowDate)
        
        store(createtime: cTime, modifytime: "", content: contentTF.text, title: titleTF.text!)
        contentTF.text = ""
        titleTF.text = ""
        alertController(title: "success", message: "add", action: "OK", master: self)
    }
    
    
}


