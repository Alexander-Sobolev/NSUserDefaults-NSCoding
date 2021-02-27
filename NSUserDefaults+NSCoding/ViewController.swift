//
//  ViewController.swift
//  NSUserDefaults+NSCoding
//
//  Created by Alexander Sobolev on 27.02.2021.
//

import UIKit

// 4. Тут делаем пол
enum SexType: String {
    case male
    case female
}

// 2. Создаем объект модели данных
class UserModel: NSObject, NSCoding { // 19. Теперь поговорим как сохранять в память устройства уже какие то сложные наши значения например классы userModel для этого наследуем его от класса NSObject и подписываем под протокол NSCoding при этом реализуем все его обязательные свойства и методы func encode и required init?(coder: NSCoder)
  
    let name: String
    let surname: String
    let city: String
    let sex: SexType // 3. Пол делаем через перечисление // в модели мы можем сохранять не только свойства тип String, Int, Bool а так же своийсво типа enum
    
    init(name: String, surname: String, city: String, sex: SexType) {
        self.name = name
        self.surname = surname
        self.city = city
        self.sex = sex
    }
    // 20. Кодируем мы с помощью func encode но теперь вызываем свойство .encode
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(surname, forKey: "surname")
        coder.encode(city, forKey: "city")
        coder.encode(sex.rawValue, forKey: "sex")
       }
       
    // 21. С помощью инициализатора декодируем каждое свойство в нужный формат
       required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? "" // 22. декодируем при помощи свойства .decodeObject(forKey: "name") и придумываем ключ к примеру "name" и кастим до типа String данное значение может вернуть опционал поэтому делаем дефолтное значение ?? ""
        surname = coder.decodeObject(forKey: "surname") as? String ?? "" // 23. Тоже самое
        city = coder.decodeObject(forKey: "city") as? String ?? ""
        sex = SexType(rawValue: (coder.decodeObject(forKey: "sex") as! String)) ?? SexType.male // 24. Теперь эту же манипуляцию делаем через rawValue
       }
}

class ViewController: UIViewController {
    
    let cities = ["Mountain View", "Sunnyvale", "Cupertino", "Santa Clara", "San Jose"]
    let sexArray = ["Мужской", "женский"]
    var pickedCity: String?
    var pickedSex: SexType?

    // 1. Создаем Оутлеты
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var surname: UITextField!
    @IBOutlet weak var cityPickerView: UIPickerView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        cityPickerView.delegate = self
        name.delegate = self
        surname.delegate = self
        
        // Проверяем что данные сохраняются
        name.text = UserSettings.userModel.name
    }
    // Скрытие клавиатуры по тапу за пределами textField
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
        }

    @IBAction func nameTextField(_ sender: UITextField) {
        print(name.text)
    }
    
       
        
    
    
    @IBAction func sernameTextField(_ sender: UITextField) {
        print(surname.text)
    }
    
        
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            pickedSex = .male
        case 1:
            pickedSex = .female
        default:
            break
        }
        // 5. Функция .trimmingCharacters удаляет пустые пространства
        let nameTrimmingText = name.text!.trimmingCharacters(in: .whitespaces)
        let surnameTrimmingText = surname.text!.trimmingCharacters(in: .whitespaces)
        print(nameTrimmingText)
        
        guard let pickedCity = pickedCity, let pickedSex = pickedSex else { return }
        // 6. Создаем объект userObject типа UserModel в который после всех проверок передаем нужные данные name: surname: city: sex:
        let userObject = UserModel(name: nameTrimmingText, surname:  surnameTrimmingText, city: pickedCity, sex: pickedSex)
        print(userObject)
        
        
        UserSettings.userName = nameTrimmingText // 17. Теперь воспользуемся созданным static var userName: String! и добавляем туда новое значение nameTrimmingText
        UserSettings.userModel = userObject // 30.4 Тут присваиваем let userObject = UserModel(name: nameTrimmingText, surname:  surnameTrimmingText, city: pickedCity, sex: pickedSex)
        
        print(UserSettings.userName) // 18. Выводим в консоль При этом все поля должны быть заполнены
        print(UserSettings.userModel) // 30.5 Выводим в консоль При этом все поля должны быть заполнены
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let city = cities[row]
        return city
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCity = cities[row]
        print(pickedCity)
    }
}
extension ViewController: UITextFieldDelegate {
    // Скрытие клавиатуры по кнопке Continue
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
