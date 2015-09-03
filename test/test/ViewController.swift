//
//  ViewController.swift
//  test
//
//  Created by 吴明磊 on 15/5/6.
//  Copyright © 2015年 wuminglei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
 private lazy var emoticonVC: MLEmoticonController = MLEmoticonController {[weak self] (emoticon) -> () in
    
    if emoticon != nil {
        
        self?.selectEmoticon(emoticon!)
        
    }
    }
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        textView.inputView = emoticonVC.view
        
        
    }

  
    
    
    private func selectEmoticon (emoticon : Emoticons) {
    
        textView.insertEmoticon(emoticon)
        
        
    }
}

