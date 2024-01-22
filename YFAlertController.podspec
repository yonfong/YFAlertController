#
# Be sure to run `pod lib lint YFAlertController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YFAlertController'
  s.version          = '0.5.0'
  s.summary          = 'An iOS Customizable alert sheet Controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  YFAlertController is a framework that rewrite the [SPAlertController](https://github.com/SPStore/SPAlertController) in Swift.
                       DESC

  s.homepage         = 'https://github.com/yonfong/YFAlertController'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yonfong' => 'yongfongzhang@163.com' }
  s.source           = { :git => 'https://github.com/yonfong/YFAlertController.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'
  s.swift_version         = '5.0'

  s.source_files = 'Sources/YFAlertController/Classes/**/*'
  
end
