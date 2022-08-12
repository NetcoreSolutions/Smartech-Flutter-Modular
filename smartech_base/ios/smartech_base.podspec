Pod::Spec.new do |s|
  s.name             = 'smartech_base'
  s.version          = '1.0.0'
  s.summary          = 'The Smartech iOS SDK for App Analytics and User Engagement.'
  s.description      = <<-DESC
                        Smartech is a omni channel platform that delivers everything you need to drive mobile engagement and create valuable consumer relationships on mobile.
                        The Smartech iOS SDK enables your native iOS app to use all of the features.
                      DESC
  s.homepage         = 'https://netcoresmartech.com'
  s.license          = { :type => 'Commercial', :file => '../LICENSE'}  
  s.author           = { 'Jobin Kurian' => 'jobin.kurian@netcorecloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.dependency "Smartech-iOS-SDK"
end