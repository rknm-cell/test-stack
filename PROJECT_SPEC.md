# Stack Project Specification

## Overview
A play-focused social platform that encourages creative activities and community through discovery. Users log moments of creative play and social challenges, then discover how others are playing to find inspiration and motivation. Unlike traditional social media, there are no likes or comments - the focus is on authentic play experiences and community building.

## Tech Stack Architecture

### Frontend (iOS)
- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Reactive Programming**: Combine
- **Animation**: Core Animation
- **Media Handling**: PhotosUI
- **Authentication**: 
  - AuthenticationServices (Apple Sign In)
  - GoogleSignIn (Google authentication)

### Backend (AWS)
- **Compute**: Lambda Functions (Python 3.11)
- **Database**: DynamoDB
- **Storage**: S3 (media files)
- **Authentication**: Cognito
- **API**: API Gateway (REST endpoints)
- **Notifications**: SNS (push notifications)

## Project Structure

```
noomastack/
├── ios-app/                    # iOS SwiftUI Application
│   ├── NoomaStack/
│   │   ├── Views/             # SwiftUI Views
│   │   ├── ViewModels/        # MVVM ViewModels with Combine
│   │   ├── Models/            # Data Models
│   │   ├── Services/          # API Services & Authentication
│   │   ├── Utils/             # Utilities & Extensions
│   │   └── Resources/         # Assets, Localizable strings
│   └── NoomaStack.xcodeproj
├── backend/                    # AWS Lambda Functions
│   ├── functions/
│   │   ├── auth/              # Authentication handlers
│   │   ├── users/             # User management
│   │   ├── media/             # Media upload/processing
│   │   └── notifications/     # Push notification handlers
│   ├── shared/                # Shared utilities
│   └── requirements.txt
├── infrastructure/            # AWS Infrastructure as Code
│   ├── cloudformation/        # CloudFormation templates
│   └── terraform/             # Terraform configurations
└── docs/                      # Documentation
    ├── api/                   # API documentation
    └── deployment/            # Deployment guides
```

## Core Features

### 1. Play Logging System
- **Text-Based Logging**: Simple input form for describing play moments
- **Date Tracking**: Automatic timestamp with manual date selection
- **Optional Location**: Privacy-focused location sharing
- **Activity Categories**: Creative activities and social challenges
- **Future Media Support**: Photo/video logging planned for later phases

### 2. Discovery Feed
- **Unlock Mechanism**: Feed becomes available after first play log
- **Inspiration Focus**: Curated content to motivate more play
- **Activity-Based Discovery**: Find play ideas by category
- **Popular Activities**: Trending creative activities and challenges
- **Seasonal/Themed Content**: Special collections and challenges

### 3. Community Features
- **Following System**: Follow creators and play enthusiasts
- **Activity Groups**: Join communities around specific interests
- **Play Ideas Sharing**: Share creative methods and approaches
- **Collaborative Challenges**: Group activities and competitions
- **No Likes/Comments**: Focus on authentic engagement without validation metrics

### 4. Gamification & Motivation
- **Play Journey Tracking**: Personal progress and milestones
- **Streaks & Achievements**: Consistent play encouragement
- **Popular Activity Insights**: See what's trending in your area/interests
- **Seasonal Challenges**: Themed activities and special events
- **Inspiration Engine**: AI-powered play suggestions based on interests

### 5. User Authentication & Privacy
- **Apple Sign In**: Native iOS integration using AuthenticationServices
- **Google Sign In**: Cross-platform authentication
- **AWS Cognito**: Backend user management and JWT tokens
- **Privacy-First Design**: Optional location, no mandatory personal data

## Technical Implementation Details

### iOS Frontend Architecture

