//
//  ViewController.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/27.
//  Copyright © 2016年 ly. All rights reserved.
//

import UIKit
import CoreData
import LocalAuthentication

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
        //1.初始化TouchID句柄
        let authentication = LAContext()
        var error: NSError?
        
        //2.检查Touch ID是否可用
        let isAvailable = authentication.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                                           error: &error)
        
        //3.处理结果
        if isAvailable
        {
            NSLog("Touch ID is available")
            //这里是采用认证策略 LAPolicy.DeviceOwnerAuthenticationWithBiometrics
            //--> 指纹生物识别方式
            authentication.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "这里需要您的指纹来进行识别验证", reply: {
                //当调用authentication.evaluatePolicy方法后，系统会弹提示框提示用户授权
                (success, error) -> Void in
                if success
                {
                    self.recordAction()
                    NSLog("您通过了Touch ID指纹验证！")
                }
                else
                {
                    //上面提到的指纹识别错误
                    NSLog("您未能通过Touch ID指纹验证！错误原因：\n\(error)")
                }
            })
        }
        else
        {
            //上面提到的硬件配置
            NSLog("Touch ID不能使用！错误原因：\n\(error)")
        }
    }
    
    
    func recordAction() -> Void {
        
        DispatchQueue.main.async(execute: {
            let breakupDataVC = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "RecordDataTableViewController") as! RecordDataTableViewController
            self.navigationController?.pushViewController(breakupDataVC, animated: true)
        })
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


