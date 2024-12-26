# Sudoku Mobile

A modern, feature-rich Sudoku game built with Flutter and Firebase. Experience the classic puzzle game with a modern twist, featuring real-time multiplayer competitions, personalized statistics, and a sleek user interface.

## Features

### Game Features
- 🎮 Four difficulty levels with unique solving algorithms:
  - Easy: Perfect for beginners with guided assistance
  - Medium: Balanced challenge for casual players
  - Hard: Complex puzzles for experienced players
  - Expert: Ultimate challenge with minimal starting numbers
- 🎯 Smart hint system that teaches solving techniques
- 📝 Advanced note-taking system with:
  - Pencil marks for candidates
  - Color coding for solving strategies
  - Auto-remove notes when placing numbers
- ⏱️ Sophisticated timer with:
  - Pause/resume functionality
  - Time-based scoring system
  - Personal best tracking
- 💾 Seamless progress saving:
  - Auto-save on every move
  - Multiple save slots
  - Cross-device synchronization
- 🎨 Modern UI/UX:
  - Smooth cell animations
  - Gesture controls
  - Dark/Light theme support
  - Customizable grid colors
- 🔊 Interactive feedback:
  - Sound effects for actions
  - Haptic feedback
  - Victory animations

### Online Features
- 👤 User System:
  - Email/password authentication
  - Social media login integration
  - Custom user profiles
  - Achievement badges
- 🏆 Competitive Features:
  - Global leaderboards
  - Difficulty-specific rankings
  - Weekly challenges
  - Tournament mode
- 📊 Statistics & Analytics:
  - Detailed solve time analytics
  - Success rate by difficulty
  - Strategy usage tracking
  - Progress over time graphs
- 🌟 Achievement System:
  - Progressive challenges
  - Skill-based rewards
  - Daily objectives
  - Special event achievements
- 🔄 Real-time Features:
  - Live score updates
  - Instant leaderboard updates
  - Friend activity feed
  - Challenge notifications

## Technical Implementation

### Core Game Engine
- Custom Sudoku generator with guaranteed unique solutions
- Efficient solving algorithm for hint generation
- Real-time validation system
- Progressive difficulty scaling

### State Management
- Provider for local state
- Firebase for remote state
- Optimistic updates for better UX
- Conflict resolution for offline play

### Firebase Architecture
- Authentication:
  ```
  /users/{userId}
    - profile
    - statistics
    - achievements
    - gameProgress
  ```
- Leaderboards:
  ```
  /leaderboards/{difficulty}
    - global
    - weekly
    - monthly
  ```
- Game Data:
  ```
  /games/{gameId}
    - puzzle
    - solution
    - difficulty
    - statistics
  ```

### Security & Performance
- Comprehensive Firebase security rules
- Client-side move validation
- Score verification system
- Optimized data queries
- Caching for offline play

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- iOS: Xcode 12.0+
- Android: Android Studio with SDK 21+

### Quick Start
1. Clone the repository:
```bash
git clone https://github.com/avixiii-dev/sodoku_mobile.git
cd sudoku_mobile
```

2. Install dependencies:
```bash
flutter pub get
```

3. Firebase Configuration:
   - Create a Firebase project
   - Enable Authentication & Firestore
   - Add configuration files:
     ```
     android/app/google-services.json
     ios/Runner/GoogleService-Info.plist
     ```

4. Run the app:
```bash
flutter run
```

## Development

### Project Structure
```
lib/
├── models/          # Data models
├── services/        # Business logic
├── screens/         # UI screens
├── widgets/         # Reusable components
├── utils/           # Helper functions
└── config/          # App configuration
```

### Key Components
- `GameEngine`: Core Sudoku logic
- `AuthService`: User authentication
- `LeaderboardService`: Rankings management
- `StatisticsService`: Player analytics

## Contributing

1. Fork the repository
2. Create your feature branch:
```bash
git checkout -b feature/amazing-feature
```
3. Commit your changes:
```bash
git commit -m 'Add amazing feature'
```
4. Push to the branch:
```bash
git push origin feature/amazing-feature
```
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

Avixiii - [@avixiii](https://twitter.com/avixiii)

Project Link: [https://github.com/avixiii-dev/sodoku_mobile](https://github.com/avixiii-dev/sodoku_mobile)

## Acknowledgments

- Flutter team for the framework
- Firebase team for backend services
- Contributors and users
- Sudoku community for inspiration