#### MVVM Pattern with Combine
```swift
// Play Logging ViewModel
class PlayLogViewModel: ObservableObject {
    @Published var playEntries: [PlayEntry] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var canAccessFeed = false
    
    private let playService: PlayService
    private var cancellables = Set<AnyCancellable>()
    
    init(playService: PlayService) {
        self.playService = playService
        setupBindings()
    }
    
    private func setupBindings() {
        playService.playEntriesPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.playEntries, on: self)
            .store(in: &cancellables)
        
        // Unlock feed after first log
        $playEntries
            .map { !$0.isEmpty }
            .assign(to: \.canAccessFeed, on: self)
            .store(in: &cancellables)
    }
    
    func logPlay(description: String, category: PlayCategory, location: String? = nil) {
        let entry = PlayEntry(
            id: UUID().uuidString,
            description: description,
            category: category,
            location: location,
            timestamp: Date()
        )
        playService.createPlayEntry(entry)
    }
}

// Discovery Feed ViewModel
class DiscoveryFeedViewModel: ObservableObject {
    @Published var feedItems: [FeedItem] = []
    @Published var trendingActivities: [Activity] = []
    @Published var seasonalChallenges: [Challenge] = []
    
    private let discoveryService: DiscoveryService
    private var cancellables = Set<AnyCancellable>()
    
    init(discoveryService: DiscoveryService) {
        self.discoveryService = discoveryService
        loadFeedContent()
    }
    
    private func loadFeedContent() {
        discoveryService.getFeedItems()
            .receive(on: DispatchQueue.main)
            .assign(to: \.feedItems, on: self)
            .store(in: &cancellables)
    }
}
```

#### SwiftUI Views with Combine Integration
```swift
// Play Logging View
struct PlayLogView: View {
    @StateObject private var viewModel: PlayLogViewModel
    @State private var description = ""
    @State private var selectedCategory: PlayCategory = .creative
    @State private var location = ""
    @State private var showLocationField = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Log Your Play Moment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What did you play today?")
                        .font(.headline)
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                CategoryPicker(selectedCategory: $selectedCategory)
                
                if showLocationField {
                    LocationInput(location: $location)
                }
                
                Button("Add Location") {
                    showLocationField.toggle()
                }
                .foregroundColor(.blue)
                
                Button("Log Play") {
                    viewModel.logPlay(
                        description: description,
                        category: selectedCategory,
                        location: showLocationField ? location : nil
                    )
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(description.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Play Log")
        }
    }
}

// Discovery Feed View
struct DiscoveryFeedView: View {
    @StateObject private var viewModel: DiscoveryFeedViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    // Trending Activities Section
                    TrendingActivitiesSection(activities: viewModel.trendingActivities)
                    
                    // Seasonal Challenges
                    SeasonalChallengesSection(challenges: viewModel.seasonalChallenges)
                    
                    // Feed Items
                    ForEach(viewModel.feedItems) { item in
                        FeedItemCard(item: item)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .move(edge: .trailing)
                            ))
                    }
                }
                .padding()
            }
            .navigationTitle("Discover Play")
            .refreshable {
                await viewModel.refreshFeed()
            }
        }
    }
}
```

#### Core Animation Custom Effects
```swift
extension View {
    func customTransition() -> some View {
        self
            .transition(.asymmetric(
                insertion: .scale.combined(with: .opacity),
                removal: .move(edge: .trailing)
            ))
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
    }
}
```

### AWS Backend Architecture

#### Lambda Function Structure
```python
# Example Lambda handler
import json
import boto3
from typing import Dict, Any

dynamodb = boto3.resource('dynamodb')
s3_client = boto3.client('s3')

def lambda_handler(event: Dict[str, Any], context) -> Dict[str, Any]:
    """
    Main Lambda handler for API Gateway integration
    """
    try:
        # Parse request
        http_method = event['httpMethod']
        path_parameters = event.get('pathParameters', {})
        body = json.loads(event.get('body', '{}'))
        
        # Route to appropriate handler
        if http_method == 'GET':
            return handle_get(path_parameters)
        elif http_method == 'POST':
            return handle_post(body)
        else:
            return create_response(405, {'error': 'Method not allowed'})
            
    except Exception as e:
        return create_response(500, {'error': str(e)})

def create_response(status_code: int, body: Dict[str, Any]) -> Dict[str, Any]:
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(body)
    }
```

