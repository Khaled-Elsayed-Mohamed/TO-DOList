import UIKit
import TextFieldEffects
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SignUpController: UIViewController {

    @IBOutlet weak var userNameTextField: HoshiTextField!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
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
    
   
    private func isValidEmail(_ email: String) -> Bool {
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: email)
       }
    
    private func isValidPassword(_ password: String) -> Bool {
           let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
           let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
           return passwordPred.evaluate(with: password)
       }
    
    private func isValidData() -> Bool {
        if let userName = userNameTextField.text, !userName.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty {
             return true
         }
         return false
     }
    
 
    
    func showSimpleAlert(message: String) {
        let alert = UIAlertController(title: "Alert?", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func goToMainVC() {
        let mainVC = UIStoryboard.init(name: Storyboards.main, bundle: nil).instantiateViewController(withIdentifier: VCs.mainVC) as! MainController
        navigationController?.pushViewController(mainVC, animated: true)
    }

    
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
         Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error {
                callback?(e)
                   return
            }
            let userData = ["userName": self.userNameTextField.text,
            "email": self.emailTextField.text,
            "password": self.passwordTextField.text]
            self.ref.child("users").child(user?.user.uid ?? "").setValue(userData)
               callback?(nil)
           }
     }
    
    
    @IBAction func SignUpButton(_ sender: UIButton) {
        
        if isValidData() {
            
            createUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                if let e = error {
                    self.showSimpleAlert(message: e.localizedDescription)
                } else {
                    
                    self.goToMainVC()
                }
            }
        } else {
            
            self.showSimpleAlert(message: "Please fill are fields")
        }
        
    }
    
    
    @IBAction func LoginButton(_ sender: UIButton) {
        
        
        let loginVC = UIStoryboard.init(name: Storyboards.main  , bundle: nil).instantiateViewController(withIdentifier: VCs.signInVC) as! LoginController
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
}


extension SignUpController: UITextFieldDelegate {
    
    func textFieldConfirmDelegate() {
    
        userNameTextField.delegate = self
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
