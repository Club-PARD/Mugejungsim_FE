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

        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        categoryLabel.textColor = .darkGray
        contentView.addSubview(categoryLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textColor = .black
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            categoryLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            textLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 2),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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
