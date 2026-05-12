# 🏗️ Architecture - UX Improvements

## 📐 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     USER INTERFACE                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  index.html  │  │ruang_ujian.  │  │test-ux-feat. │     │
│  │              │  │    html      │  │    html      │     │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘     │
└─────────┼──────────────────┼──────────────────┼─────────────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                    ┌────────▼────────┐
                    │  CORE LIBRARY   │
                    │ ux-enhancements │
                    │      .js        │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
    ┌─────▼─────┐     ┌─────▼─────┐     ┌─────▼─────┐
    │  Loading  │     │  Logout   │     │   Timer   │
    │   State   │     │Confirmation│     │ Countdown │
    └─────┬─────┘     └─────┬─────┘     └─────┬─────┘
          │                  │                  │
          └──────────────────┴──────────────────┘
                             │
                    ┌────────▼────────┐
                    │  FORM PATCHES   │
                    │form-loading-    │
                    │   patch.js      │
                    └─────────────────┘
```

---

## 🔄 Data Flow

### 1. Loading State Flow

```
User Action (Submit Form)
         │
         ▼
┌────────────────────┐
│  Event Triggered   │
│  (onclick/submit)  │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ loadingState.show()│
│  - Add spinner     │
│  - Disable button  │
│  - Save original   │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Async Operation   │
│  (API call, etc)   │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│ loadingState.hide()│
│  - Remove spinner  │
│  - Enable button   │
│  - Restore text    │
└────────────────────┘
```

### 2. Logout Confirmation Flow

```
User Action (Click Logout / Back Button)
         │
         ▼
┌────────────────────┐
│  Event Intercepted │
│  (click/popstate)  │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│logoutConfirm.show()│
│  - Display modal   │
│  - Wait for input  │
└────────┬───────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌───────┐ ┌───────┐
│Cancel │ │Confirm│
└───┬───┘ └───┬───┘
    │         │
    ▼         ▼
┌───────┐ ┌───────────────┐
│ Hide  │ │ Clear Storage │
│ Modal │ │ Reload Page   │
└───────┘ └───────────────┘
```

### 3. Timer Countdown Flow

```
Page Load
    │
    ▼
┌────────────────────┐
│ examTimer.init()   │
│  - Get schedule    │
│  - Start interval  │
└────────┬───────────┘
         │
         ▼
┌────────────────────┐
│  Every 1 Second    │
│  Update Display    │
└────────┬───────────┘
         │
    ┌────┴────┐
    │         │
    ▼         ▼
┌─────────┐ ┌──────────┐
│Next Exam│ │Current   │
│Countdown│ │Exam Timer│
└────┬────┘ └────┬─────┘
     │           │
     ▼           ▼
┌─────────────────────┐
│  Check Thresholds   │
│  - 10 min warning   │
│  - 5 min danger     │
└─────────────────────┘
```

---

## 🧩 Component Structure

### LoadingState Class

```javascript
class LoadingState {
    constructor()
    ├── createStyles()          // Inject CSS
    ├── show(button, text)      // Show loading
    ├── hide(button)            // Hide loading
    ├── showOverlay(text, sub)  // Full-screen overlay
    └── hideOverlay()           // Hide overlay
}
```

### LogoutConfirmation Class

```javascript
class LogoutConfirmation {
    constructor()
    ├── createModal()           // Create modal HTML
    ├── setupEventListeners()   // Intercept back button
    ├── show()                  // Display modal
    ├── hide()                  // Hide modal
    ├── cancel()                // Cancel logout
    └── confirm()               // Execute logout
}
```

### ExamTimer Class

```javascript
class ExamTimer {
    constructor()
    ├── createStyles()          // Inject CSS
    ├── getExamSchedule()       // Return schedule array
    ├── getNextExam()           // Find next exam
    ├── getCurrentExam()        // Find current exam
    ├── formatTime(ms)          // Format milliseconds
    ├── updateCountdown()       // Update display
    ├── showTimeWarning(msg)    // Show warning modal
    ├── startExamTimer(exam)    // Start exam timer
    └── init()                  // Initialize timer
}
```

---

## 📦 Module Dependencies

```
ux-enhancements.js
├── No external dependencies
├── Uses native JavaScript APIs:
│   ├── DOM API
│   ├── LocalStorage API
│   ├── Date API
│   ├── History API
│   └── CSS Animations
└── Exports:
    ├── window.loadingState
    ├── window.logoutConfirm
    ├── window.examTimer
    └── window.UXEnhancements

form-loading-patch.js
├── Depends on:
│   ├── ux-enhancements.js
│   └── Original submit functions
└── Overrides:
    ├── submitSingleStudent()
    ├── submitPresensiDoc()
    ├── submitBADoc()
    └── validateLogin()
