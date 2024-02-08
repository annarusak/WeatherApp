import UIKit

class ScrollViewElement: UIView {
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .scrollElementBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let dayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Copperplate", size: 18)
        label.text = "-"
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica Neue", size: 24)
        label.text = "-"
        return label
    }()
    
    private let weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "sun.max.fill")
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
            temperatureLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20)
        ])
    }
    
    func updateView(dayOfWeek: String, temperature: Int, weatherCondition: String) {
        dayNameLabel.text = dayOfWeek
        temperatureLabel.text = String(temperature)
    }
    
}
