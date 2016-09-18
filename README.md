# CLabsImageSlider

[![CI Status](http://img.shields.io/travis/ConfianceLabs/CLabsImageSlider.svg?style=flat)](https://travis-ci.org/ConfianceLabs/CLabsImageSlider)
[![Version](https://img.shields.io/cocoapods/v/CLabsImageSlider.svg?style=flat)](http://cocoapods.org/pods/CLabsImageSlider)
[![License](https://img.shields.io/cocoapods/l/CLabsImageSlider.svg?style=flat)](http://cocoapods.org/pods/CLabsImageSlider)
[![Platform](https://img.shields.io/cocoapods/p/CLabsImageSlider.svg?style=flat)](http://cocoapods.org/pods/CLabsImageSlider)


![Alt text](https://s26.postimg.org/igwgu4wah/giphy.gif) 

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Swift 2.2

## Summary

CLabsImageSlider is a image slider written in swift language ,instead of implementing complex logics now you can create image slider with a single line of code. CLabsImageSlider loads local or remote images with multiple options like manual or auto slide etc. So save your time in writing code for page control by using CLabsImageSlider.

## Installation

CLabsImageSlider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CLabsImageSlider"
```

## Step 1

 From identity inspector replace UIView class of your UIView with CLabsImageSlider class in your xib or StoryBoard.
 
 ![Alt text](https://s26.postimg.org/519g4onsp/giphy_W.gif) 
 

## Step 2

Create its Outlet.  

```swift
  @IBOutlet weak var imgSlider: CLabsImageSlider!
```

## Step 3 To show slider Images from Url

From viewDidLayoutSubviews function call "SetUpView" function of CLabsImageSlider

```swift

let urlImages =    ["https://s26.postimg.org/3n85yisu1/one_5_51_58_PM.png","https://s26.postimg.org/65tuz7ek9/two_5_41_53_PM.png","https://s26.postimg.org/7ywrnizqx/three_5_41_53_PM.png","https://s26.postimg.org/6l54s80hl/four.png","https://s26.postimg.org/ioagfsbjt/five.png"]

override func viewDidLayoutSubviews() {

imgSlider.setUpView(.Url(imageArray:urlImages,placeHolderImage:UIImage(named:"placeHolder")),slideType:.ManualSwipe,isArrowBtnEnabled: true)
 
    }
```


## To Show Local Images

```swift
 let localImages =   ["one.jpg","two.jpg","three.jpg","four.jpg","five.jpg","six.jpg"]
 
  override func viewDidLayoutSubviews() {
  
     imgSlider.setUpView(.Local(imageArray: localImages),slideType: .ManualSwipe,isArrowBtnEnabled: true)
  
    }
 
```
## Optional Step

- Apply imageSliderDelegate

```swift
class ViewController: UIViewController,imageSliderDelegate

override func viewDidLoad() {
        super.viewDidLoad()
        
     imgSlider.sliderDelegate   =   self
    
    
    }

```

- Use its Delegate function

```swift
 func didMovedToIndex(index:Int)
    {
        print("did moved at Index : ",index)
    }
```

# YouTube Link   

https://www.youtube.com/channel/UCwYjZ3vXQYhJaRwUm6u9-bA
 

## Author

ConfianceLabs, confiancelabs@gmail.com

## License

CLabsImageSlider is available under the MIT license. See the LICENSE file for more info.
