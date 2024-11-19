//
//  ImageCollectionViewCell.swift
//  NASAM
//
//  Created by alumno on 11/11/24.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    // Aquí puedes agregar un UIImageView o cualquier otro componente
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Inicialización del imageView
        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        self.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
