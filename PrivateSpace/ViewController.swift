//
//  ViewController.swift
//  PrivateSpace
//
//  Created by 李勇 on 2016/12/27.
//  Copyright © 2016年 ly. All rights reserved.
//

//https://www.jianshu.com/p/a9c64ac2c586
import UIKit
import CoreData
import LocalAuthentication
import Speech
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var contentTF: UITextView!
    @IBOutlet weak var savaBtn: UIButton!
    @IBOutlet weak var speekImgV: UIImageView!
    
    fileprivate var speechRecognizer : SFSpeechRecognizer? {
        get{
            let local = Locale.init(identifier: "zh_CN")
            let reco = SFSpeechRecognizer.init(locale: local)
            return reco
        }
    }
    fileprivate var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    fileprivate var recognitionTask : SFSpeechRecognitionTask?
    fileprivate let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addTapAction()
        self.speechRecognizer?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareSpeech()
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
                    NSLog("您未能通过Touch ID指纹验证！错误原因：\n\(String(describing: error))")
                }
            })
        }
        else
        {
            //上面提到的硬件配置
            NSLog("Touch ID不能使用！错误原因：\n\(String(describing: error))")
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
        let timeZone = TimeZone(secondsFromGMT: +28800)
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
    
    
    //手势
    func addTapAction() {
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(ViewController.longPressAction(_:)))
        longPress.minimumPressDuration = 0.3
        self.speekImgV.addGestureRecognizer(longPress)
    }
    //手势处理
    func longPressAction(_ pan : UILongPressGestureRecognizer) {
        switch pan.state {
        case .began:
            //开始
            if self.audioEngine.isRunning{
                self.audioEngine.stop()
                if self.recognitionRequest != nil{
                    self.recognitionRequest?.endAudio()
                }
            }
            self.startRecording()
            self.speekImgV.image = #imageLiteral(resourceName: "speeking")
        case .cancelled:
            //取消
            print("cancelled")
        case .changed:
            //
            let _ = 1
//            print("changed")
        case .ended:
            //结束
            self.speekImgV.image = #imageLiteral(resourceName: "speek")
            self.audioEngine.stop()
            if self.recognitionRequest != nil{
                self.recognitionRequest?.endAudio()
            }
        case .failed:
            //失败
            print("failed")
        case .possible:
            //
            print("possible")
        }
    }
    //
    func prepareSpeech(){
        SFSpeechRecognizer.requestAuthorization { (hander) in
            switch hander{
            case .notDetermined:
                //语音识别未授权
                print("语音识别未授权")
            case .denied:
                //用户未授权使用语音识别
                print("用户未授权使用语音识别")
            case .restricted:
                //语音识别在这台设备上受到限制
                print("语音识别在这台设备上受到限制")
            case .authorized:
                //开始录音
                print("开始录音")
            }
        }
    }
    
    func startRecording() {
        if self.recognitionTask != nil{
            self.recognitionTask?.cancel()
            self.recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
        } catch {
        }
        
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let inputNode = self.audioEngine.inputNode else {
            return
        }
        self.recognitionRequest?.shouldReportPartialResults = true
        self.recognitionTask = self.speechRecognizer?.recognitionTask(with: self.recognitionRequest!, resultHandler: { (result, error) in
            var isFinal = false
            if result != nil{
                isFinal = result!.isFinal
                if isFinal{
                    if self.titleTF.isFirstResponder{
                        self.titleTF.text = self.titleTF.text! + result!.bestTranscription.formattedString
                    }else{
                       self.contentTF.text = self.contentTF.text + result!.bestTranscription.formattedString
                    }
                }
            }
            
            if error != nil || isFinal{
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionTask = nil
                self.recognitionRequest = nil
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            if self.recognitionRequest != nil{
                self.recognitionRequest?.append(buffer)
            }
        }
        self.audioEngine.prepare()
        do {
            try self.audioEngine.start()
        } catch  {
        }
    }
}

extension ViewController : SFSpeechRecognizerDelegate{
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            print("begin record")
        }else{
            print("unkonw")
        }
    }
}
