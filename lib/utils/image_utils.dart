String getDestinationImage(int index) {
  const imageUrls = [
    'https://images.unsplash.com/photo-1565249421254-0dac5c0d1f92', // Nairobi
    'https://images.unsplash.com/photo-1594038910668-d8bdb455bd39', // Maasai Mara
    'https://images.unsplash.com/photo-1578248072635-821f0724f35a', // Mombasa
    'https://images.unsplash.com/photo-1582868178236-d6284e38b2e2', // Mount Kenya
  ];
  return imageUrls[index % imageUrls.length];
}

String getTrendingImage(int index) {
  const imageUrls = [
    'https://images.unsplash.com/photo-1517957754645-478d877b108c', // Nairobi National Park
    'https://images.unsplash.com/photo-1586350511092-0fa8d4ff2b1f', // Diani Beach
    'https://images.unsplash.com/photo-1598547922178-4154e5b6b4c7', // Amboseli National Park
    'https://images.unsplash.com/photo-1598467111908-d2e78005d1d2', // Tsavo National Park
    'https://images.unsplash.com/photo-1571669742994-0e46189e10a5', // Lake Nakuru
  ];
  return imageUrls[index % imageUrls.length];
}
