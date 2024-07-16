import Foundation
import UIKit
import CoreLocation

class GameController: UIViewController {

    var utilisatorName: String?
    var scoreWinner: Int?
    var userLocation: CLLocation?

    var timer: Timer?
    let cardImages = [
        "14_of_clubs", "2_of_clubs", "3_of_clubs", "4_of_clubs", "5_of_clubs", "6_of_clubs", "7_of_clubs", "8_of_clubs", "9_of_clubs", "10_of_clubs", "11_of_clubs", "12_of_clubs", "13_of_clubs",
        "14_of_diamonds", "2_of_diamonds", "3_of_diamonds", "4_of_diamonds", "5_of_diamonds", "6_of_diamonds", "7_of_diamonds", "8_of_diamonds", "9_of_diamonds", "10_of_diamonds", "11_of_diamonds", "12_of_diamonds", "13_of_diamonds",
        "14_of_hearts", "2_of_hearts", "3_of_hearts", "4_of_hearts", "5_of_hearts", "6_of_hearts", "7_of_hearts", "8_of_hearts", "9_of_hearts", "10_of_hearts", "11_of_hearts", "12_of_hearts", "13_of_hearts",
        "14_of_spades", "2_of_spades", "3_of_spades", "4_of_spades", "5_of_spades", "6_of_spades", "7_of_spades", "8_of_spades", "9_of_spades", "10_of_spades", "11_of_spades", "12_of_spades", "13_of_spades"
    ]
    let cardReturnImage = "returnC"

    @IBOutlet weak var imageD: UIImageView!
    @IBOutlet weak var imageL: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var scoreD: UILabel!
    @IBOutlet weak var scoreL: UILabel!
    @IBOutlet weak var nameD: UILabel!
    @IBOutlet weak var nameL: UILabel!
    
    var currentTime = 50
    var rounds = 0
    var isCardExposed = false
    var scoreDValue = 0
    var scoreLValue = 0

    let referencePoint = CLLocation(latitude: 32.1150, longitude: 34.817549168324334)

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabelsBasedOnLocation()
        startGame()
    }

    func updateLabelsBasedOnLocation() {
        guard let name = utilisatorName else { return }
        if let location = userLocation {
            print("User location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            if location.coordinate.longitude > referencePoint.coordinate.longitude {
                nameD.text = name
                nameL.text = "PC"
            } else {
                nameL.text = name
                nameD.text = "PC"
            }
        } else {
            nameD.text = name
        }
    }

    func startGame() {
        updateTimerLabel()
        showRandomCards()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
    }

    @objc func updateGame() {
        if rounds < 10 {
            currentTime -= 1
            updateTimerLabel()
            if isCardExposed {
                if currentTime % 5 == 2 {
                    hideCards()
                }
            } else {
                if currentTime % 5 == 0 {
                    showRandomCards()
                    updateTimerLabel()
                }
            }
        } else {
            endGame()
        }
    }

    func updateTimerLabel() {
        time.text = "\(10 - rounds)"
    }

    func showRandomCards() {
        isCardExposed = true
        let cardImage1 = getRandomCardImage()
        let cardImage2 = getRandomCardImage()

        UIView.transition(with: imageD, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.imageD.image = UIImage(named: cardImage1)
        }, completion: nil)

        UIView.transition(with: imageL, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.imageL.image = UIImage(named: cardImage2)
        }, completion: nil)

        rounds += 1
        updateScores(card1: cardImage1, card2: cardImage2)
    }

    func hideCards() {
        isCardExposed = false

        UIView.transition(with: imageD, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.imageD.image = UIImage(named: self.cardReturnImage)
        }, completion: nil)

        UIView.transition(with: imageL, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.imageL.image = UIImage(named: self.cardReturnImage)
        }, completion: nil)
    }

    func getRandomCardImage() -> String {
        return cardImages.randomElement() ?? "14_of_clubs"
    }

    func endGame() {
        timer?.invalidate()
        performSegue(withIdentifier: "Score", sender: self)
    }

    func extractCardValue(card: String) -> Int {
        let parts = card.split(separator: "_")
        if let value = Int(parts[0]) {
            return value
        }
        return 0
    }

    func updateScores(card1: String, card2: String) {
        let value1 = extractCardValue(card: card1)
        let value2 = extractCardValue(card: card2)
        if value1 > value2 {
            scoreDValue += 1
        } else if value2 > value1 {
            scoreLValue += 1
        }
        updateScoreLabels()
    }

    func updateScoreLabels() {
        scoreD.text = "Score: \(scoreDValue)"
        scoreL.text = "Score: \(scoreLValue)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Score" {
            if let destinationVC = segue.destination as? ScoreGame {
                if scoreDValue > scoreLValue {
                    destinationVC.winnerName = nameD.text
                    destinationVC.score = scoreDValue
                } else if scoreDValue < scoreLValue {
                    destinationVC.winnerName = nameL.text
                    destinationVC.score = scoreLValue
                } else {
                    if nameD.text == "PC" {
                        destinationVC.winnerName = nameD.text
                        destinationVC.score = scoreDValue
                    } else {
                        destinationVC.winnerName = nameL.text
                        destinationVC.score = scoreLValue
                    }
                }
            }
        }
    }
}
