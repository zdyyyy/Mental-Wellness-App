if Genre.exists?
  puts "Seed data already present, skipping."
  return
end

unless User.exists?(username: "demo")
  User.create!(
    username: "demo",
    password: "demo123",
    first_name: "Demo",
    last_name: "User",
    email: "demo@mindlift.app"
  )
end

[
  ["Classical", "https://picsum.photos/seed/classical/400"],
  ["Electronic", "https://picsum.photos/seed/electronic/400"],
  ["Country", "https://picsum.photos/seed/country/400"],
  ["Hip Hop", "https://picsum.photos/seed/hiphop/400"]
].each do |name, cover|
  genre = Genre.create!(name: name, cover_url: cover)

  case name
  when "Classical"
    [
      ["Calm Waters", "MindLift Ensemble", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", "https://picsum.photos/seed/song1/300"],
      ["Gentle Dawn", "Serenity Strings", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", "https://picsum.photos/seed/song2/300"]
    ]
  when "Electronic"
    [
      ["Neon Pulse", "Echo Grid", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", "https://picsum.photos/seed/song3/300"]
    ]
  when "Country"
    [
      ["Open Road", "Willow Creek", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", "https://picsum.photos/seed/song4/300"]
    ]
  when "Hip Hop"
    [
      ["Steady Flow", "Urban Calm", "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", "https://picsum.photos/seed/song5/300"]
    ]
  else
    []
  end.each do |title, artist, url, song_cover|
    Song.create!(genre: genre, title: title, artist: artist, url: url, cover_url: song_cover)
  end
end

puts "Seeded demo user (demo / demo123) and music catalog."
