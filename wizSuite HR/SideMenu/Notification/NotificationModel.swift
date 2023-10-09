//
//  NotificationModel.swift
//  wizSuite HR
//
//  Created by vibhuti gupta on 20/09/23.
//

import UIKit

//{
//    "message": "Notification Found.",
//    "status": true,
//    "data": [
//        {
//            "id": "1",
//            "title": "Meta is reportedly working on a new, more powerful AI model",
//            "message": "OpenAI-s GPT-4, has by far been, the most advanced and popular of the flurry of large language models in the AI sector. And while several of the biggest names in tech have started rolling out their own versions and advancements in the field of LLMs — IBM being the latest — GPT-4 remains kind of a clear winner. Social media giant Meta though, is looking to overturn that, as it has reportedly started working an LLM model that could rival GPT-4 and will be fairly advanced compared with its own Llama models.",
//            "type": "VMS Techs",
//            "created_at": "2023-09-20 11:06:11"
//        }
//    ]
//}

struct NotificationModel : Decodable {
    
    let message : String?
    let status :Bool?
    let data:  [NotificationDataModel]?
    
    enum CodingKeys: String, CodingKey{
        
        case message = "message"
        case status = "status"
        case data = "data"
        
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.status = try container.decodeIfPresent(Bool.self, forKey: .status)
        self.data = try container.decodeIfPresent(Array.self, forKey: .data)
        
    }
    
}


struct NotificationDataModel : Decodable {
    
    let id : String?
    let title :String?
    let message: String?
    let type: String?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey{
        
        case id = "id"
        case title = "title"
        case message = "message"
        case type = "type"
        case createdAt = "created_at"
       
    }
    
    init(from decoder: Decoder) throws{
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
    
}


