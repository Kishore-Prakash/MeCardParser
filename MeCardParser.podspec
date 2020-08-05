Pod::Spec.new do |s|
  s.name             = 'MeCardParser'
  s.version          = '1.0.0'
  s.summary          = 'MeCard Parser for iOS swift'
  s.homepage         = 'https://github.com/kishore-prakash/MeCardParser'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kishore Prakash' => 'kishore.balasa@gmail.com' }
  s.source           = { :git => 'https://github.com/kishore-prakash/MeCardParser.git', :tag => s.version.to_s }
  s.swift_versions   = ['5.0']
  s.source_files     = 'MeCardParser/Classes/**/*'
  s.ios.deployment_target = '9.0'
end
