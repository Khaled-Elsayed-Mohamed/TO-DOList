import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class LoginController: UIViewController {
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldConfirmDelegate()
        
      
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
              navigationItem.hidesBackButton = true
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    

    
    @IBAction func SignUpButton(_ sender: UIButton) {
        let signUpVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.signUpVC) as! SignUpController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    

    
    @IBAction func loginButton(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text! ) { (user, error) in
        if let error = error, user == nil {
            self.showSimpleAlert(message: error.localizedDescription)
                }
        else {
             let mainVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.mainVC) as! MainController
            self.navigationController?.pushViewController(mainVC, animated: true)
               }
        }
    }
    
    
}

extension LoginController: UITextFieldDelegate {
    
    func textFieldConfirmDelegate() {
    
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.alpha = 0.2
    }
}
