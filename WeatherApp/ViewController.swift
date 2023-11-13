import UIKit
import Foundation

class ViewController: UIViewController {
    
    let locationManager = LocationManager()

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
    
    private lazy var cityNameLabel = createLabel(labelText: "PAPHOS", fontName: FontName.copperplate.rawValue, sizeOfFont: 15)
    private lazy var temperatureMainLabel = createLabel(labelText: "25", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 40)
    private lazy var dayOfWeekLabel = createLabel(labelText: "MONDAY", fontName: FontName.copperplate.rawValue, sizeOfFont: 30)
    private lazy var weatherDescriptionLabel = createLabel(labelText: "BROKEN CLOUDS", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)
    private lazy var temperatureLabel = createLabel(imageName: "thermometer", imageColor: temperatureIconColor, labelText: "25", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var windSpeedLabel = createLabel(imageName: "wind", imageColor: windIconColor, labelText: "3 m/s", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var humidityLabel = createLabel(imageName: "humidity", imageColor: humidityIconColor, labelText: "80%", fontName: FontName.helveticaNeue.rawValue, sizeOfFont: 17)
    private lazy var currentTimeLabel = createLabel(labelText: "18.30 PM", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)
    private lazy var currentDateLabel = createLabel(labelText: "7 NOV", fontName: FontName.copperplate.rawValue, sizeOfFont: 17)

    let temperatureIconColor = UIColor(red: 240/255, green: 168/255, blue: 153/255, alpha: 1.0)
    let windIconColor = UIColor(red: 185/255, green: 188/255, blue: 107/255, alpha: 1.0)
    let humidityIconColor = UIColor(red: 181/255, green: 152/255, blue: 206/255, alpha: 1.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        startAnimation()
        locationManager.setup()
    }
    
    
    func createLabel(labelText: String, fontName: String, sizeOfFont: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = labelText
        label.textColor = .black
        label.font = UIFont(name: "\(fontName)", size: sizeOfFont)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func createLabel(imageName: String, imageColor: UIColor, labelText: String, fontName: String, sizeOfFont: CGFloat) -> UILabel {
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
        view.addSubview(weatherDescriptionLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(windSpeedLabel)
        view.addSubview(humidityLabel)
        view.addSubview(currentTimeLabel)
        view.addSubview(currentDateLabel)
        
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherDescriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            dayOfWeekLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dayOfWeekLabel.bottomAnchor.constraint(equalTo: weatherDescriptionLabel.topAnchor),

            circleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleImageView.bottomAnchor.constraint(equalTo: dayOfWeekLabel.topAnchor, constant: -50),
            circleImageView.widthAnchor.constraint(equalToConstant: 180),
            circleImageView.heightAnchor.constraint(equalToConstant: 180),

            temperatureMainLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor),
            temperatureMainLabel.centerYAnchor.constraint(equalTo: circleImageView.centerYAnchor, constant: 10),

            cityNameLabel.centerXAnchor.constraint(equalTo: circleImageView.centerXAnchor),
            cityNameLabel.bottomAnchor.constraint(equalTo: temperatureMainLabel.topAnchor),

            windSpeedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            windSpeedLabel.centerYAnchor.constraint(equalTo: weatherDescriptionLabel.centerYAnchor, constant: 100),

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
    
    func startAnimation() {
        // Create a CABasicAnimation for rotation
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = NSNumber(value: Double.pi * 2.0)
        rotationAnimation.duration = 1.0
        circleImageView.layer.add(rotationAnimation, forKey: "spinAnimation")
    }
}