#### DynamoDB Data Models
```python
# Play Entry model
class PlayEntry:
    def __init__(self, user_id: str, description: str, category: str, 
                 location: str = None, timestamp: str = None):
        self.entry_id = str(uuid.uuid4())
        self.user_id = user_id
        self.description = description
        self.category = category  # 'creative' or 'social_challenge'
        self.location = location
        self.timestamp = timestamp or datetime.utcnow().isoformat()
        self.created_at = datetime.utcnow().isoformat()
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            'PK': f'USER#{self.user_id}',
            'SK': f'ENTRY#{self.entry_id}',
            'GSI1PK': f'CATEGORY#{self.category}',
            'GSI1SK': self.timestamp,
            'GSI2PK': f'LOCATION#{self.location}' if self.location else 'NO_LOCATION',
            'GSI2SK': self.timestamp,
            'entry_id': self.entry_id,
            'user_id': self.user_id,
            'description': self.description,
            'category': self.category,
            'location': self.location,
            'timestamp': self.timestamp,
            'created_at': self.created_at
        }

# User Profile model
class UserProfile:
    def __init__(self, user_id: str, email: str, name: str, 
                 play_streak: int = 0, total_entries: int = 0):
        self.user_id = user_id
        self.email = email
        self.name = name
        self.play_streak = play_streak
        self.total_entries = total_entries
        self.created_at = datetime.utcnow().isoformat()
        self.updated_at = datetime.utcnow().isoformat()
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            'PK': f'USER#{self.user_id}',
            'SK': f'PROFILE#{self.user_id}',
            'GSI1PK': f'EMAIL#{self.email}',
            'GSI1SK': self.created_at,
            'user_id': self.user_id,
            'email': self.email,
            'name': self.name,
            'play_streak': self.play_streak,
            'total_entries': self.total_entries,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

# Activity Trend model for popular activities
class ActivityTrend:
    def __init__(self, category: str, activity_name: str, 
                 popularity_score: int, location: str = None):
        self.trend_id = str(uuid.uuid4())
        self.category = category
        self.activity_name = activity_name
        self.popularity_score = popularity_score
        self.location = location
        self.timestamp = datetime.utcnow().isoformat()
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            'PK': f'TREND#{self.category}',
            'SK': f'ACTIVITY#{self.activity_name}#{self.timestamp}',
            'GSI1PK': f'POPULARITY#{self.popularity_score}',
            'GSI1SK': self.timestamp,
            'trend_id': self.trend_id,
            'category': self.category,
            'activity_name': self.activity_name,
            'popularity_score': self.popularity_score,
            'location': self.location,
            'timestamp': self.timestamp
        }
```

#### S3 Media Upload Handler
```python
def upload_media_to_s3(file_content: bytes, file_name: str, content_type: str) -> str:
    """
    Upload media file to S3 and return public URL
    """
    bucket_name = os.environ['MEDIA_BUCKET_NAME']
    key = f"media/{uuid.uuid4()}/{file_name}"
    
    s3_client.put_object(
        Bucket=bucket_name,
        Key=key,
        Body=file_content,
        ContentType=content_type,
        ACL='public-read'
    )
    
    return f"https://{bucket_name}.s3.amazonaws.com/{key}"
```

## Development Workflow

### 1. Local Development Setup
- **iOS**: Xcode 15+ with iOS 17+ deployment target
- **Backend**: Python 3.11 with virtual environment
- **AWS CLI**: Configured with appropriate IAM permissions
- **Testing**: XCTest for iOS, pytest for Python

### 2. CI/CD Pipeline
- **iOS**: GitHub Actions for build, test, and TestFlight deployment
- **Backend**: AWS CodePipeline for Lambda deployment
- **Infrastructure**: Terraform for infrastructure provisioning

### 3. Environment Management
- **Development**: Local iOS simulator + AWS dev environment
- **Staging**: TestFlight + AWS staging environment
- **Production**: App Store + AWS production environment

## Security Considerations

