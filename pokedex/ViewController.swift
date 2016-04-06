//
//  ViewController.swift
//  pokedex
//
//  Created by Ravi Rathore on 4/3/16.
//  Copyright © 2016 Ravi Rathore. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    private static var cellIdentifier = "PokeCell"
   @IBOutlet weak var collectionView : UICollectionView!
    private var pokemons = [Pokemon]()
    private var filteredPokemons = [Pokemon]()
    private var inSearchMode = false
    private var musicPlayer : AVAudioPlayer!
    @IBOutlet weak var search: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActiveOrInactive:", name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationWillResignActiveOrInactive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.parsePokemonCSV()
        self.setupAudio()
        self.search.delegate = self
        self.search.returnKeyType = .Done
      }
    func setupAudio(){
        if let filePath = NSBundle.mainBundle().pathForResource("music", ofType: "mp3") {
        
            if let url = NSURL(string: filePath){
                do{
                    self.musicPlayer = try AVAudioPlayer(contentsOfURL: url)
                    self.musicPlayer.prepareToPlay()
                    self.musicPlayer.numberOfLoops = -1
                    self.musicPlayer.play()
                }
                catch{
                    print(error)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func parsePokemonCSV(){
        if let filePath = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv") {
            do{
            let data =  try CSV(contentsOfURL: filePath)
            let rows = data.rows
                for row in rows{
                    if let name = row["identifier"] , id = Int(row["id"]!){
                        let pokemon = Pokemon(name: name, pokedexId: id)
                        self.pokemons.append(pokemon)
                    }
                }
            }
            catch{
               print(error)
            }
        }
        
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let pokemon = self.inSearchMode ? self.filteredPokemons[indexPath.row] : self.pokemons[indexPath.row]
        
        
        performSegueWithIdentifier(Segues.DetailVC.rawValue , sender: pokemon)
       // BlurredActivityIndicatorView.sharedInstance.startActivityIndicator(se)
    }
    // MARK : - collection view datasource methods
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.cellIdentifier, forIndexPath: indexPath) as? PokeCell{
            let pokemon: Pokemon!
            if inSearchMode{
             
                 pokemon = self.filteredPokemons[indexPath.row]
            }
            else{
                pokemon = self.pokemons[indexPath.row]
            }
            cell.configureCell(pokemon)
            return cell
            
        }
        else{
            return UICollectionViewCell()
        }
    }
    
    @IBAction func musicButtonPressed(sender: AnyObject) {
        
        let sender = sender as! UIButton
        if self.musicPlayer.playing{
            self.musicPlayer.stop()
            sender.alpha = 0.2
        }
        else{
            self.musicPlayer.play()
            sender.alpha  = 1.0
        }
        
    }
    
    
    func collectionView(collectisonView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
       return  self.inSearchMode ? self.filteredPokemons.count : self.pokemons.count
        
    }
    
    func applicationWillResignActiveOrInactive(notification :NSNotification){
       
        if notification.name == UIApplicationDidBecomeActiveNotification{
            if !musicPlayer.playing{
            musicPlayer.play()
            }
        }
        else if notification.name == UIApplicationWillResignActiveNotification{
            musicPlayer.stop()
        }
    }
   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier!{
        case Segues.DetailVC.rawValue :
            if let poke = sender as? Pokemon
            {
                if let destinationVC = segue.destinationViewController as? PokemonDetailVC{
                   // destinationVC
                    destinationVC.pokemon = poke
                }
            }
        default:
            break
            
            
        }
    }


}
extension ViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            self.resignFirstResponder()
          //  collectionView.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            
            filteredPokemons = pokemons.filter(){
                pokemon in
                if((pokemon.name.rangeOfString(lower)) != nil){
                    print(pokemon.name)
                    
                    return true
                }
                return false
            }
            print(filteredPokemons.description)
            collectionView.reloadData()
        }
    }}



