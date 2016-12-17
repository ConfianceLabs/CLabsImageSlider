//
//  CLabsImageSlider.swift
//  Pods
//
//  Created by apple on 18/09/16.
//
//

import UIKit


@objc public protocol imageSliderDelegate {
    
    func didMovedToIndex(index:Int)
    
    
}


@objc public protocol updateUI {
    func imageUpdate(index:Int)
}



public class CLabsImageSlider:UIView,updateUI
{
    
    public enum imageSrc
    {
        case Url(imageArray:[String],placeHolderImage:UIImage?)
        case Local(imageArray:[String])
    }
    
    public enum slideCase
    {
        case ManualSwipe
        case Automatic(timeIntervalinSeconds:Double)
    }
    
    
    
    var imageSourceArray    =   [imageData]()
    var isAnimating =   false
    var isGestureEnabled    =   Bool()
    var visibleImageView    =   UIImageView()
    var imageView1  =   UIImageView()
    var imageView2  =   UIImageView()
    var imageView3  =   UIImageView()
    var currentIndex    =   Int()
    var placeHolderImage    =   UIImage()
    var isLocalImage =  Bool()
    
    
    public weak var sliderDelegate  :   imageSliderDelegate?
    
    
    
    var rightFrame  :CGRect
    {
        return CGRect(x:self.frame.size.width, y:0, width:self.frame.size.width, height:self.frame.size.height)
    }
    
    var midFrame    :   CGRect
    {
        return CGRect(x:0, y:0,width: self.frame.size.width,height: self.frame.size.height)
    }
    