### iOS Security
- **Keychain**: Secure storage for sensitive data
- **Certificate Pinning**: SSL certificate validation
- **Code Obfuscation**: Protect against reverse engineering
- **App Transport Security**: Enforce HTTPS connections

### AWS Security
- **IAM Roles**: Least privilege access for Lambda functions
- **VPC**: Private subnets for Lambda functions
- **Encryption**: S3 server-side encryption, DynamoDB encryption at rest
- **API Gateway**: Rate limiting and request validation

## Performance Optimization

### iOS Performance
- **Image Caching**: NSCache for image optimization
- **Lazy Loading**: SwiftUI LazyVStack for large lists
- **Background Processing**: Combine publishers for async operations
- **Memory Management**: Weak references and proper cleanup

### AWS Performance
- **Lambda Optimization**: Cold start mitigation strategies
- **DynamoDB**: Proper indexing and query optimization
- **S3**: CloudFront CDN for media delivery
- **API Gateway**: Response caching and compression

## Monitoring and Analytics

### iOS Monitoring
- **Crashlytics**: Firebase crash reporting
- **Analytics**: Custom analytics events
- **Performance**: Core Data performance monitoring

### AWS Monitoring
- **CloudWatch**: Lambda metrics and logs
- **X-Ray**: Distributed tracing
- **DynamoDB**: Performance insights
- **S3**: Access patterns and costs

## Learning Resources

### Swift & SwiftUI
- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Combine Framework Guide](https://developer.apple.com/documentation/combine)

### AWS Services
- [AWS Lambda Developer Guide](https://docs.aws.amazon.com/lambda/)
- [DynamoDB Developer Guide](https://docs.aws.amazon.com/dynamodb/)
- [API Gateway Developer Guide](https://docs.aws.amazon.com/apigateway/)

### Architecture Patterns
- [iOS Architecture Patterns](https://developer.apple.com/documentation/swiftui/model-data)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## User Experience Flow

### 1. Onboarding & First Play Log
1. **Welcome Screen**: Introduce the concept of play logging
2. **Authentication**: Apple/Google Sign In
3. **First Log Prompt**: Encourage user to log their first play moment
4. **Simple Form**: Text input, category selection, optional location
5. **Feed Unlock**: Celebrate first log and unlock discovery feed

### 2. Daily Play Logging
1. **Quick Log**: Streamlined interface for daily logging
2. **Category Selection**: Creative activities vs social challenges
3. **Location Privacy**: Optional location sharing
4. **Streak Tracking**: Visual progress indicators
5. **Achievement Unlocks**: Milestone celebrations

### 3. Discovery & Inspiration
1. **Feed Access**: Available after first log
2. **Trending Activities**: Popular creative activities
3. **Seasonal Challenges**: Themed activities and events
4. **Following System**: Connect with inspiring players
5. **Activity Groups**: Join communities around interests

### 4. Community Engagement
1. **No Likes/Comments**: Focus on authentic engagement
2. **Play Ideas Sharing**: Share creative methods
3. **Collaborative Challenges**: Group activities
4. **Inspiration Engine**: Personalized suggestions

## Next Steps

1. **Setup Development Environment**
   - Install Xcode and configure iOS development
   - Set up AWS CLI and configure credentials
   - Create initial project structure

2. **Implement Core Features**
   - User authentication flow (Apple/Google Sign In)
   - Play logging system (text-based)
   - Discovery feed (unlock mechanism)
   - Basic user profiles

3. **Add Community Features**
   - Following system
   - Activity groups
   - Trending activities algorithm
   - Seasonal challenges

4. **Enhance User Experience**
   - Gamification (streaks, achievements)
   - Push notifications for motivation
   - Custom animations and transitions
   - Accessibility features

5. **Deploy and Test**
   - Set up CI/CD pipelines
   - Deploy to staging environment
   - Conduct thorough testing
   - User feedback integration

6. **Production Deployment**
   - App Store submission
   - Production AWS environment
   - Monitoring and analytics setup
   - Community moderation tools


This specification provides a comprehensive foundation for learning and implementing a modern iOS app with AWS backend. Each section can be expanded with specific implementation details as you progress through development.
