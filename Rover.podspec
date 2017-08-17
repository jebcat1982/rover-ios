Pod::Spec.new do |s|
  s.name         = "Rover"
  s.version      = "2.0.0"
  s.summary      = "iOS framework for the Rover platform"
  s.homepage     = "https://www.rover.io"
  s.license      = "Apache License, Version 2.0"
  s.author       = { "Rover Labs Inc." => "support@rover.io" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/RoverPlatform/rover-ios.git", :tag => "v#{s.version}" }
  s.source_files = "Rover"
  s.frameworks   = "CoreLocation"
  s.frameworks   = "CoreTelephony"
  s.frameworks   = "Foundation"
  s.frameworks   = "UIKit"
  s.frameworks   = "UserNotifications"
end
