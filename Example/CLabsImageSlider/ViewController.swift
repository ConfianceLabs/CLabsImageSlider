//
//  ViewController.swift
//  CLabsImageSlider
//
//  Created by ConfianceLabs on 09/18/2016.
//  Copyright (c) 2016 ConfianceLabs. All rights reserved.
//

import UIKit
import CLabsImageSlider





class ViewController: UIViewController,imageSliderDelegate {

    @IBOutlet weak var imgSlider: CLabsImageSlider!
    
    
    let urlImages =    ["https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]
    
    let localImages =   ["one","two","three","four","five","six"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     imgSlider.sliderDelegate   =   self
    
    
    }
    
    
    override func viewDidLayoutSubviews() {
        
        
    
        imgSlider.setUpView(.Url(imageArray:urlImages,placeHolderImage:UIImage(named:"placeHolder")),slideType:.ManualSwipe,isArrowBtnEnabled: true)
        
       // imgSlider.setUpView(.Local(imageArray: localImages),slideType: .ManualSwipe,isArrowBtnEnabled: true)
        
    }
    
    
    func didMovedToIndex(index:Int)
    {
        print("did moved at Index : ",index)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

