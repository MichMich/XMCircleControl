
Pod::Spec.new do |s|

  s.name         = "XMCircleType"
  s.version      = "0.0.1"
  s.summary      = "A Circular Control View ... Work in progress! Come back later. :)"

  s.homepage     = "https://github.com/MichMich/XMCircleControl"
  s.screenshots  = "https://raw.github.com/michmich/XMCircleControl/master/Screenshots/example.png"

  s.license      = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author       = { "Michael Teeuw" => "michael@xonaymedia.nl" }
  s.social_media_url = "http://twitter.com/MichMich"

  s.platform     = :ios
  s.source       = { :git => "https://github.com/MichMich/XMCircleType.git", :tag => "0.0.1" }
  s.source_files  = 'XMCircleControl/Classes/*.{h,m}'
  s.requires_arc = true

end
