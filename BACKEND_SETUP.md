# Backend Setup Guide

This document explains how to deploy the **full, containerized backend** for Nuptial Flight Predictor v3 using Docker Compose.

---

## 1. Prerequisites

-   [Docker](https://www.docker.com/products/docker-desktop)
-   [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

---

## 2. One-Step Deployment

The entire backend stack (Database, CORS Proxy, Map Tile Server) is managed by Docker Compose.

### Step 1: Configure Your Environment

1.  **Copy the Example Environment File:**
    ```bash
    cp assets/env.example assets/.env
    ```
2.  **Edit `assets/.env`:**
    You **must** define `ARANGO_ROOT_PASSWORD` and `OPENWEATHERMAP_API_KEY`. The other URLs should point to your new local services.

    ```env
    # For ArangoDB container
    ARANGO_ROOT_PASSWORD=your_super_secret_password

    # Points to the local Docker tile server
    MAP_TILES_URL=http://localhost:8080/data/your_map_file_name/{z}/{x}/{y}.png

    # Points to the local Docker CORS proxy
    CORS_PROXY_URL=http://localhost:3000/cors/https://maps.googleapis.com/maps/api
    
    # Other keys...
    OPENWEATHERMAP_API_KEY=xxxxxxxxxxxxxxxx
    ...
    ```
    > **Important:** Replace `your_map_file_name` in `MAP_TILES_URL` with the actual name of the `.mbtiles` file you downloaded.

### Step 2: Download Map Data

-   Download an `.mbtiles` file (e.g., from [OpenMapTiles](https://openmaptiles.com/downloads/planet/)) and place it inside the `tiles/` directory.
-   See `tiles/README.md` for more details.

### Step 3: Launch the Backend

-   **For Linux/macOS:**
    ```bash
    chmod +x deploy.sh
    ./deploy.sh
    ```
-   **For Windows:**
    ```bash
    .\deploy.bat
    ```

This command will build the proxy image, pull the necessary Docker images, and start all services in the background.

---

## 3. Managing Services

-   **View Logs:**
    ```bash
    docker-compose logs -f
    ```
-   **Stop Services:**
    This will stop and remove the containers, but your ArangoDB data will be preserved in the `arangodb_data` folder.
    ```bash
    docker-compose down
    ```
-   **Restart Services:**
    ```bash
    docker-compose up -d
    ```

---

## 4. First-Time Database Initialization

The `deploy` scripts no longer initialize the database automatically to avoid errors on subsequent runs. After the **very first time** you launch the backend:

1.  **Verify ArangoDB is running:** Open `http://localhost:8530` in your browser.
2.  **Connect and Create:**
    -   Log in with user `root` and the password from your `.env` file.
    -   Manually create a database named `nuptialFlight`.
    -   Inside that database, create three collections: `flights`, `current`, `historical`.

This is a one-time setup. The data will persist on subsequent `docker-compose up/down` cycles. 