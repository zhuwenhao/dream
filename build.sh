#!/bin/bash
dart pub get && dart_frog build && dart compile exe build/bin/server.dart -o dream
