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



//UUID 
let uuid: String = UUID().uuidString 
let imageReference: StorageReference = mediaFolder.child("\(uuid).jpg")

//tabbarController
self.tabbarController?.selectedIndex = 0

//escaping

var completionHandler: [() -> Void] = [] 

func nonescaping(closure: @escaping(String) -> Void) {
    print("function start")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        closure("closure called")
    }
    print("function end")
}

nonescaping{(value) in 
    print(value)
}


//In App Purchase 

cell.acessotyType = .disclosureIndicator 


import StoreKit 

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {

        //App을 만들 때 내가 만들던 Product ID
    let productId: String = "paige.ios_PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad(){
        super.viewDidLoad()

        //Delegate
        SKPaymentQueue.default().add(self)

        if isPurchase() {
            showPremiumQuote()
        }

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotesToShow.count 
        } 
        return quotesToShow.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"QuoteCell", for: indexPath)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 
            cell.textLabel?.textColor = .black 
            cell.accessoryType = .none 
        } else  {
            cell.textLabel?.text = "Get More Quotes" 
            cell.textLabel?.textColor = .blue 
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    } 

    func buyPremiumQuotes(){
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest: SKMutablePayment = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User can't make payment")
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SkPaymentTransaction]) {

        for transaction in transactions {
            if transaction.transactionState == .purchased {
                showPremiumQuote()
                UserDefaults.standard.set(true, forKey: productId)
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(transaction)

                if let error: Error = transaction.error {
                    print("Transaction failed due to error: \(error.localizedDescription)")
                }

            } else if transaction.transactionState == .restored {
                showPremiumQuote()
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }

    }

    func showPremiumQuote(){
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }

    func isPurchased() -> Bool {
        let purchaseStatus: Bool = UserDefaults.standard.bool(forKey: productId)
        if purchaseStatus {
            return true
        }
        return false
    }

    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.defaut().restoreCompletedTransaction()
    }

}

let regularVariable: Int = 1 


func topTwoLongestNames(names: [String]) -> (String, String?){
    let sortedList = names.sorted { (first, second) -> Bool in 
        return first.count > second.count 
    }
    if sortedList.count == 1 {
        return (sortedList[0], nil)
    }
    return (sortedList[0], sortedList[1])
}