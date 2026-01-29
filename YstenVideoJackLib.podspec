#
# Be sure to run `pod lib lint YstenVideoJackLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YstenVideoJackLib'
  s.version          = '0.2.0'
  s.summary          = 'A short description of YstenVideoJackLib.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/pwthd6bzfs-byte/YstenVideoJackLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pwthd6bzfs-byte' => '524269669@qq.com' }
  s.source           = { :git => 'https://github.com/pwthd6bzfs-byte/YstenVideoJackLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'YstenVideoJackLib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YstenVideoJackLib' => ['YstenVideoJackLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  # 排除 arm64 模拟器架构
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
#  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.static_framework = true

  
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'YYKit', '1.0.9'
  s.dependency 'RongCloudIM/IMLib', '~> 5.32.0'
#  #融云IMKit(含会话列表页面，会话页面，输入工具栏)
  s.dependency 'RongCloudOpenSource/IMKit','~> 5.32.0'
  s.dependency 'AgoraRtcEngine_iOS', '~> 4.5.1'
  s.dependency 'SVProgressHUD'
  s.dependency 'Masonry'
  
  
   
  # 图片加载
  s.dependency 'SDWebImage', '~>5.19.7'
  s.dependency 'SVGAPlayer', '~>2.5.7'
  s.dependency 'Protobuf', '= 3.22.1'
  s.dependency 'JXCategoryView', '~>1.6.8'
  s.dependency 'MJRefresh'
end
