//
//  InstructionsViewController.swift
//  EyeVerify
//

import UIKit

class InstructionsViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Navigation

     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if let vc = segue.destination as? VerifyResultViewController {
            vc.messageColor = UIColor.black
            vc.message = NSLocalizedString("Enrollment Complete", comment: "")
        }
    }
}
