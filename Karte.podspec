Pod::Spec.new do |s|
  s.name        = "Karte"
  s.version     = "1.1.0"
  s.summary     = "Conveniently launch directions in other iOS map apps"
  s.description = <<-DESC
    Small library for opening a location or route in other popular iOS apps.
  DESC

  s.homepage         = "https://github.com/kiliankoe/Karte"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Kilian Koeltzsch" => "me@kilian.io" }
  s.social_media_url = "https://twitter.com/kiliankoe"

  s.ios.deployment_target = "10.0"

  s.source = { :git => "https://github.com/kiliankoe/Karte.git", :tag => s.version.to_s }

  s.source_files = "Sources/**/*"
  s.frameworks   = "Foundation"
end
