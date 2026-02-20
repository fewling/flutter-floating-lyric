# Overlay App Architecture

The overlay app is a standalone Flutter app that runs in a separate isolate. It is responsible for displaying the floating lyric window and handling user interactions with it.

The architecture of the overlay app is designed to be modular and scalable. It consists of the following layers:

```mermaid
flowchart TD

    subgraph mainApp[Main-App]
        msgToOverlayBloc["Message-To-Overlay-Bloc"]
    end


    subgraph overlayApp[Overlay-App]
        subgraph overlayBlocs[Blocs]
            msgFromMainBloc["Message-From-Main-Bloc"]
            lyricFinderBloc["Lyric-Finder-Bloc"]
            overlayWindowBloc["Overlay-Window-Bloc"]
        end

        msgFromMainBloc --> | songInfo | lyricFinderBloc
        msgFromMainBloc --> | songInfo | overlayWindowBloc
        lyricFinderBloc --> | lrc | overlayWindowBloc
    end

    msgToOverlayBloc --> | ToOverlayMsg | msgFromMainBloc
```
