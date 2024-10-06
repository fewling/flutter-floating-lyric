# Workflow Diagrams for Floating Lyrics App

## Project Structure (v4.0.0+20)

### High Level Overview

```mermaid
flowchart RL
    data["Data Sources"]
    repo["Repository"]
    service["Service"]
    bloc["Bloc"]
    ui["UI"]

    data --> | Data | repo
    repo --> | DTO | service
    service --> | Data Model | bloc
    bloc --> | State | ui

    ui --> | event | bloc
    bloc --> | params | service
    service --> | data | repo
    repo --> | request | data
```

### A Slightly More Complex Situation

```mermaid
flowchart TD
    data1["Data Source 1"]
    data2["Data Source 2"]
    data3["Data Source 3"]
    data4["Data Source 4"]
    data5["Data Source 5"]

    repo1["Repository 1"]
    repo2["Repository 2"]
    repo3["Repository 3"]
    repo4["Repository 4"]

    service1["Service 1"]
    service2["Service 2"]
    service3["Service 3"]

    bloc1["Bloc 1"]
    bloc2["Bloc 2"]
    bloc3["Bloc 3"]

    ui1["UI 1"]
    ui2["UI 2"]

    data1 --> repo1
    data2 --> repo2
    data3 --> repo2
    data3 --> repo3
    data4 --> repo4
    data5 --> repo4

    repo1 --> service1
    repo2 --> service2
    repo3 --> service3
    repo4 --> service3

    service1 --> bloc1
    service2 --> bloc2
    service3 --> bloc3
    
    bloc1 --> ui1
    bloc2 --> ui2
    bloc3 --> ui2
```

---
> ⚠️⚠️⚠️
> **Deprecation Notice:**
> **Below may need to be updated according to the latest breaking changes (v4.0.0).**

## 1. Onboarding + Permissions

```mermaid
sequenceDiagram
    participant A as User
    participant B as Onboarding
    participant C as Native Android
    participant D as Main Screen
    A->>B: Open App
    B->>C: Request Permissions (Notification)
    C->>B: Permissions Status
    B->>C: Request Permissions (Overlay)
    C->>B: Permissions Status
    B->>D: Navigate
```

## 2. Set Up Event Channel of `MediaState`

```mermaid
sequenceDiagram
    participant A as Flutter
    participant B as `MainActivity`
    participant C as `MediaStateStreamHandler`
    participant D as `MediaStateBroadcastReceiver`

    A->>B: Event channel name/id
    B->>C: Pass `context`
    C->>D: Register
```

## Lyric Update Workflow

```mermaid
flowchart TD
    A[MediaStateNotificationListener] --> |Broadcast song info | B[MediaStateBroadcastReceiver]
    B --> |Event sink song info | C[Flutter `mediaStateChannel`]
    C --> |Stream song info | D[Flutter Floating Window Manager]
    D --> E{Has active `MediaState`?}
    E --> |Yes| F[Update `duration` & `position` accordingly]
    E --> |No| G[Do nothing]
    F --> H{Is `title` or `artist` changed?}
    H --> |No| I{`currentLyrics` not null?}
    I --> |Yes| J[Update `currentLine` state]
    I --> |No| K[Set `currentLine` to 'No lyrics found']
    H --> |Yes| L1[Update `title` & `artist` state]
    L1 --> L2[Set `currentLyrics` to null]
    L2 --> M{Local lyrics found?}
    M --> |Yes| N[Update `currentLyrics` state]
    M --> |No| O[Fetch lyrics from API]
    O --> P{Lyrics found?}
    P --> |Yes| Q[Update `currentLyrics` state]
    Q --> R[Save lyrics to local storage]
    P --> |No| S[Set `currentLine` to 'No lyrics found']
    J --> T[Update floating window]
```

## Flutter x Android Communication

```mermaid
flowchart TD

    subgraph Flutter
        mediaStateStream["mediaStateStream"]
        windowStateStream["windowStateStream"]
        floatingWindowNotifier["FloatingWindowNotifier"]
        homeScreenNotifier["HomeScreenNotifier"]
        methodInvoker["FloatingWindowMethodInvoker"]
        lyricStateProvider["lyricStateProvider"]

        windowStateStream --> floatingWindowNotifier
        floatingWindowNotifier --> homeScreenNotifier

        mediaStateStream --> lyricStateProvider
        lyricStateProvider --> | subscription | methodInvoker
        homeScreenNotifier -.-> | user | methodInvoker
    end

    subgraph Android
        mainActivity["MainActivity"]

        subgraph FloatingWindow
            floatingWindow["FloatingWindow"]
            windowEventStreamHandler["WindowEventStreamHandler"]
            methodCallHandler["WindowMethodCallHandler"]
            windowStateBroadcastReceiver["WindowStateBroadcastReceiver"]

            windowEventStreamHandler --> | register & init with `eventSink` | windowStateBroadcastReceiver
            methodCallHandler --> floatingWindow
            floatingWindow -.-> | `onClose` | windowStateBroadcastReceiver
        end

        subgraph MediaState
            mediaNotificationListener["MediaNotificationListener"]
            mediaStateStreamHandler["MediaStateEventStreamHandler"]
            mediaStateBroadcastReceiver["MediaStateBroadcastReceiver"]

            mediaStateStreamHandler --> | register & init with `eventSink` | mediaStateBroadcastReceiver
            mediaNotificationListener --> | if active: periodic | mediaStateBroadcastReceiver
        end
    end

    mainActivity --> | init with `context` | windowEventStreamHandler
    mainActivity --> | init with `context` | mediaStateStreamHandler

    windowStateBroadcastReceiver --> | event channel: `WindowState` | windowStateStream
    mediaStateBroadcastReceiver --> | event channel: `MediaState` | mediaStateStream

    methodInvoker --> | method channel | methodCallHandler

```
