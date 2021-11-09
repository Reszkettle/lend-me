# Firebase backend

To use bellow commands npm and firebase-tools package must be installed and configured.

To use emulators instead of remote firebase server change flag `useEmulators` inside frontend `main.dart` file to true.

## Some usefull commands
`npm install` - install dependencies (run inside functions directory)

`npm --prefix functions run build-watch` - auto compile typescript code on changes (backend directory)

`firebase emulators:start --import path\path` - start firebase emulators and optionally import saved state (backend directory)

`firebase emulators:export path\path` - export current firebase emulators state (backend directory)

`firebase deploy [--only functions]` - deploy project (backend directory)

When emulators says that some port is occupied try
- `netstat -ano | findStr "8080"` - check pid of process which is listening on port 8080
- `taskkill /F /PID <pid>` - kill this process

