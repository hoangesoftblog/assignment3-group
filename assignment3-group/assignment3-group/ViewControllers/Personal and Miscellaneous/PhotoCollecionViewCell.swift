import UIKit

class PhotoCollectionViewCell : UICollectionViewCell {
    var roundNumber : CGFloat = 12
    
 
    
    @IBOutlet weak var imageViewInCell: UIImageView!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = roundNumber
        contentView.layer.masksToBounds = true
    }
    
}