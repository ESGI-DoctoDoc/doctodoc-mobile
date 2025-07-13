# doctodoc_mobile

## Présentation

Docto-doc Mobile est une application mobile Flutter développée pour faciliter la gestion des soins médicaux. Elle permet aux utilisateurs de suivre leurs soins, gérer leurs rendez-vous médicaux, consulter les informations de leurs médecins traitants, et centraliser leurs documents médicaux de manière sécurisée.

## Fonctionnalités principales

- Gestion des rendez-vous médicaux : visualisation des rendez-vous passés et à venir avec leurs détails.
- Accès aux médecins traitants : affichage des informations des professionnels de santé suivis.
- Gestion des documents médicaux : ajout et consultation des documents liés aux soins.
- Historique des soins : aperçu complet des soins reçus ou en cours.
- Interface moderne : application pensée pour un usage fluide et agréable sur mobile.

## Technologies utilisées

- Langages : Dart (Flutter), Kotlin/Java (Android natif)
- Framework : Flutter
- Architecture : Bloc (Business Logic Component), pour une séparation claire entre la logique métier et l’interface
- Gestion des dépendances : pubspec.yaml pour Flutter, Gradle pour l’intégration Android

## Prérequis

Avant de lancer le projet, vous devez avoir installé :

- Flutter SDK
- Android Studio ou un IDE compatible Flutter
- Un émulateur ou un appareil Android/iOS

## Installation

Pour lancer l’application en local :

```bash
git clone https://github.com/corentin-lechene/doctodoc_mobile.git
cd doctodoc_mobile
flutter pub get
flutter run
```