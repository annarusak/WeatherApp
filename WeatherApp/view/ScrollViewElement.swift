import UIKit

// A custom UIView representing an element in the scroll view displaying weather forecast.
class ScrollViewElement: UIView {
    
    /// The background view of the scroll view element.
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .scrollElementBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    /// Label for displaying the day name.
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Copperplate", size: 18)
        label.text = "-"
        return label
    }()
    
    /// Label for displaying the temperature.
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 24)
        label.text = "-"
        return label
    }()
    
    /// Image view for displaying the weather icon.
    private let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "")
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Set up the user interface elements.
    private func setupUI() {
        self.addSubview(backgroundView)
        self.addSubview(dayNameLabel)
        self.addSubview(temperatureLabel)
        self.addSubview(weatherIcon)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 110),
            backgroundView.heightAnchor.constraint(equalToConstant: 80),
            
            dayNameLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            dayNameLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            
            weatherIcon.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10),
            weatherIcon.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
            weatherIcon.widthAnchor.constraint(equalToConstant: 30),
            weatherIcon.heightAnchor.constraint(equalTo: weatherIcon.widthAnchor),
            
            temperatureLabel.centerYAnchor.constraint(equalTo: weatherIcon.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -17)
        ])
    }
    
    /// Update the view with new data.
    /// - Parameters:
    ///   - dayOfWeek: The name of the day.
    ///   - temperature: The temperature value.
    ///   - icon: The weather icon image.
    func updateView(dayOfWeek: String, temperature: Int, icon: UIImage) {
        dayNameLabel.text = dayOfWeek
        temperatureLabel.text = String(temperature) + "°"
        weatherIcon.image = icon
    }
    
}
