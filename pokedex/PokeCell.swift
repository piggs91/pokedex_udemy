//
//  PokeCell.swift
//  pokedex
//
//  Created by Ravi Rathore on 4/3/16.
//  Copyright © 2016 Ravi Rathore. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg : UIImageView!
    @IBOutlet weak var label : UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func configureCell(pokemon : Pokemon)
    {
        self.label.text = pokemon.name.capitalizedString
        self.thumbImg.image = UIImage(named: "\(pokemon.pokedexId)")
    }
    
}
