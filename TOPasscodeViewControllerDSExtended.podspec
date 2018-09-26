Pod::Spec.new do |s|
  s.name     = 'TOPasscodeViewControllerDSExtended'
  s.version  = '0.1.10'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A view controller that prompts users to enter a passcode.'
  s.homepage = 'https://github.com/DimasSup/TOPasscodeViewController'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/DimasSup/TOPasscodeViewController.git', :tag => s.version }
  s.platform = :ios, '8.3'
  s.requires_arc = true

  s.subspec 'Core' do |core|
   core.source_files   = 'TOPasscodeViewController/{Core}/**/*'
   core.public_header_files = 'TOPasscodeViewController/{Core}/**/*.h'
  end
  s.subspec 'Biomentrical' do |fmdb|
   fmdb.source_files   = 'TOPasscodeViewController/Biomentrical/**/*'
   fmdb.public_header_files = 'TOPasscodeViewController/Biomentrical/**/*.h'

   fmdb.dependency 'TOPasscodeViewControllerDSExtended/Core'
  end
end
