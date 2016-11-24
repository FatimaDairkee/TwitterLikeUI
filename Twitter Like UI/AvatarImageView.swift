import UIKit

class AvatarImageView: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3.0
    }
  
  func scaleAnimationWhileScrolling(forOffset: CGFloat) -> CATransform3D {
     var avatarTransform = CATransform3DIdentity
    let avatarScaleFactor = (min(offset_HeaderStop, forOffset)) / self.bounds.height / 1.4 // Slow down the animation
    let avatarSizeVariation = ((self.bounds.height * (1.0 + avatarScaleFactor)) - self.bounds.height) / 2.0
    avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
    avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)
    return avatarTransform
  }
  
}
