//
//  ViewController.swift
//  CodeView
//
//  Created by Nino on 16/1/21.
//  Copyright © 2016年 HRoot. All rights reserved.
//


import UIKit

class ViewController: UIViewController
{
    let fileManager = FileManager.default
    //文件管理
    
    @IBOutlet weak var GenerateNumber: UISlider!
    @IBAction func Generate(_ sender: Any) {
        var image:UIImage?
        
        //批量生成
        let num = GenerateNumber.value
        
        //保存图片
        var paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString)
        paths = paths.appending("/dstImages") as (NSString)
        print(paths)
        //输出文件夹为dstImages，在其中创建pathName的文件夹
        if !fileManager.fileExists(atPath: paths as String){
            //创建文件夹
            try! fileManager.createDirectory(atPath: paths as String, withIntermediateDirectories: true, attributes: nil)
        }else{
            print("Dictionary already exists.")
        }
        
        for idx in 0 ..< Int(num)
        {
            self.codeView.setNeedsDisplay()//刷新captcha
            self.codeView.getChangeCode()
            let newPaths = paths.appendingPathComponent("Num"+String(idx)+"_"+self.codeView.changeString!+".jpg") as (NSString)
            //设置文件名字
            image = self.codeView.screenShot()//截图获取
            
            let imageData = UIImageJPEGRepresentation(image!, 0.5)
            //保存为JPG，第二个参数为质量
            fileManager.createFile(atPath: newPaths as String, contents: imageData, attributes: nil)
        }
        let alertController = UIAlertController(title: "生成完毕", message: "", preferredStyle: UIAlertControllerStyle.alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型

        let alertView = UIAlertAction(title: "确定", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in }
        alertController.addAction(alertView)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var PrintCaptcha: UILabel!
    @IBOutlet weak var codeView: CodeView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func buttonClicked(_ sender: AnyObject)
    {
        let str1 = textField.text
        var str2 = codeView.changeString

        let result = str1!.range(of: str2!, options: NSString.CompareOptions.caseInsensitive)
        if(result == nil) //验证码不正确
        {
            let alertController = UIAlertController(title: "验证码不正确", message: "请选择", preferredStyle: UIAlertControllerStyle.alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型
            let alertView1 = UIAlertAction(title: "再试一次", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in }
            let alertView2 = UIAlertAction(title: "取消,下一张", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                self.codeView.getChangeCode()
                self.codeView.setNeedsDisplay()
                str2 = self.codeView.changeString
                self.PrintCaptcha.text = "Captcha:"+str2!
            }
            alertController.addAction(alertView1)
            alertController.addAction(alertView2)
            self.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "验证码正确", message: "请选择", preferredStyle: UIAlertControllerStyle.alert) // 这里因为控件都不存在改变的可能，所以一律使用let类型
            let alertView1 = UIAlertAction(title: "确定，再看看", style: UIAlertActionStyle.default) { (UIAlertAction) -> Void in }
            let alertView2 = UIAlertAction(title: "下一张", style: UIAlertActionStyle.cancel) { (UIAlertAction) -> Void in
                self.codeView.getChangeCode()
                self.codeView.setNeedsDisplay()
                str2 = self.codeView.changeString
                self.PrintCaptcha.text = "Captcha:"+str2!
            }
            alertController.addAction(alertView1)
            alertController.addAction(alertView2)
            self.present(alertController, animated: true, completion: nil)
        }
        PrintCaptcha.text = "Captcha:"+str2!
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        PrintCaptcha.text = "Captcha:"+codeView.changeString!
    }
}

