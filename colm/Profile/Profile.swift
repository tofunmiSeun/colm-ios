struct Profile: Identifiable, Codable, Hashable {
    var id: String;
    var username: String;
    var name: String?;
    var description: String?;
    
    static var mock = Profile(id: "profile123", username: "tofunmi_og",
                              name: "Tofunmi", description: "Founder @mitri")
    
    static var mock_2 = Profile(id: "profile_xts", username: "bot_man",
                              name: "Botty", description: "Bot that yaps")
}