```

---

## 🎨 CSS Architecture

### Style Injection Strategy

```
┌─────────────────────────────────┐
│  ux-enhancements.js loads       │
│           │                      │
│           ▼                      │
│  ┌─────────────────┐            │
│  │ createStyles()  │            │
│  └────────┬────────┘            │
│           │                      │
│           ▼                      │
│  ┌─────────────────┐            │
│  │ Create <style>  │            │
│  │ element with ID │            │
│  └────────┬────────┘            │
│           │                      │
│           ▼                      │
│  ┌─────────────────┐            │
│  │ Append to <head>│            │
│  └─────────────────┘            │
│                                  │
│  Prevents duplicate injection   │
│  (checks for existing ID)       │
└─────────────────────────────────┘
```

### CSS Specificity

```
Priority Level:
1. Inline styles (highest)
2. ID selectors (#loading-overlay)
3. Class selectors (.btn-loading)
4. Element selectors (button)

Our CSS uses:
- Class selectors for components
- ID selectors for unique elements
- No !important (clean override)
```

---

## 🔐 Security Considerations

### 1. XSS Prevention

```javascript
// ✅ Safe: Using textContent
element.textContent = userInput;

// ❌ Unsafe: Using innerHTML with user input
// element.innerHTML = userInput; // NOT USED

// ✅ Safe: Template literals with static content
modal.innerHTML = `<h3>Static Title</h3>`;
```

### 2. LocalStorage Safety

```javascript
// Clear sensitive data on logout
localStorage.removeItem('student_name');
localStorage.removeItem('student_class');
localStorage.removeItem('student_room');
localStorage.removeItem('student_id');

// No sensitive data stored
// Only UI state and user preferences
```

### 3. Event Listener Cleanup

```javascript
// Proper cleanup to prevent memory leaks
window.addEventListener('beforeunload', handler);

// Cleanup when needed
window.removeEventListener('beforeunload', handler);
```

---

## ⚡ Performance Optimization

### 1. Lazy Initialization

```javascript
// Only create modal when needed
if (!document.getElementById('logout-modal')) {
    createModal();
}
```

### 2. Debouncing

```javascript
// Timer updates only once per second
setInterval(() => updateCountdown(), 1000);
// Not on every frame (60fps)
```

### 3. CSS Animations

```javascript
// Use CSS transitions (GPU accelerated)
transition: all 0.3s ease;

// Instead of JavaScript animations
// setInterval(() => { ... }, 16); // NOT USED
```

### 4. Event Delegation

```javascript
// Single listener for multiple buttons
document.addEventListener('click', (e) => {
    if (e.target.matches('.test-btn')) {
        // Handle click
    }
});
```

---

## 🧪 Testing Strategy

### Unit Tests (Manual)

```
test-ux-features.html
├── Test LoadingState
│   ├── show()
│   ├── hide()
│   ├── showOverlay()
│   └── hideOverlay()
├── Test LogoutConfirmation
│   ├── show()
│   ├── hide()
│   ├── confirm()
│   └── cancel()
└── Test ExamTimer
    ├── getNextExam()
    ├── getCurrentExam()
    ├── formatTime()
    └── showTimeWarning()
```

### Integration Tests

```
1. Full Workflow Test
   ├── Loading → Timer → Logout
   └── All features in sequence

2. Production Test
   ├── index.html
   └── ruang_ujian.html
```

---

## 📊 State Management

### Global State

```javascript
window.UXEnhancements = {
    loading: LoadingState instance,
    logout: LogoutConfirmation instance,
    timer: ExamTimer instance
}

// Accessible from anywhere:
window.loadingState.show(btn);
window.logoutConfirm.show();
window.examTimer.getNextExam();
```

### Local State

```javascript
// LoadingState
- activeLoaders: Set<HTMLElement>

// LogoutConfirmation
- (no persistent state)

// ExamTimer
- timers: Array<Interval>
```

---

## 🔄 Lifecycle

### Initialization

```
1. Page Load
   ↓
2. DOMContentLoaded Event
   ↓
3. ux-enhancements.js executes
   ↓
4. Classes instantiated
   ↓
5. Styles injected
   ↓
6. Event listeners attached
   ↓
7. Timer starts
   ↓
8. form-loading-patch.js executes
   ↓
9. Functions overridden
   ↓
10. Ready for user interaction
```

### Cleanup

```
1. User clicks logout
   ↓
2. Confirmation modal
   ↓
3. User confirms
   ↓
4. Clear localStorage
   ↓
5. Stop timers
   ↓
6. Remove event listeners
   ↓
7. Reload page
```

---

## 🎯 Design Patterns Used

### 1. Singleton Pattern
```javascript
// Only one instance per class
window.loadingState = new LoadingState();
```

### 2. Observer Pattern
```javascript
// Event listeners observe user actions
button.addEventListener('click', handler);
```

### 3. Factory Pattern
```javascript
// Create modal elements dynamically
createModal() { ... }
```

### 4. Decorator Pattern
```javascript
// Wrap existing functions with loading state
const original = window.submitForm;
window.submitForm = async function() {
    loadingState.show();
    await original();
    loadingState.hide();
}
```

---

## 📈 Scalability

### Adding New Features

```javascript
// 1. Add new class to ux-enhancements.js
class NewFeature {
    constructor() { ... }
    method() { ... }
}

// 2. Instantiate
window.newFeature = new NewFeature();

// 3. Export
window.UXEnhancements.newFeature = window.newFeature;

// 4. Use anywhere
window.newFeature.method();
```

### Extending Existing Features

```javascript
// Extend LoadingState
class CustomLoadingState extends LoadingState {
    customMethod() {
        // New functionality
    }
}

// Replace instance
window.loadingState = new CustomLoadingState();
```

---

## 🔧 Maintenance

### Code Organization

```
ux-enhancements.js (22KB)
├── LoadingState (8KB)
├── LogoutConfirmation (6KB)
└── ExamTimer (8KB)

form-loading-patch.js (2KB)
└── Function overrides
```

### Version Control

```
Version 1.0.0
├── Initial release
├── All core features
└── Complete documentation

Future versions:
├── 1.1.0 - Sound notifications
├── 1.2.0 - Server sync
└── 2.0.0 - Major refactor
```

---

**Architecture designed for**: Maintainability, Scalability, Performance
