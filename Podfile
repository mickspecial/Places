# Uncomment the next line to define a global platform for your project
platform :ios, '12.2'

inhibit_all_warnings!

target 'Places' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Places
  pod 'SwiftLint'
  pod 'lottie-ios'

  target 'PlacesTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

# Disable Code Coverage for Pods projects
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
end
