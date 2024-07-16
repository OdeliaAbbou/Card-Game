
import Foundation
import UIKit


class ScoreGame: UIViewController {

    var winnerName: String?
    var score: Int?


    @IBOutlet weak var Score_BTN_BTM: UIButton!
    @IBOutlet weak var Winner_Score: UILabel!
    @IBOutlet weak var Winner_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = winnerName {
            Winner_name.text = name
                }
                if let score = score {
                    Winner_Score.text = "\(score)"
                }
    }
    


    @IBAction func BackToMenuClicked(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    
        
        
}
