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
        self.contentTF.resignFirstResponder()
    }
    
    //之前的日记
    @IBAction func recordData(_ sender: UIBarButtonItem) {
    
    }
    
    //保存
    @IBAction func saveAction() {
        
    }
    
    
}


