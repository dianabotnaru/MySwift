# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'PicNRoll' do  

 use_frameworks!
 pod 'Material', '~> 2.0'
 pod "PagingKit"
 pod 'Firebase/Core'
 pod 'Firebase/Database'
 pod 'Firebase/Auth'
 pod 'Firebase/Storage'
 pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'

 post_install do |installer|
     installer.pods_project.targets.each do |target|
         if target.name == '<insert target name of your pod here>'
             target.build_configurations.each do |config|
                 config.build_settings['SWIFT_VERSION'] = '4.0'
             end
         end
     end
 end
end
