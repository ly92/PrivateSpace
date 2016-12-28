//
//  BreakupDetailViewController.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/28.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit

class BreakupDetailViewController: UIViewController {
    var breakup : Breakup!
    
    @IBOutlet weak var contentTF: UITextView!
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var modifyLbl: UILabel!
    @IBOutlet weak var createLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTF.text = self.breakup.title
        contentTF.text = self.breakup.content
        createLbl.text = self.breakup.createtime
        modifyLbl.text = self.breakup.modifytime

        self.navigationItem.title = "详情"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(endEdit))

        // Do any additional setup after loading the view.
    }
    
    func endEdit() -> Void {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func modifyAction() {
        self.view.endEditing(true)
        
        let nowDate = Date()
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let mTime = formatter.string(from: nowDate)
        
        self.breakup.title = titleTF.text
        self.breakup.content = contentTF.text
        self.breakup.modifytime = mTime
        modifyLbl.text = self.breakup.modifytime
        save()
        alertController(title: "success", message: "modify", action: "OK", master: self)
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
