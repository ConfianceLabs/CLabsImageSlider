#
# Be sure to run `pod lib lint CLabsImageSlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CLabsImageSlider'
  s.version          = '0.1.0'
  s.summary          = 'CLabsImageSlider is a image slider written in swift language.'


  s.description      =  'CLabsImageSlider is a image slider written in swift language ,instead of implementing complex logics now you can create image slider with a single line of code. CLabsImageSlider loads local or remote images with multiple options like manual or auto slide etc. So save your time in writing code for page control by using CLabsImageSlider.'


  s.homepage         = 'https://github.com/ConfianceLabs/CLabsImageSlider.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dewanshu Sharma' => 'confiancelabs@gmail.com' }
  s.source           = { :git => 'https://github.com/ConfianceLabs/CLabsImageSlider.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CLabsImageSlider/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CLabsImageSlider' => ['CLabsImageSlider/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
