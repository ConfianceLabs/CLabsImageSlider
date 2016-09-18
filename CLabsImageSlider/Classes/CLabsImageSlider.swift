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
     var placeHolderImage    =   UIImage?()
     var isLocalImage =  Bool()
    
   
    public weak var sliderDelegate  =   imageSliderDelegate?()
    
   
    
      var rightFrame  :CGRect
    {
        return CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)
    }
    
     var midFrame    :   CGRect
    {
        return CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
    }
    
     var leftFrame   :   CGRect
    {
        return CGRectMake(-self.frame.size.width,0, self.frame.size.width, self.frame.size.height)
    }
    
    
     var leftSwipe : UISwipeGestureRecognizer
    {
        let leftSwipe   =   UISwipeGestureRecognizer(target: self, action: #selector(CLabsImageSlider.swipeRight(_:)))
        leftSwipe.direction =   .Left
        return leftSwipe
    }
    
     var rightSwipe : UISwipeGestureRecognizer
    {
        
        return UISwipeGestureRecognizer(target: self, action: #selector(CLabsImageSlider.swipeLeft(_:)))
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
              prepareImageSource(images)
              isLocalImage    =   true
            
        case .Url(let images,let placeholderImg):
              placeHolderImage    =   placeholderImg
              prepareImageSource(images)
              isLocalImage    =   false
            }
        
       
        
        
        switch slideType{
        case .Automatic(let timer):
              isGestureEnabled=false
              NSTimer.scheduledTimerWithTimeInterval(timer, target: self, selector: #selector(CLabsImageSlider.moveRight), userInfo: nil, repeats: true)
            
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
        imageView1.userInteractionEnabled   =  true
        imageView1.contentMode  =   .ScaleToFill
        self.addSubview(imageView1)
        
        
        
        imageView2.frame   =   midFrame
        imageView2.tag  =   2
        imageView2.contentMode  =   .ScaleToFill
        imageView2.userInteractionEnabled   =  true
        visibleImageView    =   imageView2
        
        if imageSourceArray.count > 0
        {
            imageView2.image    =   getImage(0)
        }
        self.addSubview(imageView2)
        
        
        imageView3.frame    =   rightFrame
        imageView3.tag  =   3
        imageView3.contentMode  =   .ScaleToFill
        imageView3.userInteractionEnabled   =  true
        self.addSubview(imageView3)
        
        
        if imageSourceArray.count>1{
            enableArrows()
        }
    
    }

    
   @objc  func moveRight()
    {
        if !isAnimating{
            currentIndex    =   currentIndex    +   1
            if currentIndex ==   imageSourceArray.count{currentIndex    =   0}
            visibleImageView.removeGestureRecognizer(leftSwipe)
            visibleImageView.removeGestureRecognizer(rightSwipe)
            startImageDownload(currentIndex)
            swipeRightAnimate(visibleImageView.tag)
            self.sliderDelegate?.didMovedToIndex(currentIndex)
        }
    }
    
    
   @objc  func moveLeft()
    {
        if !isAnimating{
            currentIndex    =   currentIndex    -   1
            if currentIndex < 0{currentIndex    =   imageSourceArray.count    -   1}
            visibleImageView.removeGestureRecognizer(leftSwipe)
            visibleImageView.removeGestureRecognizer(rightSwipe)
            startImageDownload(currentIndex)
            swipeLeftAnimate(visibleImageView.tag)
            self.sliderDelegate?.didMovedToIndex(currentIndex)
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
            imageView3.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView2.hidden  =   true
                self.imageView1.frame    =   self.rightFrame
                self.imageView2.frame    =   self.leftFrame
                self.imageView3.frame    =   self.midFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView3.addGestureRecognizer(self.leftSwipe)
                        self.imageView3.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView2.hidden  =   false
                    self.isAnimating=false
                })
            
        case 2:
            self.visibleImageView    =   self.imageView1
            imageView1.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView3.hidden  =   true
                self.imageView1.frame    =   self.midFrame
                self.imageView2.frame    =   self.rightFrame
                self.imageView3.frame    =   self.leftFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView1.addGestureRecognizer(self.leftSwipe)
                        self.imageView1.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView3.hidden  =   false
                    self.isAnimating=false
                })
            
        case 3:
            self.visibleImageView    =   self.imageView2
            imageView2.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView1.hidden  =   true
                self.imageView1.frame    =   self.leftFrame
                self.imageView2.frame    =   self.midFrame
                self.imageView3.frame    =   self.rightFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView2.addGestureRecognizer(self.leftSwipe)
                        self.imageView2.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView1.hidden  =   false
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
            imageView2.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView3.hidden  =   true
                self.imageView1.frame    =   self.leftFrame
                self.imageView2.frame    =   self.midFrame
                self.imageView3.frame    =   self.rightFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView2.addGestureRecognizer(self.leftSwipe)
                        self.imageView2.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView3.hidden  =   false
                    self.isAnimating=false
                })
            
        case 2:
            self.visibleImageView    =   self.imageView3
            imageView3.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView1.hidden  =   true
                self.imageView1.frame    =   self.rightFrame
                self.imageView2.frame    =   self.leftFrame
                self.imageView3.frame    =   self.midFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView3.addGestureRecognizer(self.leftSwipe)
                        self.imageView3.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView1.hidden  =   false
                    self.isAnimating=false
                })
            
        case 3:
            self.visibleImageView    =   self.imageView1
            imageView1.image    =   getImage(currentIndex)
            UIView.animateWithDuration(0.5, animations: {
                self.imageView2.hidden  =   true
                self.imageView1.frame    =   self.midFrame
                self.imageView2.frame    =   self.rightFrame
                self.imageView3.frame    =   self.leftFrame
                
                }, completion: {[unowned self](finished:Bool) -> Void in
                    if self.isGestureEnabled{
                        self.imageView1.addGestureRecognizer(self.leftSwipe)
                        self.imageView1.addGestureRecognizer(self.rightSwipe)
                    }
                    self.imageView2.hidden  =   false
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
            visibleImageView.image  =   getImage(currentIndex)
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
        path.moveToPoint(CGPointMake(self.frame.size.width-16, self.frame.size.height/2-10))
        path.addLineToPoint(CGPointMake(self.frame.size.width-8, self.frame.size.height/2))
        path.addLineToPoint(CGPointMake(self.frame.size.width-16, self.frame.size.height/2+10))
        shape.lineWidth =   2.0
        shape.path=path.CGPath;
        shape.fillColor=UIColor.clearColor().CGColor
        shape.strokeColor   =   UIColor.whiteColor().colorWithAlphaComponent(0.7).CGColor
        self.layer.addSublayer(shape)
        
        
        let shape1   =  CAShapeLayer()
        let path1    =   UIBezierPath()
        path1.moveToPoint(CGPointMake(self.frame.size.width-18, self.frame.size.height/2-10))
        path1.addLineToPoint(CGPointMake(self.frame.size.width-10, self.frame.size.height/2))
        path1.addLineToPoint(CGPointMake(self.frame.size.width-18, self.frame.size.height/2+10))
        shape1.lineWidth =   2.0
        shape1.path=path1.CGPath;
        shape1.fillColor=UIColor.clearColor().CGColor
        shape1.strokeColor   =   UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
        self.layer.addSublayer(shape1)
        
        
        let shape2   =  CAShapeLayer()
        let path2    =   UIBezierPath()
        path2.moveToPoint(CGPointMake(16, self.frame.size.height/2-10))
        path2.addLineToPoint(CGPointMake(8, self.frame.size.height/2))
        path2.addLineToPoint(CGPointMake(16, self.frame.size.height/2+10))
        shape2.lineWidth =   2.0
        shape2.path=path2.CGPath;
        shape2.fillColor=UIColor.clearColor().CGColor
        shape2.strokeColor   =   UIColor.whiteColor().colorWithAlphaComponent(0.7).CGColor
        self.layer.addSublayer(shape2)
        
        
        let shape3   =  CAShapeLayer()
        let path3    =   UIBezierPath()
        path3.moveToPoint(CGPointMake(18, self.frame.size.height/2-10))
        path3.addLineToPoint(CGPointMake(10, self.frame.size.height/2))
        path3.addLineToPoint(CGPointMake(18, self.frame.size.height/2+10))
        shape3.lineWidth =   2.0
        shape3.path=path3.CGPath;
        shape3.fillColor=UIColor.clearColor().CGColor
        shape3.strokeColor   =   UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor
        self.layer.addSublayer(shape3)
        
        let leftBtn    =   UIButton()
        leftBtn.frame  =   CGRectMake(6, self.frame.size.height/2-15, 20, 30)
        leftBtn.addTarget(self, action: #selector(CLabsImageSlider.moveLeft), forControlEvents: .TouchUpInside)
        self.addSubview(leftBtn)
        
        let rightBtn    =   UIButton()
        rightBtn.frame  =   CGRectMake(self.frame.size.width-26, self.frame.size.height/2-15, 20, 30)
        rightBtn.addTarget(self, action: #selector(CLabsImageSlider.moveRight), forControlEvents: .TouchUpInside)
        self.addSubview(rightBtn)
        
    }


    
    
    
    
}








public class imageData {
    
    var image   =   UIImage?()
    var index   :   Int
    var isLoaded    =   Bool()
    var imageUrl    :   String
    var isloading   =   Bool()
    public weak var delegate    =   updateUI?()
    
    
    
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
                let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
                
                let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
                dispatch_async(backgroundQueue, {
                    
                    let data =   NSData(contentsOfURL:imageUrl)
                    
                    dispatch_async(dispatch_get_main_queue(), {[unowned self] () -> Void in
                        
                        if let imageBytes    =   data
                        {
                            self.image   =   UIImage(data: imageBytes)
                            self.isLoaded   =   true
                            self.delegate?.imageUpdate(self.index)
                            
                        }
                        else
                        {
                            
                            self.isloading   =   false
                            
                        }
                        })
                })
                
                
            }
        }
    }
    
    
}
