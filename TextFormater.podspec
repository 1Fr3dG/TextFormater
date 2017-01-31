Pod::Spec.new do |s|
  s.name             = 'TextFormater'
  s.version          = '1.1.6'
  s.summary          = 'Convert String to NSAttributedString'

  s.description      = <<-DESC
Convert a short string with formatting commands to attributed string. For used to format label or button.
                       DESC

  s.homepage         = 'https://github.com/1fr3dg/TextFormater'
  s.screenshots      = 'https://github.com/1Fr3dG/TextFormater/blob/master/screen/example.png?raw=true', 'https://github.com/1Fr3dG/TextFormater/blob/master/screen/exampleOSX.png?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alfred Gao' => 'alfredg@alfredg.cn' }
  s.source           = { :git => 'https://github.com/1fr3dg/TextFormater.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'

  s.source_files = 'Sources/*'

end
