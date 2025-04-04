# Quran App Tools and Resources

## Build Commands

### Standard Build

```bash
flutter build appbundle --release --no-sound-null-safety
```

### Build for Specific Platforms

```bash
flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --no-sound-null-safety
```

### Build with Obfuscation and Debug Info

```bash
flutter build appbundle --target-platform android-arm,android-arm64,android-x64 --no-sound-null-safety --obfuscate --split-debug-info=symbols/
```

### Build Without Tree Shaking Icons

```bash
flutter build appbundle --no-tree-shake-icons
```

---

## Dependency Management

### Check for Outdated Packages

```bash
flutter pub outdated
```

---

## Keystore Management

### Convert Keystore to PKCS12 Format

```bash
keytool -importkeystore -srckeystore upload-keystore.jks -destkeystore upload-keystore.jks -deststoretype pkcs12
```

---

## API Resources

### Surah Audio CDN

[CDN Surah Audio JSON](https://raw.githubusercontent.com/islamic-network/cdn/master/info/cdn_surah_audio.json)

### Quran API

[Al-Quran Cloud API](https://api.alquran.cloud/v1/edition/format/audio)

---

## AI API Endpoints

### Importance of Prayer (Arabic)

- **Bot Endpoint**:  
  [AI Bot](https://islam-ai-api.p.rapidapi.com/api/bot?question="اهميه الصلاة")

- **Chat Endpoint**:  
  [AI Chat](https://islam-ai-api.p.rapidapi.com/api/chat?question="اهميه الصلاة")
