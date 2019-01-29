import UIKit

class SOSViewController: UIViewController {


    let screenSize: CGRect = UIScreen.main.bounds
    let window = UIApplication.shared.keyWindow


    let resetPasswordDescription: UILabel = {
        let screenSize: CGRect = UIScreen.main.bounds
        let window = UIApplication.shared.keyWindow
        
        let lbl = UILabel(frame: CGRect(x: (window?.safeAreaInsets.right)! , y: UIScreen.main.bounds.size.height * 0.1, width: UIScreen.main.bounds.size.width * 0.75 , height: UIScreen.main.bounds.size.height * 0.5))
        lbl.textAlignment = .center
        lbl.text = "The SOS view is made for emergencies. The way it works is that, the app will contineously monotor your speed. If it sees great alterations, going from high speeds to almost standstill in about 30 seconds. It will assume that if you do not move in five minutes, it will send a message to your friends and will ask them to check up on you"
        lbl.numberOfLines = 0
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()

    let dismiss: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        btn.addTarget(self, action: #selector(dismissbutton), for: .touchUpInside)
        return btn
    }()
    
    @objc func dismissbutton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    let resetingPasswordTextField: UITextView = {
        let text = UITextView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height * 0.5, width: UIScreen.main.bounds.size.width * 0.6, height: UIScreen.main.bounds.size.height * 0.04))
        text.keyboardAppearance = .dark
        text.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        text.layer.borderWidth = 1
        text.textColor = .black
        text.keyboardType = .default
        text.layer.cornerRadius = 5
        return text
    }()
    

    
override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(resetPasswordDescription)
    
    //Setting the label in the middle of the screen
    resetPasswordDescription.center.x = self.view.center.x
    view.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
    view.addSubview(dismiss)
    view.addSubview(resetingPasswordTextField)
    resetingPasswordTextField.center.x = view.center.x
//    setNavigationBar()
    
}

func setNavigationBar() {
    let screenSize: CGRect = UIScreen.main.bounds
    let window = UIApplication.shared.keyWindow
    
    let navBar = UINavigationBar(frame: CGRect(x: 0, y: (window?.safeAreaInsets.top)!, width: screenSize.width, height: 70))
    let navItem = UINavigationItem(title: "SOS")
    let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
    navItem.rightBarButtonItem = doneItem
    navBar.setItems([navItem], animated: false)
    self.view.addSubview(navBar)
}


@objc func done() {
    self.dismiss(animated: true, completion: nil)
}


}
