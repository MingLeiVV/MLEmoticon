//
//  MLEmoticon.swift
//  MLEmoticon
//
//  Created by 吴明磊 on 15/5/6.
//  Copyright © 2015年 wuminglei. All rights reserved.
//

import UIKit
private let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons", ofType: "bundle")
private let favorateID = "favorateID"

class MLEmoticon: NSObject {

    var id = String()
    
    var group_name_cn : String?
    var emoticons :  [Emoticons]?
    
     init(package : String) {
        super.init()
    
        id = package
    
    }
    init(group_name : String) {
       
       group_name_cn = group_name
    }
    
    
  
    class  func addEmoticon (favorateEmoticon : Emoticons) {
    
        if favorateEmoticon.removeBtn == true {
        
            return
        }
        
     var emoticonGroup = emoticonPage[0].emoticons
    
    if favorateEmoticon.haveID == nil {
    
        // 删除最后一个，防止数据越界
        emoticonGroup?.removeLast()
        emoticonGroup?.removeLast()
        // 做一个添加的标识
        favorateEmoticon.haveID = favorateID
        
        emoticonGroup?.append(favorateEmoticon)
        
        emoticonGroup?.append(Emoticons(remove: true))
        
    }
  

        favorateEmoticon.favorate++
    
    
        // 排序
    
    // 排序简写
      emoticonGroup = emoticonGroup?.sort {
        
            return $0.favorate > $1.favorate // $0 --代表第一个数  $1 --- 代表第二个数
        }
    
      emoticonPage[0].emoticons = emoticonGroup
    
    }
    
    static let emoticonPage = MLEmoticon.loadPackages()
    
    private class func loadPackages() -> [MLEmoticon] {
    
        let packages = NSDictionary(contentsOfFile: bundlePath!.stringByAppendingPathComponent("emoticons.plist"))
        
        var emoticon = [MLEmoticon]()
        emoticon.append(MLEmoticon(group_name: "最近AA").addRemoveBtn())
        for dict in packages!["packages"] as! [[String : AnyObject]] {
            
            let str = dict["id"] as! String
            
            let array = MLEmoticon(package: str).loadEmoticons().addRemoveBtn()
            
            emoticon.append(array)
        }
        
        return emoticon
    }
      
    
    private func loadEmoticons () -> Self {
    
      let emoticonDict =  NSDictionary(contentsOfFile: bundlePath!.stringByAppendingPathComponent(id).stringByAppendingPathComponent("info.plist"))
        
        if let group_name = emoticonDict!["group_name_cn"]{
        
            group_name_cn = group_name as! String
        }
        var emoticon = [Emoticons]()
        var count = 1
        for dict in emoticonDict!["emoticons"] as! [[String : AnyObject]]{
        
            if count % 21 == 0 {
            
               emoticon.append(Emoticons(remove: true))
                count++
            }
            
            emoticon.append(Emoticons(id: id, dict: dict))
            count++
        }
        
        emoticons = emoticon
        
        
        return self
    }
    
   private func addRemoveBtn () -> Self{
    

    if emoticons == nil {   // 最近分组
        emoticons = [Emoticons]()
    }
    let count = emoticons!.count % 21
    
    if count > 0 || count == 0 {
    
        for _ in count..<20 {
        
            emoticons!.append(Emoticons(remove: false))
        }
            emoticons!.append(Emoticons(remove: true))

        
    }
    
    return self
    }
    
    
}

class Emoticons : NSObject{
    // 镖旗id
    var ids = String()
    // emoj表情十六进制
    var code : String? {
    
        didSet{
        
            let scanner = NSScanner(string: code!)
            
            var vaule = UInt32()
            
            scanner.scanHexInt(&vaule)
            
            emoj = String(Character(UnicodeScalar(vaule)))
        }
    }
    // 与网络进行传输的字符串
    var chs : String?
    // 显示给用户的png
    var png : String?
    // 用户最近热爱的表情
    var favorate = 0
    var haveID : String?
    // 计算型属性，返回图片url
    var imagePath : String? {
    
        if removeBtn == false {
        
            return ""
        }
        if removeBtn == nil && chs == nil {
        
            return ""
        }
        if removeBtn == true {
        
            return bundlePath!.stringByAppendingPathComponent("Preset").stringByAppendingPathComponent("compose_emotion_delete_highlighted");
            
        }
        return  bundlePath?.stringByAppendingPathComponent(ids).stringByAppendingPathComponent(png!)

        
    }
     // emoj图
    var emoj : String?
    // 删除按钮标记
    var removeBtn : Bool?
    override init() {
        
    }
    
    init(remove : Bool) {
    
        removeBtn = remove
    }
    
    init(id : String , dict : [String : AnyObject]) {
        ids = id
        super.init()
        setValuesForKeysWithDictionary(dict)

        
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
