#
# Be sure to run `pod lib lint DZ_UIKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "DZ_UIKit"
    s.version          = "0.6.2"
    s.summary          = "Custom UIs that be used in Topeko"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

	s.description      = <<-DESC
* 0.6.2
Update to Swift4.2
---
* 0.6.1
Fix some bug in checkbox group
---
* 0.6.0
Update to Swift4.
---
* 0.2.4
Add DZStepper, which can be used in both code or storyboard.
                       DESC

    s.homepage         = "https://github.com/darkzero/DZ_UIKit"
    # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license          = 'MIT'
    s.author           = { "darkzero" => "topeko.feedback@gmail.com" }
    s.source           = { :git => "https://github.com/darkzero/DZ_UIKit.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/darkzero_mk2'

    s.ios.deployment_target = '9.3'

    s.source_files = 'DZ_UIKit/Classes/**/*'
    s.resources = ['DZ_UIKit/Assets/*.png']

end
