#
# Be sure to run `pod lib lint CHLMVP.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CHLMVP'
  s.version          = '1.0'
  s.summary          = 'Quickly use MVP.'

  s.description      = <<-DESC
    Quickly using MVP Design Pattern
                       DESC

  s.homepage         = 'https://github.com/nick6969/CHL_MVP'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hawhaw.ya@gmail.com' => 'hawhaw.ya@gmail.com' }
  s.source           = { :git => 'https://github.com/nick6969/CHL_MVP.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version    = "5.0"

  s.source_files = 'CHLMVP/Classes/'
  
end
