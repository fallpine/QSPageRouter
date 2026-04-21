Pod::Spec.new do |s|
  s.name             = 'QSPageRouter'
  s.version          = '1.0.0'
  s.summary          = 'A lightweight UIKit page router with push, present, and sheet support.'
  s.description      = <<-DESC
QSPageRouter is a lightweight UIKit router for iOS projects. It provides a unified
Routable-based navigation API for resolving the current view controller, pushing pages,
presenting full-screen or automatic modals, and presenting configurable sheets.
  DESC

  s.homepage         = 'https://github.com/fallpine/QSPageRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Song'
  s.source           = { :git => 'https://github.com/fallpine/QSPageRouter.git', :tag => s.version.to_s }

  s.platform         = :ios, '16.0'
  s.swift_versions   = ['5.0']
  s.requires_arc     = true

  s.source_files     = 'QSPageRouter/Router/**/*.{swift}'
  s.frameworks       = 'UIKit'
end
