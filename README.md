# 🐉 DBHeroes Avanzado iOS App

## 📜 Descripción

Este proyecto a sido desarrollado por **Diego Herreros Parrón**, consiste en la creacion de una app nativa para IOS, ambientada en el mundo de la famosa serie Anime **Dragon Ball**.
 La aplicación permite a los usuarios explorar el universo de Dragon Ball, mostrando un listado de héroes, detalles de cada héroe, sus transformaciones, y ubicaciones en un mapa. La app incluye una pantalla de inicio (Splash Screen) y un sistema de autenticación que utiliza Keychain para el almacenamiento seguro del token de acceso. También se utiliza Core Data para la persistencia de datos.

## 🚀 Características

- **Splash Screen**: Pantalla de inicio que se muestra al abrir la aplicación.
- **Login Seguro**: Autenticación de usuarios con almacenamiento seguro del token utilizando Keychain.
- **Listado de Héroes**: Pantalla principal que muestra una lista de héroes del universo de Dragon Ball.
- **Detalle del Héroe**: Información detallada de cada héroe, incluyendo:
  - Nombre
  - Descripción
  - Listado de transformaciones
  - Mapa con su localizacion
- **Detalles de Transformación**: Pantalla que muestra la imagen, nombre y detalles de cada transformación del héroe.

## 🏗️ Arquitectura

Este proyecto sigue el patrón de arquitectura **MVVM (Model-View-ViewModel)**, que ayuda a separar la lógica de negocio y la presentación de la interfaz de usuario. 

- **Model**: Define los datos y la lógica relacionada, incluyendo la persistencia utilizando Core Data.
- **View**: Las vistas de la aplicación, implementadas utilizando UIKit.
- **ViewModel**: Proporciona la lógica para las vistas, gestionando la interacción entre el Model y el View.


## 🛠️ Tecnologías Utilizadas

- **Swift**: Lenguaje de programación principal.
- **UIKit**: Para la construcción de la interfaz de usuario.
- **Core Data**: Para la persistencia de datos.
- **CoreLocation**: Para manejar las ubicaciones en el mapa.
- **Keychain**: Para el almacenamiento seguro de credenciales.
- **MapKit**: Para mostrar el mapa y las ubicaciones.
- **Patrón de arquitectura:** MVVM

## 💻 Requisitos

- Xcode
- Dispositivo iOS o simulador compatible.

## Instalación

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/dhp85/DBHeroesAvanzado.git

