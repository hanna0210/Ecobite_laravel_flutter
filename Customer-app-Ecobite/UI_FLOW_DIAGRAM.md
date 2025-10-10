# Customer Registration UI - Visual Flow & Layout

## 📱 Screen Layouts

### 1. Registration Screen Layout

```
┌─────────────────────────────────────────┐
│  [← Back]                               │
├─────────────────────────────────────────┤
│                                         │
│          [App Branding Image]           │
│              (20% height)               │
│                                         │
├─────────────────────────────────────────┤
│                                         │
│         Join Us                         │
│    Create an account now                │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │   [f] Sign up with Facebook     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │   [G] Sign up with Google       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │   [] Sign up with Apple         │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ─────────────  OR  ─────────────      │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Name                            │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Email                           │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ [🇺🇸 +1] Phone                 │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Password                        │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Referral Code (optional)        │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ☑ I agree with Terms & Conditions     │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      Create Account             │   │
│  └─────────────────────────────────┘   │
│                                         │
│    Already have an Account? Login      │
│                                         │
└─────────────────────────────────────────┘
```

### 2. OTP Verification Screen Layout

```
┌─────────────────────────────────────────┐
│  [← Back]                               │
├─────────────────────────────────────────┤
│                                         │
│          [OTP Image Icon]               │
│            (200x200)                    │
│                                         │
│         Verify Your Phone               │
│                                         │
│  We sent a verification code to         │
│          +1 234 567 8900                │
│                                         │
├─────────────────────────────────────────┤
│           Enter Code                    │
│                                         │
│     ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐     │
│     │ 1 │ │ 2 │ │ 3 │ │ 4 │ │ 5 │ │ 6 │     │
│     └───┘ └───┘ └───┘ └───┘ └───┘ └───┘     │
│                                         │
│   Didn't receive the code? (30)        │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │           Verify                │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      Edit Phone Number          │   │
│  └─────────────────────────────────┘   │
│                                         │
│            🔒                           │
│  Your information is protected with     │
│   industry-standard encryption          │
│                                         │
└─────────────────────────────────────────┘
```

## 🔄 User Flow Diagrams

### Standard Email/Phone Registration Flow

```
┌─────────────┐
│   Landing   │
│    Page     │
└─────┬───────┘
      │
      v
┌─────────────────┐
│  Registration   │
│     Screen      │
└────┬────────────┘
     │
     │ Fill Form
     │ Accept Terms
     │ Click "Create Account"
     │
     v
┌─────────────────┐
│  OTP Verify     │
│     Screen      │
└────┬────────────┘
     │
     │ Enter 6-digit code
     │ Click "Verify"
     │
     v
┌─────────────────┐
│   Home Screen   │
│  (Logged In)    │
└─────────────────┘
```

### Social Login Registration Flow

```
┌─────────────────┐
│  Registration   │
│     Screen      │
└────┬────────────┘
     │
     │ Click Social Button
     │ (Google/Facebook/Apple)
     │
     v
┌─────────────────┐
│  Social Auth    │
│   Provider      │
└────┬────────────┘
     │
     ├─ Existing User ─────────────┐
     │                             │
     │                             v
     │                    ┌─────────────────┐
     │                    │   Home Screen   │
     │                    │  (Logged In)    │
     │                    └─────────────────┘
     │
     ├─ New User ──────────────────┐
     │                             │
     │                             v
     │                    ┌─────────────────┐
     │                    │  Registration   │
     │                    │ (Pre-filled)    │
     │                    └────┬────────────┘
     │                         │
     │                         v
     │                    ┌─────────────────┐
     │                    │  OTP Verify     │
     │                    └────┬────────────┘
     │                         │
     │                         v
     │                    ┌─────────────────┐
     │                    │   Home Screen   │
     │                    └─────────────────┘
     │
     v
  [Error]
```

## 🎨 Color Scheme & Typography

### Colors Used:
- **Primary Color**: AppColor.primaryColor
- **Background**: AppColor.faintBgColor (white/light gray)
- **Text**: 
  - Titles: Black (semiBold, xl2)
  - Subtitles: Gray600 (light)
  - Labels: Default text color (sm)
- **Buttons**: 
  - Primary: AppColor.primaryColor (white text)
  - Outline: Border with default text
- **OTP Boxes**:
  - Active: AppColor.primaryColor
  - Selected: AppColor.primaryColor
  - Inactive: Grey.shade300
  - Fill: White

### Typography Hierarchy:
```
Title (xl2, semiBold)         → "Join Us", "Verify Your Phone"
Subtitle (light, gray600)     → Descriptions
Body (default)                → Form labels
Button Text (semiBold)        → Action buttons
Small (sm)                    → Helper text, links
```

## 📐 Spacing Guidelines

### Padding:
- Screen edges: 20px
- Between sections: 12-20px
- Form fields: 8px vertical
- Social buttons: 8px between

### Element Heights:
- Buttons: 50px
- Text fields: Default (≈48px)
- Social buttons: Default from package
- OTP boxes: 55px

## 🎯 Interactive Elements

### Registration Screen:
1. **Country Picker**: Tap flag/code to select country
2. **Social Buttons**: Tap to authenticate with provider
3. **Checkbox**: Toggle terms acceptance
4. **Terms Link**: Tap to view full terms
5. **Create Button**: Submits form (with validation)
6. **Login Link**: Navigate to login screen

### OTP Screen:
1. **PIN Boxes**: Auto-focus, auto-advance
2. **Resend Link**: Enabled after countdown
3. **Edit Phone**: Go back to registration
4. **Verify Button**: Submit OTP code

## 📱 Responsive Behavior

### Keyboard Handling:
- Bottom padding adjusts when keyboard appears
- ScrollView ensures all fields visible
- Form fields remain accessible

### Screen Sizes:
- Small phones: Reduced image height
- Tablets: Centered content with max width
- Large screens: Optimized spacing

## ♿ Accessibility

### Features:
- Clear labels on all form fields
- High contrast text and buttons
- Large touch targets (min 48x48dp)
- Screen reader support via semantic widgets
- Error messages clearly communicated
- Loading states with indicators

## 🔔 Feedback & States

### Loading States:
- Button shows spinner during:
  - Registration submission
  - OTP verification
  - Social authentication
  - Resend code request

### Error States:
- Form validation errors inline
- API errors via toast/alert
- Network errors with retry option

### Success States:
- Toast confirmation on success
- Auto-navigation to next screen
- Clear progress indication

## 🌈 Animation & Transitions

### Subtle Animations:
- Page transitions: Slide from right
- Button press: Scale feedback
- PIN entry: Fade animation
- Field focus: Border highlight
- Loading: Circular progress

### Timing:
- Transitions: 300ms
- Countdown: 1 second intervals
- Auto-advance: Immediate on 6th digit

---

## 📊 Summary

✅ **2 Main Screens**: Registration + OTP Verification
✅ **3 Social Options**: Google, Facebook, Apple
✅ **Clean UX**: Minimal steps, clear feedback
✅ **Responsive**: Works on all devices
✅ **Accessible**: Follows best practices
✅ **Secure**: OTP verification required

**Result**: Professional, modern registration experience! 🎉

