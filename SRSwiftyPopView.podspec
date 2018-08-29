#
# Be sure to run `pod lib lint SRSwiftyPopView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SRSwiftyPopView'
    s.version          = '0.1.0'
    s.summary          = 'The Swifty counterpart of SRPopView - a simple yet powerfull popover option that takes care of showing options and searching when nessasary.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = 'SRSwiftyPopView is the swifty counter part of the immensely handy popover SRPopView is a small and simple yet powerfull drag and drop complete solution for showing popview for lists and dropdown solution for iOS SRpopview supports both Portrait and Landscape orientation'
    
    s.homepage         = 'https://github.com/SahebRoy92/SRPopView'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'sahebroy92' => 'theioscracker@gmail.com' }
    s.source           = { :git => 'https://github.com/SahebRoy92/SRPopView.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    s.swift_version = "4.1"
    s.source_files = 'SRSwiftyPopView/Classes/**/*'
    
    # s.resource_bundles = {
    #   'SRSwiftyPopView' => ['SRSwiftyPopView/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
