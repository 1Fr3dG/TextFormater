Pod::Spec.new do |s|
  s.name             = 'TextFormater'
  s.version          = '2.0.0'
  s.summary          = 'Convert Markup String to NSAttributedString'

  s.description      = <<-DESC
Convert a short string with formatting commands to attributed string. For used to format label or button, or display a short paragraph with equation.
                       DESC

  s.homepage         = 'https://github.com/1fr3dg/TextFormater'
  s.screenshots      = 'https://github.com/1Fr3dG/TextFormater/blob/master/screen/example.png?raw=true', 'https://github.com/1Fr3dG/TextFormater/blob/master/screen/exampleOSX.png?raw=true'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Alfred Gao' => 'alfredg@alfredg.cn' }
  s.source           = { :git => 'https://github.com/1fr3dg/TextFormater.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.13'

  s.source_files = 'Sources/*'
  s.swift_version = '4.2'
  
  s.dependency 'iosMath'
  s.dependency 'MarkdownKit'


end
