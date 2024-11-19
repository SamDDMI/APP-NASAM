import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var exploreButton: UIButton!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    @IBOutlet weak var countdownLabel: UILabel!
    
    let eventDate = Calendar.current.date(from: DateComponents(year: 2025, month: 10, day: 15, hour: 10, minute: 0, second: 0)) // Cambia esta fecha por la del evento.
        var countdownTimer: Timer?
    
    let apiManager = NASAAPIManager()
    

    var nasaImages: [NASAImage] = []
        var timer: Timer? // Temporizador para el scroll automático
        var currentIndex = 0 // Índice actual del carrusel
        
        override func viewDidLoad() {
            super.viewDidLoad()
     
                
              
            // Registra la celda programática
            collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
            
            collectionView.delegate = self
            collectionView.dataSource = self
            
            // Configuración del layout
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.itemSize = CGSize(width: self.view.frame.width, height: 250)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
            }
            
            // Llamada a la API
            apiManager.fetchImages(for: "Mars") { result in
                switch result {
                case .success(let images):
                    DispatchQueue.main.async {
                        self.nasaImages = images
                        self.collectionView.reloadData()
                        self.startAutoScroll() // Inicia el scroll automático tras cargar las imágenes
                    }
                case .failure(let error):
                    print("Error al obtener imágenes: \(error)")
                }
            }
            
            eventTitleLabel.text = "Próximo Evento: Lanzamiento de Artemis"
              startCountdown()
          }
          
          func startCountdown() {
              updateCountdown() // Llamar inmediatamente para evitar el retraso inicial.
              countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
          }
          
          @objc func updateCountdown() {
              guard let eventDate = eventDate else { return }
              let currentDate = Date()
              
              let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: eventDate)
              
              if let days = components.day, let hours = components.hour, let minutes = components.minute, let seconds = components.second {
                  countdownLabel.text = "\(days)d : \(hours)h : \(minutes)m : \(seconds)s"
              }
              
              // Detener el temporizador si ya pasó la fecha
              if currentDate >= eventDate {
                  countdownTimer?.invalidate()
                  countdownLabel.text = "¡El evento ha comenzado!"
              }
        }
        
        deinit {
            timer?.invalidate() // Detiene el temporizador al liberar la vista
            countdownTimer?.invalidate()
        }
    @IBAction func exploreButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Cambia "Main" si es necesario
            if let roverVC = storyboard.instantiateViewController(withIdentifier: "RoverViewController") as? RoverViewController {
                self.navigationController?.pushViewController(roverVC, animated: true)
            } else {
                print("No se encontró el controlador de vista con el identificador 'RoverViewController'")
            }
        print("Explora más presionado")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "toRoverSegue" {
            if segue.destination is RoverViewController {
                // Pasa datos a RoverViewController si es necesario
                // roverVC.data = someData
            }
        }
    }

    
        // Número de elementos en el carrusel
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return nasaImages.count
        }
        
        // Crear las celdas del carrusel
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
            
            // Accediendo a la URL de la imagen correctamente
            let imageData = nasaImages[indexPath.row]
            if let imageUrlString = imageData.links?.first?.href,
               let imageUrl = URL(string: imageUrlString) {
                cell.imageView.loadImage(from: imageUrl)
            } else {
                print("No se encontró URL de la imagen")
            }
            
            return cell
        }
        
        // MARK: - Scroll automático
        
        func startAutoScroll() {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextItem), userInfo: nil, repeats: true)
        }
        
        @objc func scrollToNextItem() {
            guard !nasaImages.isEmpty else { return }
            
            currentIndex = (currentIndex + 1) % nasaImages.count // Avanza al siguiente índice, regresa al inicio si es necesario
            
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    // Extensión para cargar imágenes asíncronamente
   





