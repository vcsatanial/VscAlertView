Pod::Spec.new do |spec|
  spec.name             = 'VscAlertView'
  spec.version          = '0.0.1'
  spec.summary          = '利用UIWindow模拟的AlertView,并增加新的UI效果 :'
  spec.description      = <<-DESC
                       利用UIWindow模拟的AlertView,可以增加复数按键,可以修改title与message的颜色,可以为按钮增加图片
                       DESC
  spec.homepage         = 'https://github.com/vcsatanial/'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'zhouhongchen' => '116359398@qq.com' }
  spec.source           = { :git => 'https://github.com/vcsatanial/VscAlertView.git', :tag => '0.0.1' }
  spec.ios.deployment_target = '8.0'
  spec.source_files = 'VscAlertView/*.{h,m}'

end
