Pod::Spec.new do |s|
  s.name          = "MusicalTables"
  s.version       = "0.0.1"
  s.summary       = "It’s like musical chairs but in your collections."
  s.homepage      = "https://github.com/a2/MusicalTables"
  s.license       = 'MIT'
  s.author        = { "Tim Cinel" => "email@timcinel.com>",
                      "Alexsander Akers" => "a2@pandamonia.us" }
  s.platform      = :ios
  s.source        = { :git => "https://github.com/a2/MusicalTables.git", :tag => "v#{s.version}" }
  s.source_files  = 'MusicalTables.{h,m}', 'MTDifference.{h,m}', 'MTSection.{h,m}'
  s.exclude_files = 'Sample'
  s.public_header_files = 'MusicalTables.h', 'MTSection.h'
  s.requires_arc  = true
end
