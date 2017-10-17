//
//  CodeView.swift
//  CodeView
//
//  Created by Nino on 16/1/21.
//  Copyright © 2016年 HRoot. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Get the view's screen shot, this function may be called from any thread of your app.
     
     - returns: The screen shot's image.
     */
    func screenShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

class CodeView: UIView
{
    
    var changeString:String? //验证码的字符串pic
    
    let kLineCount = 6
    let kLineWidth = CGFloat(2.0)
    let kCharCount = 4
    var kFontSize = UIFont.systemFont(ofSize: 5*CGFloat(arc4random() % 5) + 15)

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        let randomColor:UIColor = UIColor(red: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), alpha: 0.5)
        
        self.layer.cornerRadius = 5.0   //设置layer圆角半径
        self.layer.masksToBounds = true //隐藏边界
        self.backgroundColor = randomColor
        
        self.getChangeCode()
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.getChangeCode()
    }
    
    func getChangeCode()
    {
        //字符素材数组
        let changeArray:NSArray = ["0","1","2","3","4","5","6","7","8","9"]//,"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        
        self.changeString = ""
        //随机从数组中选取需要个数的字符，然后拼接为一个字符串
        for _ in 0 ..< kCharCount
        {
            let index = Int(arc4random())%(changeArray.count - 1)
            let getStr = changeArray.object(at: index)
            self.changeString = self.changeString! + (getStr as! String)
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        let randomBackColor = UIColor(red: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), alpha: 1.0)
        self.backgroundColor = randomBackColor
        
        //获得要显示验证码字符串，根据长度，计算每个字符显示的大概位置
        let str = NSString(string: "S")
        let size = str.size(attributes: [NSFontAttributeName : kFontSize])
        let width = rect.size.width / CGFloat(NSString(string: changeString!).length) - size.width
        let height = rect.size.height - size.height
        var point:CGPoint?
        var pX:CGFloat?
        var pY:CGFloat?
        
        for i in 0 ..< NSString(string: changeString!).length
        {
            pX = CGFloat(arc4random()).truncatingRemainder(dividingBy: width) + rect.size.width / CGFloat(NSString(string: changeString!).length)*CGFloat(i)
            pY = CGFloat(arc4random()).truncatingRemainder(dividingBy: height)
            point = CGPoint(x: pX!, y: pY!)
            let c = NSString(string: changeString!).character(at: i)
            
            let codeText:NSString? = NSString(format: "%C",c)
            kFontSize = UIFont.systemFont(ofSize: 5*CGFloat(arc4random() % 5) + 20)
            //重新计算字体大小
            codeText!.draw(at: point!, withAttributes: [NSFontAttributeName : kFontSize])
        }
    
        //调用drawRect：之前，系统会向栈中压入一个CGContextRef，调用UIGraphicsGetCurrentContext()会取栈顶的CGContextRef
        let context :CGContext = UIGraphicsGetCurrentContext()!
        //设置画线宽度
        context.setLineWidth(kLineWidth)
        
        for _ in 0 ..< kLineCount
        {
            //绘制干扰的彩色直线
            let randomLineColor = UIColor(red: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), green: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), blue: CGFloat(CGFloat(arc4random())/CGFloat(RAND_MAX)), alpha: 0.5)
            context.setStrokeColor(randomLineColor.cgColor)
            //设置线的起点
            pX = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
            pY = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
            context.move(to: CGPoint(x: pX!, y: pY!))
            //设置线终点
            pX = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.width)
            pY = CGFloat(arc4random()).truncatingRemainder(dividingBy: rect.size.height)
            context.addLine(to: CGPoint(x: pX!, y: pY!))
            //画线
            context.strokePath()
        }
    }
    
}
