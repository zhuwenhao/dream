#!/bin/bash
systemctl stop dream
dart pub get && dart_frog build && dart compile exe build/bin/server.dart -o dream
systemctl start dream
