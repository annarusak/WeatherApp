import UIKit
import Foundation

class ViewController: UIViewController {
    
    enum FontName: String {
        case copperplate = "Copperplate"
        case helveticaNeue = "Helvetica Neue"
    }
    
    let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "circle")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var cityNameLabel = createLabel(labelText: "-", fontName: FontName.copperplate.rawValue, sizeOfFont: 15)
    private lazy var temperatureMainLabel = createLabel(labelText: "", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 40)
    private lazy var dayOfWeekLabel = createLabel(labelText: "MONDAY", fontName: FontName.copperplate.rawValue, sizeOfFont: 30)
    private lazy var weatherConditionsLabel = createLabel(labelText: "-", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)
    private lazy var temperatureLabel = createLabel(imageName: "thermometer", imageColor: temperatureIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var windSpeedLabel = createLabel(imageName: "wind", imageColor: windIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var humidityLabel = createLabel(imageName: "humidity", imageColor: humidityIconColor, labelText: "-", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var currentTimeLabel = createLabel(labelText: "18.30 PM", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)
    private lazy var currentDateLabel = createLabel(labelText: "7 NOV", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)

    let temperatureIconColor = UIColor(red: 240/255, green: 168/255, blue: 153/255, alpha: 1.0)
    let windIconColor = UIColor(red: 185/255, green: 188/255, blue: 107/255, alpha: 1.0)
    let humidityIconColor = UIColor(red: 181/255, green: 152/255, blue: 206/255, alpha: 1.0)
    
    let locationManager = LocationManager()
    let weatherProvider = WeatherProvider()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        locationManager.addDelegate(delegate: requestWeatherForLocation)
        weatherProvider.addDelegate(delegate: weatherDelegate)
        locationManager.setup()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circleRotation()
    }
    
    
    
    func createLabel(labelText: String, fontName: String, sizeOfFont: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.textColor = .black
        label.font = UIFont(name: "\(fontName)", size: sizeOfFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createLabel(imageName: String, imageColor: UIColor,
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
    
    func setupViews() {
        view.backgroundColor = .white
        view.addSubview(circleImageView)
        view.addSubview(cityNameLabel)
        view.addSubview(temperatureMainLabel)
        view.addSubview(dayOfWeekLabel)
        view.addSubview(weatherConditionsLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(humidityLabel)
        view.addSubview(currentTimeLabel)
        view.addSubview(currentDateLabel)
        
        NSLayoutConstraint.activate([
            weatherConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherConditionsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            dayOfWeekLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayOfWeekLabel.bottomAnchor.constraint(equalTo: weatherConditionsLabel.topAnchor),

            circleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: dayOfWeekLabel.topAnchor, constant: -50),
            circleImageView.widthAnchor.constraint(equalToConstant: 180),
            circleImageView.heightAnchor.constraint(equalToConstant: 180),

            temperatureMainLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor),
            temperatureMainLabel.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor, constant: 10),

            cityNameLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor),
            cityNameLabel.bottomAnchor.constraint(equalTo: temperatureMainLabel.topAnchor),

            windSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windSpeedLabel.centerYAnchor.constraint(equalTo: weatherConditionsLabel.centerYAnchor, constant: 100),

            temperatureLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            temperatureLabel.rightAnchor.constraint(equalTo: windSpeedLabel.leftAnchor, constant: -60),

            humidityLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor),
            humidityLabel.leftAnchor.constraint(equalTo: windSpeedLabel.rightAnchor, constant: 60),

            currentTimeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentTimeLabel.centerYAnchor.constraint(equalTo: windSpeedLabel.centerYAnchor, constant: 100),

            currentDateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentDateLabel.centerYAnchor.constraint(equalTo: currentTimeLabel.centerYAnchor, constant: 20)
        ])
    }
    
    func circleRotation() {
        // Create a CABasicAnimation for rotation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        circleImageView.layer.add(rotationAnimation, forKey: "spinAnimation")
    }
    
    func updateWeatherLabel(label: UILabel, value: Float, postfix: String, withIcon: Bool) {
        let intValue = Int(value.rounded())

        if (withIcon) {
            guard let existingAttributedString = label.attributedText?.mutableCopy() as? NSMutableAttributedString else {
                return
            }

            // Find and modify the text part
            let iconLength = 1
            let range = NSRange(location: iconLength, length: existingAttributedString.length - iconLength)
            existingAttributedString.replaceCharacters(in: range, with: " \(intValue)" + postfix)

            // Set the updated attributed text back to the label
            label.attributedText = existingAttributedString
        } else {
            label.text = String(intValue) + postfix
        }
    }
    
    func updateWeatherLabel(label: UILabel, value: String) {
        label.text = value
    }

    func cityFromTimezone(timezone: String) -> String {
        var afterSlash = ""
        if let slash = timezone.range(of: "/")?.upperBound {
            afterSlash = String(timezone.suffix(from: slash))
        }
        if afterSlash.contains("_") {
            afterSlash = afterSlash.replacingOccurrences(of: "_", with: " ")
        }
        return afterSlash
    }
    
    private func weatherDelegate(weather : WeatherProvider.Weather) {
        updateWeatherLabel(label: temperatureMainLabel, value: weather.temperature, postfix: "°", withIcon: false)
        updateWeatherLabel(label: temperatureLabel, value: weather.temperature, postfix: "°", withIcon: true)
        updateWeatherLabel(label: humidityLabel, value: weather.humidity, postfix: "%", withIcon: true)
        updateWeatherLabel(label: windSpeedLabel, value: weather.windSpeed, postfix: " m/s", withIcon: true)
        updateWeatherLabel(label: weatherConditionsLabel, value: weather.conditions.uppercased())
        updateWeatherLabel(label: cityNameLabel, value: cityFromTimezone(timezone: weather.timezone).uppercased())
    }

    private func requestWeatherForLocation(location : (latitude: Double, longitude: Double)) {
        print("\(location.latitude) | \(location.longitude)")
        weatherProvider.request(location: location)
    }
    
}
