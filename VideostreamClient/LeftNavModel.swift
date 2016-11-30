import Foundation
import SwiftyJSON

struct NavCellModel {
    
    enum Action{
        case show(screen: String)
        case code(code: String)
    }
    
    let image: String
    let title: String
    
    let action: Action
    
}

struct LeftNavModel {
    let bodyCells: [NavCellModel]
    let footerCells: [NavCellModel]
    
    static func fromJSON(_ json:JSON) -> LeftNavModel {
        
        var bodyCells: [NavCellModel] = []
        for data in json["body"]["buttonStack"].array! {
            
            bodyCells.append(NavCellModel(image: data["image"].stringValue,
                                          title: data["title"].stringValue,
                                          action: NavCellModel.Action.show(screen: data["action"]["show"].stringValue)))
        }
        
        var footerCells: [NavCellModel] = []
        for data in json["footer"]["buttonStack"].array! {
            
            var action: NavCellModel.Action
            
                if let code = data["action"]["code"].string {
                    action = NavCellModel.Action.code(code: code)
                } else {
                    action = NavCellModel.Action.show(screen: data["action"]["show"].stringValue)
            }
        
            footerCells.append(NavCellModel(image: data["image"].stringValue,
                                            title: data["title"].stringValue,
                                            action:action))
        }
        
        return LeftNavModel(bodyCells: bodyCells, footerCells: footerCells)
    }
}
