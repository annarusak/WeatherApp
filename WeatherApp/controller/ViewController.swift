import UIKit
import Foundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    /// Enum for font names
    enum FontName: String {
        case copperplate = "Copperplate"
        case helveticaNeue = "Helvetica Neue"
    }
    
    /// Image view for displaying a circle image
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Labels for weather information
    private lazy var cityNameLabel = createLabel(labelText: "-", labelColor: .black, fontName: FontName.copperplate.rawValue, sizeOfFont: 20)
    private lazy var temperatureMainLabel = createLabel(labelText: "", labelColor: .black, fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 43)
    private lazy var dayOfWeekLabel = createLabel(labelText: "-", labelColor: .black, fontName: FontName.copperplate.rawValue, sizeOfFont: 30)
    private lazy var dayOfMonthLabel = createLabel(labelText: "-", labelColor: .black, fontName: FontName.copperplate.rawValue, sizeOfFont: 17)
    private lazy var weatherConditionsLabel = createLabel(labelText: "-", labelColor: .black, fontName: FontName.copperplate.rawValue, sizeOfFont: 18)
    private lazy var temperatureLabel = createLabel(imageName: "thermometer", imageColor: .temperatureIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var windSpeedLabel = createLabel(imageName: "wind", imageColor: .windIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var humidityLabel = createLabel(imageName: "humidity", imageColor: .humidityIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var weatherForecastLabel = createLabel(labelText: "10-DAY WEATHER FORECAST", labelColor: .lightGray, fontName: FontName.copperplate.rawValue, sizeOfFont: 14)
    
    /// ScrollView for displaying weather forecast
    private var scrollView = UIScrollView()
    private var weatherForecastSubviews: [ScrollViewElement] = []
    
    /// Location manager instance for managing device's location
    private let locationManager = LocationManager()
    
    /// Weather provider instance for fetching weather data
    private let weatherProvider = WeatherProvider()
    
    /// Current date
    private let date = Date()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupViews()
        locationManager.addDelegate(delegate: requestWeatherForLocation)
        weatherProvider.addDelegateWeatherCurrent(delegate: currentWeatherDelegate)
        weatherProvider.addDelegateWeatherForecast(delegate: weatherForecastDelegate)
        locationManager.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleRotation()
    }
    
    // MARK: - Helper Methods
    
    /// Create a label with given parameters.
    /// - Parameters:
    ///   - labelText: The text to be displayed on the label.
    ///   - labelColor: The color of the label's text.
    ///   - fontName: The name of the font to be used.
    ///   - sizeOfFont: The size of the font.
    /// - Returns: UILabel instance with specified parameters.
    private func createLabel(labelText: String, labelColor: UIColor, fontName: String, sizeOfFont: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.textColor = labelColor
        label.font = UIFont(name: "\(fontName)", size: sizeOfFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// Create a label with an icon and given parameters.
    /// - Parameters:
    ///   - imageName: The name of the image icon.
    ///   - imageColor: The color of the image icon.
    ///   - labelText: The text to be displayed on the label.
    ///   - fontName: The name of the font to be used.
    ///   - sizeOfFont: The size of the font.
    /// - Returns: UILabel instance with specified parameters.
    private func createLabel(imageName: String, imageColor: UIColor,
                             labelText: String, fontName: String,
                             sizeOfFont: CGFloat) -> UILabel {
        let label = UILabel()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage.init(systemName: imageName)?
            .withRenderingMode(.alwaysTemplate)
            .withTintColor(imageColor)
        let attributedString = NSMutableAttributedString(string: " \(labelText)")
        attributedString.insert(NSAttributedString(attachment: imageAttachment), at: 0)
        label.attributedText = attributedString
        label.font = UIFont(name: "\(fontName)", size: sizeOfFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }
    
    /// Setup the scroll view to display weather forecast.
    private func setupScrollView() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let scrollViewWidth: CGFloat = 380.0
        let scrollViewY: CGFloat = 700.0
        
        scrollView.delegate = self
        
        scrollView = UIScrollView(frame: CGRect(x: (screenWidth - scrollViewWidth) / 2.0,
                                                y: scrollViewY,
                                                width: scrollViewWidth,
                                                height: screenHeight - scrollViewY))
        
        let scrollViewElementWidth = scrollViewWidth / 3
        
        let numberOfViews = 10
        for i in 0..<numberOfViews {
            let customView = ScrollViewElement(frame: CGRect(x: CGFloat(i) * scrollViewElementWidth,
                                                             y: 0,
                                                             width: scrollViewElementWidth,
                                                             height: scrollView.frame.size.height))
            scrollView.addSubview(customView)
            weatherForecastSubviews.append(customView)
        }
        
        scrollView.contentSize = CGSize(width: scrollViewElementWidth * CGFloat(numberOfViews),
                                        height: scrollView.frame.size.height)
        scrollView.isPagingEnabled = true
        
        view.addSubview(scrollView)
    }
    
    /// Set up the user interface elements.
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(circleImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureMainLabel)
        view.addSubview(dayOfWeekLabel)
        view.addSubview(weatherConditionsLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(humidityLabel)
        view.addSubview(dayOfMonthLabel)
        view.addSubview(weatherForecastLabel)
        
        NSLayoutConstraint.activate([
            weatherConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherConditionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            dayOfMonthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayOfMonthLabel.bottomAnchor.constraint(equalTo: weatherConditionsLabel.topAnchor, constant: -10),
            
            dayOfWeekLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayOfWeekLabel.bottomAnchor.constraint(equalTo: dayOfMonthLabel.topAnchor, constant: -5),
            
            circleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: dayOfWeekLabel.topAnchor, constant: -50),
            circleImageView.widthAnchor.constraint(equalToConstant: 160),
            circleImageView.heightAnchor.constraint(equalToConstant: 160),
            
            temperatureMainLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor, constant: 5),
            temperatureMainLabel.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor, constant: -3),
            
            cityNameLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor),
            cityNameLabel.bottomAnchor.constraint(equalTo: circleImageView.topAnchor, constant: -5),
            
            windSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windSpeedLabel.centerYAnchor.constraint(equalTo: weatherConditionsLabel.centerYAnchor, constant: 100),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: windSpeedLabel.leftAnchor, constant: -60),
            
            humidityLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            humidityLabel.leftAnchor.constraint(equalTo: windSpeedLabel.rightAnchor, constant: 60),
            
            weatherForecastLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            weatherForecastLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 95)
        ])
    }
    
    /// Rotate the circle image view.
    private func circleRotation() {
        /// Create a CABasicAnimation for rotation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        circleImageView.layer.add(rotationAnimation, forKey: "spinAnimation")
    }
    
    /// Update the weather label with either an icon or plain text.
    /// - Parameters:
    ///   - label: The label to be updated.
    ///   - value: The value to be displayed.
    ///   - postfix: The postfix to be added after the value.
    ///   - withIcon: A  boolean value indicating whether to use an icon.
    private func updateWeatherLabel(label: UILabel, value: Float, postfix: String, withIcon: Bool) {
        let intValue = Int(value.rounded())
        
        if (withIcon) {
            guard let existingAttributedString = label.attributedText?.mutableCopy() as? NSMutableAttributedString else {
                return
            }
            
            /// Find and modify the text part
            let iconLength = 1
            let range = NSRange(location: iconLength, length: existingAttributedString.length - iconLength)
            existingAttributedString.replaceCharacters(in: range, with: " \(intValue)" + postfix)
            
            /// Set the updated attributed text back to the label
            label.attributedText = existingAttributedString
        } else {
            label.text = String(intValue) + postfix
        }
    }
    
    /// Update the weather label with text.
    /// - Parameters:
    ///   - label: The label to be updated.
    ///   - value: The text value to be displayed.
    private func updateWeatherLabel(label: UILabel, value: String) {
        label.text = value
    }
    
    /// Extracts city name from timezone.
    /// - Parameter timezone: The timezone string.
    /// - Returns: The extracted city name.
    private func cityFromTimezone(timezone: String) -> String {
        var afterSlash = ""
        if let slash = timezone.range(of: "/")?.upperBound {
            afterSlash = String(timezone.suffix(from: slash))
        }
        if afterSlash.contains("_") {
            afterSlash = afterSlash.replacingOccurrences(of: "_", with: " ")
        }
        return afterSlash
    }
    
    /// Handles current weather data delegate method.
    /// - Parameter weather: The current weather data.
    private func currentWeatherDelegate(weather: WeatherProvider.WeatherCurrent) {
        updateWeatherLabel(label: temperatureMainLabel, value: weather.temperature, postfix: "°", withIcon: false)
        updateWeatherLabel(label: temperatureLabel, value: weather.temperature, postfix: "°", withIcon: true)
        updateWeatherLabel(label: humidityLabel, value: weather.humidity, postfix: "%", withIcon: true)
        updateWeatherLabel(label: windSpeedLabel, value: weather.windSpeed, postfix: " m/s", withIcon: true)
        updateWeatherLabel(label: weatherConditionsLabel, value: weather.conditions.uppercased())
        updateWeatherLabel(label: cityNameLabel, value: cityFromTimezone(timezone: weather.timezone).uppercased())
        updateWeatherLabel(label: dayOfMonthLabel, value: date.dayOfMonth())
        updateWeatherLabel(label: dayOfWeekLabel, value: date.dayOfWeek() ?? "")
    }
    
    /// Handles weather forecast data delegate method.
    /// - Parameter weatherForecast: The weather forecast data.
    private func weatherForecastDelegate(weatherForecast: [WeatherProvider.WeatherForecast]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var dayOfWeek = ""
        
        for (index, day) in weatherForecast.enumerated() {
            if let date = dateFormatter.date(from: day.datetime) {
                dayOfWeek = date.dayOfWeek() ?? day.datetime
            }
            if index <= weatherForecastSubviews.count {
                weatherForecastSubviews[index].updateView(dayOfWeek: dayOfWeek,
                                                          temperature: Int((day.temperature).rounded()),
                                                          icon: forecastIcon(iconName: day.icon))
            }
        }
    }
    
    /// Returns the appropriate weather icon image based on the given icon name.
    /// - Parameter iconName: The name of the weather icon.
    /// - Returns: The UIImage representing the weather icon.
    private func forecastIcon(iconName: String) -> UIImage {
        switch iconName {
        case IconName.clearDay.rawValue:
            return UIImage(named: iconName)!
        case IconName.clearNight.rawValue:
            return UIImage(named: iconName)!
        case IconName.cloudy.rawValue:
            return UIImage(named: iconName)!
        case IconName.fog.rawValue:
            return UIImage(named: iconName)!
        case IconName.partlyCloudyDay.rawValue:
            return UIImage(named: iconName)!
        case IconName.partlyCloudyNight.rawValue:
            return UIImage(named: iconName)!
        case IconName.rain.rawValue:
            return UIImage(named: iconName)!
        case IconName.snow.rawValue:
            return UIImage(named: iconName)!
        case IconName.wind.rawValue:
            return UIImage(named: iconName)!
        default:
            return UIImage(named: iconName)!
        }
    }
    
    /// Fetches weather data for a given location.
    /// - Parameter location: The latitude and longitude of the location.
    private func requestWeatherForLocation(location : (latitude: Double, longitude: Double)) {
        print("\(location.latitude) | \(location.longitude)")
        weatherProvider.request(location: location)
    }
    
}
