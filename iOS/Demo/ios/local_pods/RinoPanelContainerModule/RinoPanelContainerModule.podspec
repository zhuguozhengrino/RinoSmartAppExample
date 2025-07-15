Pod::Spec.new do |s|
  s.name             = 'RinoPanelContainerModule'
  s.version          = '1.1.2'
  s.summary          = 'A short description of RinoPanelContainerModule.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/wangyanmz/RinoPanelContainerModule'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangyanmz' => 'wangyan@rinoiot.com' }
  s.source           = { :git => 'https://github.com/wangyanmz/RinoPanelContainerModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_versions        = '5.0'
  
  s.source_files = 'RinoPanelContainerModule/Classes/**/*.{h,m}'
  
  s.subspec 'Module' do |ss|
    ss.source_files = 'RinoPanelContainerModule/Classes/Module/**/*'
  end
  
  s.subspec 'Container' do |ss|
    ss.dependency 'RinoPanelContainerModule/Module'
    ss.source_files = 'RinoPanelContainerModule/Classes/Container/**/*'
    ss.resources = 'RinoPanelContainerModule/Assets/*.bundle'
  end
  
  s.default_subspec = 'Container'
  
  s.dependency 'React-Core'
  s.dependency 'RinoBusinessLibraryModule'
  s.dependency 'RinoDebugKit'
  s.dependency 'RinoIPCKit'
  s.dependency 'RinoPanelKit'

end
