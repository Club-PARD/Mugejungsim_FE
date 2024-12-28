import UIKit

class SavedPhotoCell: UICollectionViewCell {
    let imageView = UIImageView()
    let categoryLabel = UILabel()
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with photoData: PhotoData) {
        if let image = DataManager.shared.loadImage(from: photoData.imagePath) {
            imageView.image = image
        }
        categoryLabel.text = "카테고리: \(photoData.category)"
        textLabel.text = photoData.text
    }
}
