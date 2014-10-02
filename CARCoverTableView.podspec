Pod::Spec.new do |s|
  s.name         = "CARCoverTableView"
  s.version      = "0.0.11"
  s.summary      = ""
#  s.description  =
  s.homepage     = "https://github.com/CrayonApps/CARCoverTableView"
  s.screenshots  = "https://github.com/CrayonApps/CARCoverTableView/tree/v#{s.version}/screenshots/screenshot_1.gif"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "CrayonApps inc." => "hello@crayonapps.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/CrayonApps/CARCoverTableView.git", :tag => "v#{s.version}" }
  s.source_files = 'CARCoverTableView'
  s.requires_arc = true

end
