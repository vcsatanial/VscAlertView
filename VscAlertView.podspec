Pod::Spec.new do |spec|
  spec.name             = 'VscAlertView'
  spec.ios.deployment_target = '8.0'
  spec.version          = '1.0.8'
  spec.summary          = '利用UIWindow模拟的AlertView,并增加新的UI效果 :'
  spec.description      = <<-DESC
                       利用UIWindow模拟的AlertView,可以增加复数按键,可以修改title与message的颜色,可以为按钮增加图片
                       DESC
  spec.homepage         = 'https://github.com/vcsatanial/VscAlertView'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'VincentSatanial' => '116359398@qq.com' }
  spec.source           = { :git => 'https://github.com/vcsatanial/VscAlertView.git', :tag => spec.version }
  
  spec.source_files = 'VscAlertView/*.{h,m}'
  spec.requires_arc = true
end
