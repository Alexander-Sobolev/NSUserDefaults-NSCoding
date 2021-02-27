//
//  UserSettings.swift
//  NSUserDefaults+NSCoding
//
//  Created by Alexander Sobolev on 27.02.2021.
//

import Foundation

final class UserSettings { // 7. Создаем класс UserSettings
    
    // 13. Делаем приватный энум в котором будем хранить ключи
    private enum SettingsKeys: String {
        case userName
        case userModel // 26. Создаем новый кейс userModel
    }
       
    // 25. Теперь добовляем новое свойство с помощью которого мы будем сохранять userModel внутри UserDefaults
    static var userModel: UserModel! {
        get { // 30.2 Тут декодируем уже через класс NSKeyedUnarchiver и свойство .unarchiveTopLevelObjectWithData и кастим до UserModel
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.userModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? UserModel else { return nil }
            return decodedModel // 30.3 тут возвращаем let decodedModel = try? декодированный
        }
          set {
            let defaults = UserDefaults.standard // 27. Создаю defaults
            let key = SettingsKeys.userModel.rawValue // 28. Делаю ключ
            
            if let userModel = newValue { // 29. newValue специальное свойство которое есть в set вынимаем из него опционал
                
            // 30. userModel это модель let userModel: UserModel и ее нужно сконвертировать в let savedData: Data и только потом вставить в UserDefaults // try? так как тут функция может вернуть и ошибку далее с помощью класса под названием NSKeyedArchiver достаем функцию .archivedData(withRootObject: requiringSecureCoding:) в withRootObject: передаем userModel которая декодируется в Data
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false) {
                    print("value: \(userModel) was added to key \(key)")
                    defaults.set(savedData, forKey: key) // 30.1 в .set выбираем любое
                } else {
                    defaults.removeObject(forKey: key)
                }
            }
        }
    }
    // 8. Делаем свойство типа String для сохранения имени пользователя
    static var userName: String! {
        get { // 16. Тут используя UserDefaults мы достаем значение при помощи функции .string(forKey: String) 8:12
            return UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue)
        } set {
            // 9. Тут описываем что будет происходить когда данное свойство будет получать новое значение
            let defaults = UserDefaults.standard // 11. Если я хочу добавить name в UserDefaults тоесть в память устройства я сначала должен добраться до объекта UserDefaults
            let key = SettingsKeys.userName.rawValue // 14. Делаем этот ключ из энума и подставляем его в 12 forKey: key Все мы добавили значение не просто в userName а сразу в память устройства с помощью UserDefaults
            if let name = newValue { // 10. newValue специальное свойство которое есть в set вынимаем из него опционал
                print("value: \(name) was added to key \(key)")
                defaults.set(name, forKey: key) // 12. Теперь у данного свойства defaults я могу вызвать функцию set которая имеет огромное колличество различных конструкторов url Bool Double Float etc.
            } else {
                defaults.removeObject(forKey: key) // 15. Если не удалось достать новое значение удаляем у объекта defaults данный объект по ключу key
            }
        }
    }
}
