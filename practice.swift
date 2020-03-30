func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions){

    if let _ = Auth.auth().currentUser {
        let storybaord: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyboard.instantiateViewController(identifier: "UITabBarController") as! UITabBarController   
        window?.rootViewController = tabbar
    }

    guard let _ = (scene as? UIWindowSecene) else { return }

}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMedaWithInfo info: [UIImagePickerController.InfoKey : Any]){
    imageView.image = info[.originalImage] as? UIImage 
    dismiss(animated: true, completion: nil)
}

@IBAction func uploadButtonClicked(_ sender: UIButton){

    let storage = Storage.storage()
    let storageReference = storage.reference()
    let mediaFolder = storageReference.child("media")

    guard let data = imageView.image?.jpegData(compressionQuality: 0.5) else { return }

    let imageReference = mediaFolder.child("image.jpg")

    imageReference.putData(data, metadata: nil) {(metadata, error) in 
        if let error = error {
            return 
        }
        imageReference.downloadURL{(url, error) in 
            if let error = error {
                return 
            }
            guard let imageURL = url?.absoluteString else { return }
        }
    }

}


import UIKit 
import Social 
import MobileCoreServices 

class ShareViewController: SLComposeServiceViewController {

     var sharedIdentifier = "group.com.superdemopaige"
     var selectedImage: UIImage! 
     var maxCharacterCount = 100 

     override func viewDidLoad(){
         super.viewDidLoad()
         placeholder = "Write Content Here"
     }

     override func isContentValid() -> Bool {
         if let currentMessage = contentText {
            let currentMessageLength = currentMessage.lenght 
            charactersRemaining = (maxCharacterCount - currentMessageLength) as NSNumber 

            if Int(truncating: charactersRemaining) < 0 {
                showMessage(title: "Sorry", message: "Enter only 100 characters", VC: self)
            }

         }
     }

    override func didSelectPost(){
        dataAttachment()
    }

    func dataAttachment() {
        let content = extensionContext!.inputItems[0] as NSExtensionItem 
        let contentType = kUTTypeImage as String 

        for attachment in content.attachments! {

            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { (data, error) in 
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOf: url as URL) {
                            self.saveDataToUserDefault(suiteName: self.sharedIdentifier, dataKey: "Image", dataValue: imageData)
                        }
                    }
                }
            }

            saveDataToUserDefault(suiteName: self.sharedIdentifier, dataKey: "Name", dataValue: contentText as AnyObject)

        }

    }

    lazy var UserConfigurationItem: SLComposeSheetConfigurationItem = {
        let item = SLComposeSheetConfigurationItem()
        item?.title = "What's on your mind?"
        return item!
    }()

    override func configurationItem() -> [Any] {
        return [UserConfigurationItem]
    }

    func saveDataToUserDefault(suiteName: String, dataKey: String, dataValue: AnyObject){
        if let prefs = UserDefaults(suiteName: suiteName) {
            prefs.removeObject(forKey: dataKey)
            prefs.set(dataValue, forKey: dataKey)
        }
    }


    func showMessage(title: String, message: String!, VC: UIViewController){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        VC.present(alert, animated: true, completion: nil)
    }


}



import UIKit 
import MobileCoreServices 

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var txtViewContent: UITextView! 
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    var sharedIdentifier = "group.com.superdemopaige"

    override func viewDidLoad(){
        fetchData()
        setupUI()
    }

    func setupUI(){
        txtViewContent.needsUpdateConstraints()
        contentHeight.constant = txtViewContent.contentSize.height 
    }

    func fetchData(){
        if let prefs = UserDefaults(suiteName: sharedIdentifier) {
            if let imageData = prefs.object(forKey: "Image") as? NSData {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData as Data)
                }
            }
            if let nameText = prefs.object(forKey: "Name"){
                self.txtViewContent.text = nameText as? String 
            }
        }
    }

}


var completionHandler: [() -> Void] = [] 

func nonescaping(closure: @escaping(string) -> Void) {
    print("function starts")
    DispatchQueue.main.async(deadline: .now() + 2) {
        closure("closure called")
    }
    print("function ends")
}



func filterWithPredicateClosure(closure: (Int) -> Bool, numbers: [Int]) -> [Int] {
    var numArray: [Int] = [Int]()
    for num in numbers {
        if closure(num){
            numArray.append(num)
        }
    }
}

let filteredList = filterWithPredicateClosure(closure: {(num) -> Bool in 
    return num < 5 
}, numbers: [1, 2, 3, 4, 5])

let numbers = [1, 2, 3, 4, 5, 6, 7]

let filteredArray = numbers.filter({return $0 % 2 == 0})
let transformedArry = numbers.map({return $0 * 3})
let sum = numbers.reduce(0,{sum, number in sum + number})
let sum2 = numbers.reduce(0){(sum, number) -> Int in 
    return sum + number 
}
let sum3 = numbers.reduce(0, {$0 + $1})
var sum4: Int = 0 
numbers.forEach{(number) in 
    sum4 += number 
}
var sum5: Int = 0 
numbers.forEach{sum5 += $0}
