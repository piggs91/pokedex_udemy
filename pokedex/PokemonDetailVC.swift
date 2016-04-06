//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Ravi Rathore on 4/4/16.
//  Copyright © 2016 Ravi Rathore. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
     internal var pokemon : Pokemon!
    
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionImg: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var defenceLabel: UILabel!
    
    @IBOutlet weak var evolutionLabel: UILabel!
    @IBOutlet weak var pokedexId: UILabel!
    
    @IBOutlet weak var baseAttack: UILabel!
    
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        BlurredActivityIndicatorView.sharedInstance.startActivityIndicator(self.view)
        self.nameLabel.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        self.mainImg.image = img
        self.pokemon.downloadPokemonData { () -> () in
            self.updateUI()
            BlurredActivityIndicatorView.sharedInstance.stopActivityIndicator()
        }
    }
    
    func updateUI() {
        self.descriptionImg.text = pokemon.description
        self.typeLabel.text = pokemon.type
        self.defenceLabel.text = pokemon.defense
       self.heightLabel.text = pokemon.height
        self.pokedexId.text = "\(pokemon.pokedexId)"
        self.weightLabel.text = pokemon.weight
        baseAttack.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            self.evolutionLabel.text = "No Evolutions"
            nextEvoImage.hidden = true
        } else {
            nextEvoImage.hidden = false
            nextEvoImage.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution: \(pokemon.nextEvolutionTxt)"
            
            if pokemon.nextEvolutionLvl != "" {
                str += " - LVL \(pokemon.nextEvolutionLvl)"
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
