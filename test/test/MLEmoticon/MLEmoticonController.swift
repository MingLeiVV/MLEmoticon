//
//  MLEmoticonController.swift
//  MLEmoticon
//
//  Created by 吴明磊 on 15/5/6.
//  Copyright © 2015年 wuminglei. All rights reserved.
//

import UIKit
private let EmoticonCellIdentifier = "EmoticonCellIdentifier"
class MLEmoticonController: UIViewController {

    
    let selectEmoticonCallBack : (emoticon : Emoticons?) ->()
    
    init(selectEmoticon : (emoticon : Emoticons?) ->()) {
    
        selectEmoticonCallBack = selectEmoticon
        super.init(nibName: nil, bundle: nil)
    }



    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let index = NSIndexPath(forItem: 0, inSection: 1)
        emoticonView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK: 监听方法 
    func emoticonSwitch (sender : UIBarButtonItem) {
    
        let indexPath = NSIndexPath(forItem: 0, inSection: sender.tag)
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
    }
    
    
    
    //MARK: 设置UI
    private func setupUI () {
    
        view.addSubview(toolBar)
        view.addSubview(emoticonView)
        prepareTooBar()
        prepareCollectionView()
        toolBar.ml_AlignInner(type: ml_AlignType.BottomCenter, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 49))
        emoticonView.ml_AlignInner(type: ml_AlignType.TopLeft, referView: view, size: nil)
        emoticonView.ml_AlignVertical(type: ml_AlignType.TopRight, referView: toolBar, size: nil)

    }
    /// 准备toolBar
    private func prepareTooBar () {
    
        var item = [UIBarButtonItem]()
        var index = 0
        for emoticons in emoticonPackage {
        
            let btn = UIBarButtonItem(title: emoticons.group_name_cn, style: UIBarButtonItemStyle.Plain, target: self, action: "emoticonSwitch:")
           
            btn.tag = index++
            
            btn.tintColor = UIColor.lightGrayColor()
            item.append(btn)
            item.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        
        item.removeLast()
        toolBar.items = item
        
        
    }
    /// 准备collectionView
    private func prepareCollectionView () {
    
        emoticonView.dataSource = self
        emoticonView.delegate = self
        emoticonView.registerClass(MLEmoticonCell.self, forCellWithReuseIdentifier: EmoticonCellIdentifier)
        
        
    }
    
    private lazy var emoticonPackage : [MLEmoticon] = MLEmoticon.emoticonPage
    private lazy var toolBar = UIToolbar()
    private lazy var emoticonView = UICollectionView(frame: CGRectZero, collectionViewLayout: MLCollectionFlowLayout())
    
    
     private lazy var emoticonBtn : UIButton = UIButton()
    
    
   }

//MARK: 自定义cell
private class MLEmoticonCell : UICollectionViewCell{
    
    var emoticons : Emoticons? {
        
        didSet{
            
            setup()
        }
    }
    private func setup () {
        
        contentView.addSubview(emoticonBtn)
        
        
        emoticonBtn.ml_Fill(contentView)
        

        emoticonBtn.setImage(UIImage(named: emoticons!.imagePath!), forState: UIControlState.Normal)
        
        
        emoticonBtn.setTitle(emoticons!.emoj, forState: UIControlState.Normal)
        
    }
    private lazy var emoticonBtn : UIButton = {
        
        let btn = UIButton()
        
        btn.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        btn.userInteractionEnabled = false
        
        return btn
        
        }()
}

//MARK: 扩展类、collectionview的数据源方法
extension MLEmoticonController : UICollectionViewDataSource,UICollectionViewDelegate {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return emoticonPackage.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emoticonPackage[section].emoticons?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmoticonCellIdentifier, forIndexPath: indexPath) as! MLEmoticonCell
        
        cell.emoticons = emoticonPackage[indexPath.section].emoticons?[indexPath.item]


        
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let selectEmoticon = emoticonPackage[indexPath.section].emoticons?[indexPath.item]
        
        selectEmoticonCallBack(emoticon: selectEmoticon)
        

        if indexPath.section > 0 {
        
            MLEmoticon.addEmoticon(selectEmoticon!)
        }
    }

}
//MARK: 流式布局
private class MLCollectionFlowLayout : UICollectionViewFlowLayout {
    
    private override func prepareLayout() {
        let WH  = UIScreen.mainScreen().bounds.width / 7
        collectionView?.backgroundColor = UIColor.whiteColor()
        let set = (collectionView!.bounds.height - 3 * WH) * 0.499
        itemSize = CGSize(width: WH, height: WH)
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.contentInset = UIEdgeInsets(top: set, left: 0, bottom: set, right: 0)
        collectionView?.pagingEnabled = true
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
    }
}


