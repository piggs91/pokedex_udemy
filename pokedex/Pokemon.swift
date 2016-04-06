//
//  Pokemon.swift
//  pokedex
//
//  Created by Ravi Rathore on 4/3/16.
//  Copyright © 2016 Ravi Rathore. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon : NSObject{
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var nextEvolutionLvl: String {
        get {
            if _nextEvolutionLvl == nil {
                _nextEvolutionLvl = ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var nextEvolutionTxt: String {
        
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId: String {
        
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    override var description: String {
        
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(pokemonURLString)\(self._pokedexId)"
    }
    
    func downloadPokemonData(onCompletion : () -> ()){
        if let url = NSURL(string: "\(pokemonURLString)\(self._pokedexId)"){
            //now make request for data.
            print("Downloading pokemon data \(url)")
            Alamofire.request(.GET, url).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?,result: Result<AnyObject>) -> Void in
                // print(result.value)
                if let data = result.value{
                    //if we have got anyvalue
                    if  let dict  = data as? Dictionary<String , AnyObject>{
                        if let weight = dict["weight"] as? String {
                            self._weight = weight
                        }
                        
                        if let height = dict["height"] as? String {
                            self._height = height
                        }
                        
                        if let attack = dict["attack"] as? Int {
                            self._attack = "\(attack)"
                        }
                        
                        if let defense = dict["defense"] as? Int {
                            self._defense = "\(defense)"
                        }
                       
                        var finalType = ""
                        if let dicts = dict["types"] as? [Dictionary<String , AnyObject>]{
                            for type in dicts{
                                if let newData = type["type"] as? Dictionary<String , AnyObject>{
                                    
                                    if finalType == ""
                                    {
                                    finalType += newData["name"]! as! String
                                    }
                                    else{
                                        finalType += "/"
                                        finalType += newData["name"]! as! String
                                    }
                                    
                                }
                            }
                        }
                        //print(finalType)
                        self._type = finalType
                        
                        
                        if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                            
                            if let url = descArr[0]["resource_uri"] {
                                let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                                
                                Alamofire.request(.GET, nsurl).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?,result: Result<AnyObject>) -> Void in
                                    
                                    let desResult = result.value
                                    if let descDict = desResult as? Dictionary<String, AnyObject> {
                                        
                                        if let description = descDict["description"] as? String {
                                            self._description = description
                                            print(self._description)
                                        }
                                    }
                                    
                                    onCompletion()
                                }
                            }
                            
                        } else {
                            self._description = ""
                        }
                        
                        
                        if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0{
                            
                            if let to = evolutions[0]["to"] as? String {
                                
                                //Can't support mega pokemon right now but
                                //api still has mega data
                                if to.rangeOfString("mega") == nil {
                                    
                                    if let uri = evolutions[0]["resource_uri"] as? String {
                                        
                                        let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                        
                                        let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                        
                                        self._nextEvolutionId = num
                                        self._nextEvolutionTxt = to
                                        
                                        if let lvl = evolutions[0]["level"] as? Int {
                                            self._nextEvolutionLvl = "\(lvl)"
                                        }
                                        
                                        print(self._nextEvolutionId)
                                        print(self._nextEvolutionTxt)
                                        print(self._nextEvolutionLvl)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            })
        }
    }
   //override var descr
    //public var description: String { get }
    
}