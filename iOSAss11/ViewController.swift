//
//  ViewController.swift
//  iOSAss11
//
//  Created by мак on 26.11.2024.
//

import UIKit
import Alamofire
import Kingfisher


struct Hero: Decodable {
    let name: String
    let slug: String
    let biography: Biography
    let images: HeroImage
    let powerstats: PowerStats

    struct Biography: Decodable {
        let fullName: String
    }
    
    struct PowerStats: Decodable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }

    struct HeroImage: Decodable {
        let sm: String
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var heroImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var slugLabel: UILabel!
    
    @IBOutlet weak var intelligenceLabel: UILabel!
    
    @IBOutlet weak var strenthLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    @IBOutlet weak var durabilityLabel: UILabel!
    
    @IBOutlet weak var powerLabel: UILabel!
    
    @IBOutlet weak var combatLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func setRandomHero(_ sender: Any) {
        let randomId = Int.random(in: 1...563)
        fetchRandomHero(randomId)
    }
    
    func fetchRandomHero(_ id: Int) {
        let urlString = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        print(urlString)
        
        AF.request(urlString, method: .get, encoding: URLEncoding.default).responseDecodable(of: Hero.self) { response in
            switch response.result {
            case .success(let hero):
                self.handleHeroData(hero: hero)
            case .failure(let error):
                print(error)
                self.fillLabelsForErrorResponse()
            }
        }
    }
    
    func handleHeroData(hero: Hero) {
        DispatchQueue.main.async {
            self.setImageFromUrl(string: hero.images.sm)
            self.nameLabel.text = hero.name
            self.fullNameLabel.text = hero.biography.fullName
            self.slugLabel.text = hero.slug
            self.fillHeroStatsLabels(hero)
        }
    }
    
    private func fillLabelsForErrorResponse() {
        self.setNotFoundImage()
        self.nameLabel.text = "Try Again"
        self.fullNameLabel.text = ""
        self.slugLabel.text = ""
        self.fillHeroStatsLabelsForIncorrectResponse()
    }
    
    private func fillHeroStatsLabels(_ hero: Hero) {
        let heroStats = hero.powerstats
        intelligenceLabel.text = "Intelligence: \(heroStats.intelligence)"
        strenthLabel.text = "Strength: \(heroStats.strength)"
        speedLabel.text = "Speed: \(heroStats.speed)"
        durabilityLabel.text = "Durability: \(heroStats.durability)"
        powerLabel.text = "Power: \(heroStats.power)"
        combatLabel.text = "Combat: \(heroStats.combat)"
    }
    
    private func fillHeroStatsLabelsForIncorrectResponse() {
        intelligenceLabel.text = "Intelligence: 0"
        strenthLabel.text = "Strength: 0"
        speedLabel.text = "Speed: 0"
        durabilityLabel.text = "Durability: 0"
        powerLabel.text = "Power: 0"
        combatLabel.text = "Combat: 0"
    }

    private func setImageFromUrl(string: String) -> Void {
        let heroImageURL = URL(string: string)
        heroImage.kf.setImage(with: heroImageURL)
    }
    
    private func setNotFoundImage() {
        heroImage.image = UIImage(named: "notfound")
    }
    
}

