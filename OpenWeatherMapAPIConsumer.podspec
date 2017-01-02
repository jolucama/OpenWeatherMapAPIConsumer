#
# Be sure to run `pod lib lint OpenWeatherMapAPIConsumer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'OpenWeatherMapAPIConsumer'
  s.version          = '0.0.1'
  s.summary          = 'Get current weather and 3-hourly forecast 5 days for your city. Helpful stats, temperature, clouds, pressure, wind around your location.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Access current weather data for any location on Earth including over 200,000 cities! Current weather is frequently updated based on global models and data from more than 40,000 weather stations. Also 5 day forecast is available at any location or city. It includes weather data every 3 hours. Data is available in JSON Format. 
                       DESC

  s.homepage         = 'https://github.com/jolucama/OpenWeatherMapAPIConsumer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jose Luis Cardosa' => 'jlcardosa@gmail.com' }
  s.source           = { :git => 'https://github.com/jolucama/OpenWeatherMapAPIConsumer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.2'

  s.source_files = 'OpenWeatherMapAPIConsumer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'OpenWeatherMapAPIConsumer' => ['OpenWeatherMapAPIConsumer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
