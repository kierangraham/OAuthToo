Pod::Spec.new do |spec|
  spec.name = "OAuthToo"
  spec.version = "0.0.1"
  spec.license = { type: "MIT" }
  spec.homepage = "https://github.com/kierangraham/OAuthToo"
  spec.authors = { "Kieran Graham" => "me@kierangraham.com" }
  spec.summary = "Another OAuth2 library for iOS written in Swift."
  spec.source  = { git: "https://github.com/kierangraham/OAuthToo.git", tag: spec.version }

  spec.ios.deployment_target = '8.0'

  spec.source_files = 'Source/*.swift'
  spec.requires_arc = true

  spec.dependency "Alamofire"
  spec.dependency "Dollar"
  spec.dependency "SwiftyJSON"
end
