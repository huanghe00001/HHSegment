Pod::Spec.new do |s|
  s.name           = "HHSegment"
  s.version        = "0.0.1"
  s.summary        = "IOS Segment animation font maske."
  s.homepage       = "https://github.com/huanghe00001/HHSegment"
  s.license        = { :type => 'MIT', :file => 'LICENSE' }
  s.author         = { "huanghe" => "20211569@qq.com" }
  s.platform       = :ios, "7.0"
  s.source         = { :git => "https://github.com/huanghe00001/HHSegment.git", :tag => "0.0.1" }
  s.source_files   = "HHSegmentDemo/HHSegmentDemo/HHSegment/*.{h,m}"
  s.framework      = "UIKit"

end
