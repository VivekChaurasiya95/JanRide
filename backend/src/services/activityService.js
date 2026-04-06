import { v4 as uuid } from 'uuid';

const dashboardSummary = {
  tripsTaken: 14,
  tripsChangePercent: 20,
  moneySaved: 42.5,
  moneySavedChangePercent: 15,
  carbonKg: 12.4,
  carbonMonthlyTargetKg: 20,
  carbonPercentOfLimit: 62,
  carbonWeeklySavedKg: 5.6,
};

const referral = {
  title: 'Refer & Earn Rs 20',
  body: 'Invite friends to JanRide and get credits for your next 5 trips.',
  rewardAmount: 20,
};

const favoriteRoutes = [
  {
    id: 'FR1',
    title: 'Home to Office',
    description: '12.4 miles - 25 mins avg',
    fareRange: 'Rs 40 - Rs 60',
    status: 'Next Auto in 3 mins',
    icon: 'home',
  },
  {
    id: 'FR2',
    title: 'Gym Session',
    description: '3.8 miles - 10 mins avg',
    fareRange: 'Rs 15 - Rs 25',
    status: 'Tempo arriving soon',
    icon: 'fitness',
  },
];

const history = [
  {
    id: 'H1',
    routeTitle: 'Maharaj Bada to Hazira Square',
    dateLabel: 'Today, 08:30 AM',
    fare: 20,
    durationLabel: '21 mins',
    status: 'completed',
  },
  {
    id: 'H2',
    routeTitle: 'Railway Station to Phool Bagh',
    dateLabel: 'Yesterday, 06:10 PM',
    fare: 50,
    durationLabel: '10 mins',
    status: 'completed',
  },
];

const startedTrips = [];

export function getActivityDashboard() {
  return {
    summary: dashboardSummary,
    referral,
    favoriteRoutes,
  };
}

export function getActivityHistory() {
  return history;
}

export function startTrip({ routeId }) {
  const matchedRoute = favoriteRoutes.find((r) => r.id === routeId);
  const trip = {
    id: uuid(),
    routeId,
    routeTitle: matchedRoute?.title ?? 'Custom Route',
    startedAt: new Date().toISOString(),
    status: 'started',
  };
  startedTrips.push(trip);
  return trip;
}

