struct ViewModel: Hashable, Equatable {
    let fullName: String
    let name: String
    let song: String
    let releaseDate: String
    let rights: String
    let imageUrl: String
    let audioUrl: String
    let id: String
    
    static func ==(lhs: ViewModel, rhs: ViewModel) -> Bool {
           return lhs.id == rhs.id
       }
       
       func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }
}
