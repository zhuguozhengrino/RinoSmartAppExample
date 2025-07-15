#
# Be sure to run `pod lib lint ffmpeg-kit-ios-full.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ffmpeg-kit-ios-full'
  s.version          = '6.0'
  s.summary          = 'A short description of ffmpeg-kit-ios-full.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://gitee.com/rinoapp/ffmpeg-kit-ios-full.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'devteam+mirror' => 'greatstone_liu@163.com' }
  s.source           = { :git => 'https://gitee.com/rinoapp/ffmpeg-kit-ios-full.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.vendored_frameworks   = 'ffmpeg-kit-ios-full/Frameworks/*.xcframework'
  
  s.source_files = 'ffmpeg-kit-ios-full/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ffmpeg-kit-ios-full' => ['ffmpeg-kit-ios-full/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
