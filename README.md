# KashtatK

KashtatK is a SwiftUI-based iOS application designed to simplify the process of searching and browsing products. By leveraging the ModelView (MV) pattern, along with dedicated services for API calls, KashtatK offers a streamlined, data-driven user experience. This application allows users to search through products by trends, popularity, or specific keywords, view a list of products, and access detailed information about each product.

## Features

- **Search Functionality**: Users can search for products based on trends, popularity, or specific keywords.
- **Product Listing**: View a comprehensive list of products.
- **Product Details**: Access detailed information about each product, including descriptions, prices, and availability.

## Architecture

KashtatK is built using the SwiftUI framework, focusing on a clean architecture that includes the following layers:

### ModelView (MV)

The core architectural pattern of the app, where Models represent the data and business logic, and Views are responsible for presenting the UI. This pattern facilitates a direct binding between the Model and the View, ensuring a reactive and dynamic user experience.

### Services

Services are responsible for handling all API calls and network communications, abstracting these operations away from the UI layer. This includes fetching data for searches, product listings, and product details.

### Layers

#### Network Layer

Handles all network requests, responses, and error handling. It's the backbone of our Services, ensuring reliable data retrieval and submission.

#### Navigation Stack Layer

Manages the navigation and flow of the application, utilizing SwiftUI's native navigation capabilities to offer a seamless user experience.

#### SwiftData for Data Persistence

Utilizes SwiftData to manage local data persistence, allowing for offline access to previously loaded data and enhancing the app's performance.

## Getting Started

To get started with KashtatK, clone the repository to your local machine.