    var leftFrame   :   CGRect
    {
        return CGRect(x:-self.frame.size.width,y:0, width:self.frame.size.width, height:self.frame.size.height)
    }
    
    
    var leftSwipe : UISwipeGestureRecognizer
    {
        let leftSwipe   =   UISwipeGestureRecognizer(target: self, action: #selector(CLabsImageSlider.swipeRight(swipeGesture:)))
        leftSwipe.direction =   .left
        return leftSwipe
    }
    
    var rightSwipe : UISwipeGestureRecognizer
    {
        
        return UISwipeGestureRecognizer(target: self, action: #selector(CLabsImageSlider.swipeLeft(swipeGesture:)))
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    
    
    
    /**
     This function set up the image slider for you just pass few required parameters to it
     - returns: Nothing
     - parameter imageSource: to show images from url use -> .Url(imageArray [String],placeHolderImage:UIImage?) and provide url array and placeholder image in paranthesis , to show local images use -> .Local(imageArray:[String]) and provide local image names array in paranthesis
     
     - parameter slideType: to  slide images automatically use -> .Automatic(timeIntervalinSeconds:Double) and provide time interval(Seconds) in parantheseis , to swipe and slide images manually simply use -> .ManualSwipe
     
     - parameter isArrowBtnEnabled:Bool to show arrows to slide images backward and forward pass true else false
     Throws : nothing
     */
    public func setUpView(imageSource:imageSrc,slideType:slideCase,isArrowBtnEnabled:Bool)
    {
        switch imageSource{
        case .Local(let images):
            prepareImageSource(images: images)
            isLocalImage    =   true
            
        case .Url(let images,let placeholderImg):
            placeHolderImage    =   placeholderImg!
            prepareImageSource(images: images)
            isLocalImage    =   false
        }
        
        
        
        
        switch slideType{
        case .Automatic(let timer):
            isGestureEnabled=false
            Timer.scheduledTimer(timeInterval: timer, target: self, selector: #selector(CLabsImageSlider.moveRight), userInfo: nil, repeats: true)
            
        case .ManualSwipe:
            isGestureEnabled=true
            if imageSourceArray.count>1
            {
                imageView2.addGestureRecognizer(leftSwipe)
                imageView2.addGestureRecognizer(rightSwipe)
                
            }
            
        }
        
        
        
        
        imageView1.frame   =   leftFrame
        imageView1.tag  =   1
        imageView1.isUserInteractionEnabled   =  true
        imageView1.contentMode  =   .scaleToFill
        self.addSubview(imageView1)
        
        
        
        imageView2.frame   =   midFrame
        imageView2.tag  =   2
        imageView2.contentMode  =   .scaleToFill
        imageView2.isUserInteractionEnabled   =  true
        visibleImageView    =   imageView2
        
        if imageSourceArray.count > 0
        {
            imageView2.image    =   getImage(index: 0)
        }
        self.addSubview(imageView2)
        
        
        imageView3.frame    =   rightFrame
        imageView3.tag  =   3
        imageView3.contentMode  =   .scaleToFill
        imageView3.isUserInteractionEnabled   =  true
        self.addSubview(imageView3)
        
        
        if imageSourceArray.count>1{
            if isArrowBtnEnabled{
            enableArrows()
            }
        }
        
    }
    
    
    @objc  func moveRight()
    {
        if !isAnimating{
            currentIndex    =   currentIndex    +   1
            if currentIndex ==   imageSourceArray.count{currentIndex    =   0}
            visibleImageView.removeGestureRecognizer(leftSwipe)
            visibleImageView.removeGestureRecognizer(rightSwipe)
            startImageDownload(index: currentIndex)
            swipeRightAnimate(condition: visibleImageView.tag)
            self.sliderDelegate?.didMovedToIndex(index: currentIndex)
        }
    }
    
    
    @objc  func moveLeft()
    {
        if !isAnimating{
            currentIndex    =   currentIndex    -   1
            if currentIndex < 0{currentIndex    =   imageSourceArray.count    -   1}
            visibleImageView.removeGestureRecognizer(leftSwipe)
            visibleImageView.removeGestureRecognizer(rightSwipe)
            startImageDownload(index: currentIndex)
            swipeLeftAnimate(condition: visibleImageView.tag)
            self.sliderDelegate?.didMovedToIndex(index: currentIndex)
        }
    }
    
    
    
    
    @objc  func swipeLeft(swipeGesture:UISwipeGestureRecognizer)
    {
        moveLeft()
    }
    
    
    
    
    func swipeLeftAnimate(condition:Int)
    {
        isAnimating=true
        switch condition {
        case 1:
            self.visibleImageView    =   self.imageView3
            imageView3.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView2.isHidden  =   true
                self.imageView1.frame    =   self.rightFrame
                self.imageView2.frame    =   self.leftFrame
                self.imageView3.frame    =   self.midFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    
                    
                    
                    if self.isGestureEnabled{
                        self.imageView3.addGestureRecognizer(self.leftSwipe)
                        self.imageView3.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView2.isHidden  =   false
                    self.isAnimating=false
                })
            
        case 2:
            self.visibleImageView    =   self.imageView1
            imageView1.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView3.isHidden  =   true
                self.imageView1.frame    =   self.midFrame
                self.imageView2.frame    =   self.rightFrame
                self.imageView3.frame    =   self.leftFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView1.addGestureRecognizer(self.leftSwipe)
                        self.imageView1.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView3.isHidden  =   false
                    self.isAnimating=false
                })
            
        case 3:
            self.visibleImageView    =   self.imageView2
            imageView2.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView1.isHidden  =   true
                self.imageView1.frame    =   self.leftFrame
                self.imageView2.frame    =   self.midFrame
                self.imageView3.frame    =   self.rightFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView2.addGestureRecognizer(self.leftSwipe)
                        self.imageView2.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView1.isHidden  =   false
                    self.isAnimating=false
                })
            
        default:
            break
        }
        
    }
    
    
    
    
    @objc  func swipeRight(swipeGesture:UISwipeGestureRecognizer)
    {
        moveRight()
    }
    
    
    
    func swipeRightAnimate(condition:Int){
        isAnimating=true
        switch condition {
        case 1:
            self.visibleImageView    =   self.imageView2
            imageView2.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView3.isHidden  =   true
                self.imageView1.frame    =   self.leftFrame
                self.imageView2.frame    =   self.midFrame
                self.imageView3.frame    =   self.rightFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView2.addGestureRecognizer(self.leftSwipe)
                        self.imageView2.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView3.isHidden  =   false
                    self.isAnimating=false
                })
            
        case 2:
            self.visibleImageView    =   self.imageView3
            imageView3.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView1.isHidden  =   true
                self.imageView1.frame    =   self.rightFrame
                self.imageView2.frame    =   self.leftFrame
                self.imageView3.frame    =   self.midFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView3.addGestureRecognizer(self.leftSwipe)
                        self.imageView3.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView1.isHidden  =   false
                    self.isAnimating=false
                })
            
        case 3:
            self.visibleImageView    =   self.imageView1
            imageView1.image    =   getImage(index: currentIndex)
            UIView.animate(withDuration: 0.5, animations: {
                self.imageView2.isHidden  =   true
                self.imageView1.frame    =   self.midFrame
                self.imageView2.frame    =   self.rightFrame
                self.imageView3.frame    =   self.leftFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView1.addGestureRecognizer(self.leftSwipe)
                        self.imageView1.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView2.isHidden  =   false
                    self.isAnimating=false
                })
        default: break
            
        }
        
    }
    
    
    
    func prepareImageSource(images:[String]){
        
        for i in 0..<images.count
        {
            let img =   imageData(url: images[i],index: i)
            img.delegate=self
            imageSourceArray.append(img)
            if i < 2 {
                img.downloadImage()
            }
        }
        
    }
    
    func startImageDownload(index:Int)
    {
        
        if !imageSourceArray[index].isLoaded
        {
            imageSourceArray[index].downloadImage()
            
            if index < imageSourceArray.count-1
            {
                if !imageSourceArray[index+1].isLoaded
                {
                    imageSourceArray[index+1].downloadImage()
                    
                }
            }
        }
        
    }
    
    
    public func imageUpdate(index:Int)
    {
        
        if index    ==  currentIndex
        {
            visibleImageView.image  =   getImage(index: currentIndex)
        }
        
    }
    
    func getImage(index:Int) -> UIImage?
    {
        
        if isLocalImage{
            return UIImage(named: imageSourceArray[index].imageUrl)
        }
        else
        {
            
            if imageSourceArray[index].image != nil
            {
                return imageSourceArray[index].image
            }
            else
            {
                return placeHolderImage
            }
            
        }
    }
    
    
    func enableArrows()
    {
        let shape   =  CAShapeLayer()
        let path    =   UIBezierPath()
        path.move(to: CGPoint(x:self.frame.size.width-16, y:self.frame.size.height/2-10))
        path.addLine(to: CGPoint(x:self.frame.size.width-8,y: self.frame.size.height/2))
        path.addLine(to: CGPoint(x:self.frame.size.width-16,y: self.frame.size.height/2+10))
        shape.lineWidth =   2.0
        shape.path=path.cgPath;
        shape.fillColor=UIColor.clear.cgColor
        shape.strokeColor   =   UIColor.white.withAlphaComponent(0.7).cgColor
        self.layer.addSublayer(shape)
        
        
        let shape1   =  CAShapeLayer()
        let path1    =   UIBezierPath()
        path1.move(to: CGPoint(x:self.frame.size.width-18, y:self.frame.size.height/2-10))
        path1.addLine(to: CGPoint(x:self.frame.size.width-10,y: self.frame.size.height/2))
        path1.addLine(to: CGPoint(x:self.frame.size.width-18, y:self.frame.size.height/2+10))
        shape1.lineWidth =   2.0
        shape1.path=path1.cgPath;
        shape1.fillColor=UIColor.clear.cgColor
        shape1.strokeColor   =   UIColor.black.withAlphaComponent(0.7).cgColor
        self.layer.addSublayer(shape1)
        
        
        let shape2   =  CAShapeLayer()
        let path2    =   UIBezierPath()
        path2.move(to: CGPoint(x:16, y:self.frame.size.height/2-10))
        path2.addLine(to: CGPoint(x:8, y:self.frame.size.height/2))
        path2.addLine(to: CGPoint(x:16, y:self.frame.size.height/2+10))
        shape2.lineWidth =   2.0
        shape2.path=path2.cgPath;
        shape2.fillColor=UIColor.clear.cgColor
        shape2.strokeColor   =   UIColor.white.withAlphaComponent(0.7).cgColor
        self.layer.addSublayer(shape2)
        
        
        let shape3   =  CAShapeLayer()
        let path3    =   UIBezierPath()
        path3.move(to: CGPoint(x:18, y:self.frame.size.height/2-10))
        path3.addLine(to: CGPoint(x:10, y:self.frame.size.height/2))
        path3.addLine(to: CGPoint(x:18, y:self.frame.size.height/2+10))
        shape3.lineWidth =   2.0
        shape3.path=path3.cgPath;
        shape3.fillColor=UIColor.clear.cgColor
        shape3.strokeColor   =   UIColor.black.withAlphaComponent(0.7).cgColor
        self.layer.addSublayer(shape3)
        
        let leftBtn    =   UIButton()
        leftBtn.frame  =   CGRect(x:6,y: self.frame.size.height/2-15,width: 20,height: 30)
        leftBtn.addTarget(self, action: #selector(CLabsImageSlider.moveLeft), for: .touchUpInside)
        self.addSubview(leftBtn)
        
        let rightBtn    =   UIButton()
        rightBtn.frame  =   CGRect(x:self.frame.size.width-26, y:self.frame.size.height/2-15,width: 20, height:30)
        rightBtn.addTarget(self, action: #selector(CLabsImageSlider.moveRight), for: .touchUpInside)
        self.addSubview(rightBtn)
        
    }
    
    
    
    
    
    
}








public class imageData {
    
    var image   :   UIImage?    =   nil
    var index   :   Int
    var isLoaded    =   Bool()
    var imageUrl    :   String
    var isloading   =   Bool()
    public var delegate    :   updateUI?    =   nil
    
    
    
    init(url:String,index:Int)
    {
        imageUrl    =   url
        self.index   =   index
    }
    
    
    
    public func downloadImage()
    {
        
        if !isloading{
            
            isloading   =   true
            
            if let imageUrl  =  NSURL(string:imageUrl)
            {
                
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let data =   NSData(contentsOf:imageUrl as URL)
                    DispatchQueue.main.async {
                        if let imageBytes    =   data
                        {
                            self.image   =   UIImage(data: imageBytes as Data)
                            self.isLoaded   =   true
                            self.delegate?.imageUpdate(index: self.index)
                            
                        }
                        else
                        {
                            
                            self.isloading   =   false
                            
                        }
                        
                    }
                }
                
                //                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                //                dispatch_async(backgroundQueue, {
                //
                //                    let data =   NSData(contentsOfURL:imageUrl)
                //
                //                    dispatch_async(dispatch_get_main_queue(), {[unowned self] () -> Void in
                //
                //                        if let imageBytes    =   data
                //                        {
                //                            self.image   =   UIImage(data: imageBytes)
                //                            self.isLoaded   =   true
                //                            self.delegate?.imageUpdate(self.index)
                //
                //                        }
                //                        else
                //                        {
                //                            
                //                            self.isloading   =   false
                //                            
                //                        }
                //                        })
                //                })
                
                
            }
        }
    }
    
    
}
