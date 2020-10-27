#
# Be sure to run `pod lib lint BulbliotecaIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BulbliotecaIOS'
  s.version          = '0.2.3'
  s.summary          = 'BulbliotecaIOS para os Bulbs'
  s.description      = 'BulbliotecaIOS para leitura dos Bulbs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Mobs2sdk/BulbliotecaIOS'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mobs2sdk' => 'administrator@mobs2.com' }
  s.source           = { :git => 'https://github.com/Mobs2sdk/BulbliotecaIOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version    = '5.0'
  s.ios.deployment_target = '10.0'

  s.source_files = 'BulbliotecaIOS/Classes/**/*.{swift,h,m}'
  
  # s.resource_bundles = {
  #   'BulbliotecaIOS' => ['BulbliotecaIOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
