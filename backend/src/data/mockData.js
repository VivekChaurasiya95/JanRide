export const stops = [
  { id: 'S1', name: 'Hazira', lat: 26.2348, lng: 78.1844, city: 'Gwalior', landmark: 'Near Bus Stand' },
  { id: 'S2', name: 'Maharaj Bada', lat: 26.2018, lng: 78.1644, city: 'Gwalior', landmark: 'City Center' },
  { id: 'S3', name: 'Phool Bagh', lat: 26.2122, lng: 78.1806, city: 'Gwalior', landmark: 'Garden Gate' },
  { id: 'S4', name: 'Railway Station', lat: 26.2183, lng: 78.1828, city: 'Gwalior', landmark: 'Main Entrance' },
  { id: 'S5', name: 'DB Mall', lat: 26.2203, lng: 78.2052, city: 'Gwalior', landmark: 'Front Gate' },
];

export const routes = [
  {
    route_id: 'R1',
    vehicle: 'tempo',
    stops: ['S1', 'S3', 'S2'],
    legs: [
      { from: 'S1', to: 'S3', fare: 10, durationMinutes: 6 },
      { from: 'S3', to: 'S2', fare: 8, durationMinutes: 5 },
    ],
  },
  {
    route_id: 'R2',
    vehicle: 'auto',
    stops: ['S1', 'S4', 'S5'],
    legs: [
      { from: 'S1', to: 'S4', fare: 12, durationMinutes: 8 },
      { from: 'S4', to: 'S5', fare: 10, durationMinutes: 7 },
    ],
  },
  {
    route_id: 'R3',
    vehicle: 'e-rickshaw',
    stops: ['S5', 'S2'],
    legs: [{ from: 'S5', to: 'S2', fare: 15, durationMinutes: 11 }],
  },
  {
    route_id: 'R4',
    vehicle: 'tempo',
    stops: ['S3', 'S4'],
    legs: [{ from: 'S3', to: 'S4', fare: 7, durationMinutes: 4 }],
  },
];

export const analytics = {
  heatmap: [
    { stop_id: 'S2', searchCount: 250, timeSlot: '18:00' },
    { stop_id: 'S4', searchCount: 189, timeSlot: '09:00' },
    { stop_id: 'S1', searchCount: 120, timeSlot: '08:30' },
  ],
  peakHours: [
    { hour: '08:00', demandScore: 0.72 },
    { hour: '18:00', demandScore: 0.89 },
    { hour: '19:00', demandScore: 0.81 },
  ],
};

export const crowdReports = [];

