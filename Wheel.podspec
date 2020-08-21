#
# Be sure to run `pod lib lint Wheel.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Wheel'
  s.version          = '1.0.3'
  s.summary          = 'Horizontal wheel picker library for iOS applications.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A horizontal wheel picker library for iOS applications. Pass in an array of strings, the initial selected value and receive selections through a callback
                       DESC

  s.homepage         = 'https://github.com/AmirShayegh/Wheel'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AmirShayegh' => 'shayegh@me.com' }
  s.source           = { :git => 'https://github.com/AmirShayegh/Wheel.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.source_files = 'Wheel/Classes/**/*.{swift}'
  
  s.resource_bundles = {
      'Wheel' => ['Wheel/Classes/**/*.{storyboard,xib}']
  }
  s.frameworks = 'UIKit'
end
