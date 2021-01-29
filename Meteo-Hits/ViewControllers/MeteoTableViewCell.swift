//
//  TableViewCell.swift
//  Meteo-Hits
//
//  Created by Macbook on 27.01.2021.
//

import UIKit

class MeteoTableViewCell: UITableViewCell {

  @IBOutlet weak var tableViewCellName: UILabel!
  @IBOutlet weak var tableViewCellMass: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()

    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
